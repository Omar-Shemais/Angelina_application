import 'package:angelina_app/features/profile/prensentation/view/widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ProfileViewBody(),
    );
  }
}



/*
  BlocBuilder<CartCubit, CartState>(
                              builder: (context, state) {
                                return ReorderButton(
                                  onPressed: () async {
                                    final cartCubit = context.read<CartCubit>();
                                    bool addedAny = false;

                                    for (final item in items) {
                                      final productId = item['product_id'];

                                      try {
                                        final product =
                                            await ProductRepository()
                                                .fetchProductById(productId);

                                        // FIX: Get the freshest state right before checking
                                        final currentState = cartCubit.state;
                                        final bool isCurrentlyInCart =
                                            currentState is CartLoaded
                                                ? currentState.items.any(
                                                  (p) => p.id == productId,
                                                )
                                                : false;

                                        if (!isCurrentlyInCart) {
                                          await cartCubit.addToCart(
                                            product,
                                            quantity: item['quantity'] ?? 1,
                                          );
                                          addedAny = true;
                                        }
                                      } catch (e) {
                                        // Handle error silently or log it
                                      }
                                    }

                                    if (addedAny) {
                                      showSnackBar(
                                        'تمت إضافة المنتجات إلى السلة',
                                      );
                                    } else {
                                      showSnackBar(
                                        'المنتجات موجودة بالفعل في السلة',
                                      );
                                    }
                                  },
                                );
                              },
                            ),
*/

