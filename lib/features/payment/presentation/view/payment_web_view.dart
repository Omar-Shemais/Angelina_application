import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/app_dialog.dart';
import 'package:angelina_app/core/widgets/app_loading_indicator.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
import 'package:angelina_app/features/payment/data/repo/paymob_repo.dart';
import 'package:angelina_app/features/payment/data/repo/user_info_request.dart';
import 'package:angelina_app/features/payment/manger/payment_cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String firstName, lastName, email, phone, address1, city, country;
  final List<Map<String, dynamic>> lineItems;
  final List<CartProductModel> reorderedItems;
  final bool shouldClearCart; // 👈 Add this

  final int totalPriceCents;

  const PaymentWebViewPage({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address1,
    required this.city,
    required this.country,
    required this.totalPriceCents,
    required this.lineItems,
    required this.reorderedItems,
    required this.shouldClearCart,
  });

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final PaymentCubit cubit;
  WebViewController? _controller;

  Future<void> sendOrder() async {
    final enrichedItems =
        widget.lineItems.map((item) {
          return {
            'product_id': item['product_id'],
            'quantity': item['quantity'],
          };
        }).toList();
    final success = await OrderRepo.sendOrder(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      phone: widget.phone,
      address1: widget.address1,
      city: widget.city,
      country: widget.country,
      lineItems: widget.lineItems,
    );

    if (success) {
      await CachingUtils.saveOrder({
        'date': DateTime.now().toIso8601String(),
        'firstName': widget.firstName,
        'lastName': widget.lastName,
        'email': widget.email,
        'phone': widget.phone,
        'address': widget.address1,
        'city': widget.city,
        'country': widget.country,
        'items': enrichedItems,
        'total': widget.totalPriceCents,
      });

      // ⏳ Wait and navigate
      // await Future.delayed(Duration(seconds: 3));
      _navigateToCart(
        clearCart: widget.shouldClearCart,
        message: 'تم الدفع بنجاح',
        isError: false,
      );
    } else {
      // ❌ Show error message
      _navigateToCart(
        clearCart: false,
        message: 'فشلت عملت الدفع',
        isError: true,
      );
      showSnackBar('فشل في إتمام الطلب. حاول مرة أخرى.', isError: true);
    }
  }

  @override
  void initState() {
    super.initState();
    cubit = PaymentCubit(PaymobRepo());
    cubit.startPayment(widget.totalPriceCents);
  }

  void _navigateToCart({
    required bool clearCart,
    required String message,
    required bool isError,
  }) {
    if (clearCart) {
      context.read<CartCubit>().clearCart();
    }
    showSnackBar(message, isError: isError);
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            AppDialog.show(
              context,
              message: 'هل انت متاكد من الغاء عمليه الدفع؟',
              confirmTitle: 'الغاء',
              onConfirm: () {
                Navigator.pop(context);
                RouteUtils.push(HomeNavigationBar(selectedIndex: 0));
              },
            );
          },
          child: Icon(Icons.close),
        ),
        centerTitle: true,
        title: Text('الدفع'),
        backgroundColor: AppColors.white,
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        bloc: cubit,
        listener: (context, state) async {
          if (state is PaymentSuccess) {
            final url =
                "https://accept.paymob.com/api/acceptance/iframes/916101?payment_token=${state.paymentKey}";

            _controller =
                WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (url) async {
                        try {
                          final String lowerUrl = url.toLowerCase();
                          if (url.toLowerCase().contains("success=true")) {
                            await sendOrder();
                            // _navigateToCart(
                            //   clearCart: true,
                            //   message: 'تم الدفع بنجاح',
                            //   isError: false,
                            // );
                          } else if (lowerUrl.contains("fail") ||
                              lowerUrl.contains("error") ||
                              lowerUrl.contains("success=false") ||
                              lowerUrl.contains("declined") ||
                              lowerUrl.contains("rejected")) {
                            _navigateToCart(
                              clearCart: false,
                              message: 'فشلت عملت الدفع',
                              isError: true,
                            );
                          } else {
                            final jsResult = await _controller!
                                .runJavaScriptReturningResult(
                                  "window.document.body.innerText",
                                );
                            final bodyText = jsResult.toString().toLowerCase();
                            // print("🧾 JS Result: $bodyText");

                            if (bodyText.contains("success")) {
                              _navigateToCart(
                                clearCart: true,
                                message: 'تم الدفع بنجاح',
                                isError: false,
                              );
                            } else if (bodyText.contains("failed")) {
                              _navigateToCart(
                                clearCart: false,
                                message: 'فشلت عملت الدفع',
                                isError: true,
                              );
                            }
                          }
                        } catch (e) {
                          print("⚠️ Error reading payment result: $e");
                        }
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(url));

            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: AppLoadingIndicator());
          } else if (state is PaymentSuccess && _controller != null) {
            return WebViewWidget(controller: _controller!);
          } else if (state is PaymentError) {
            print(state.message);
            return Center(child: Text('فشل الدفع: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
