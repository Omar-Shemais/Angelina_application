import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:angelina_app/features/payment/presentation/view/user_info.dart';
import 'package:angelina_app/features/profile/prensentation/view/widgets/histroy_proudct_title.dart';
import 'package:flutter/material.dart';
import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    final orders = await CachingUtils.getOrderHistory();

    setState(() {
      _orders = orders.reversed.toList(); // Show latest first
      _isLoading = false;
    });
  }

  String formatDate(String dateString) {
    try {
      final dateParts = dateString.split('T').first.split('-');
      if (dateParts.length == 3) {
        return "${dateParts[0]}/${dateParts[1]}/${dateParts[2]}";
      }
      return dateString.split('T').first;
    } catch (e) {
      return dateString.split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit()..loadCart(),
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(
            title: 'الطلبات السابقة',
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
                : _orders.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_outlined,
                        size: 80.sp,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      const AppText(
                        title: 'لا توجد طلبات سابقة',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: _orders.length,
                  itemBuilder: (context, orderIndex) {
                    final order = _orders[orderIndex];
                    final items = order['items'] as List;
                    final orderTotal = order['total'] / 100;
                    final orderDate = formatDate(order['date']);

                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          childrenPadding: EdgeInsets.only(bottom: 12.h),
                          collapsedBackgroundColor: Colors.white,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  color: AppColors.primaryColor,
                                  size: 22.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      title: "طلب #${orderIndex + 1}",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.boldTextColor,
                                    ),
                                    SizedBox(height: 4.h),
                                    AppText(
                                      title: orderDate,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    AppText(
                                      title: orderTotal.toString(),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    AppText(
                                      title: 'ر.س ',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Divider(
                              height: 20.h,
                              thickness: 1,
                              indent: 16.w,
                              endIndent: 16.w,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            SizedBox(height: 8.h),
                            ...items.map<Widget>((item) {
                              return FutureBuilder<ProductModel>(
                                future: ProductRepository().fetchProductById(
                                  item['product_id'],
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return _buildLoadingProductTile();
                                  } else if (snapshot.hasError) {
                                    return _buildErrorProductTile();
                                  } else if (snapshot.hasData) {
                                    final product = snapshot.data!;
                                    return HistroyProudctTitle(
                                      product: product,
                                      item: item,
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              );
                            }).toList(),
                            SizedBox(height: 8.h),

                            BlocBuilder<CartCubit, CartState>(
                              builder: (context, state) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                  ),
                                  child: OutlinedButton.icon(
                                    icon: Icon(
                                      Icons.replay,
                                      size: 16.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    label: const AppText(
                                      title: "إعادة الطلب",
                                      fontSize: 14,
                                      color: AppColors.primaryColor,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primaryColor,
                                      side: BorderSide(
                                        color: AppColors.primaryColor,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final cartCubit =
                                          context.read<CartCubit>();
                                      final List<CartProductModel>
                                      reorderedItems = [];

                                      for (final item in items) {
                                        final productId = item['product_id'];

                                        try {
                                          final product =
                                              await ProductRepository()
                                                  .fetchProductById(productId);

                                          reorderedItems.add(
                                            CartProductModel(
                                              id: product.id,
                                              name: product.name,
                                              price: product.price,
                                              quantity: item['quantity'] ?? 1,
                                              imageUrls: product.imageUrls,
                                              categories: product.categories,
                                              categoryIds: product.categoryIds,
                                            ),
                                          );
                                        } catch (e) {}
                                      }

                                      final finalTotal = reorderedItems
                                          .fold<double>(
                                            0.0,
                                            (sum, item) =>
                                                sum +
                                                ((double.tryParse(
                                                          item.price.toString(),
                                                        ) ??
                                                        0.0) *
                                                    item.quantity),
                                          );

                                      final totalPriceCents =
                                          (finalTotal * 100).toInt();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => BlocProvider.value(
                                                value: cartCubit,
                                                child: UserInfoPage(
                                                  totalPriceCents:
                                                      totalPriceCents,
                                                  reorderedItems:
                                                      reorderedItems,
                                                  shouldClearCart: false,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildLoadingProductTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 14.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorProductTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: AppText(
                title: 'فشل تحميل بيانات المنتج',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
