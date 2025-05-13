import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/Favorite/presentation/view/widgets/favourite_view_body.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteView extends StatelessWidget {
  const FavouriteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FavoriteCubit()..loadFavorites()),
          BlocProvider(create: (context) => CartCubit()..loadCart()),
        ],
        child: FavouriteViewBody(),
      ),
    );
  }
}
