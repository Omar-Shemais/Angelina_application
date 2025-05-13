import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:angelina_app/features/product_details/presentation/view/widgets/product_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FavoriteCubit()..loadFavorites()),
          BlocProvider(create: (context) => CartCubit()..loadCart()),
        ],
        child: ProductDetailsViewBody(product: product),
      ),
    );
  }
}
