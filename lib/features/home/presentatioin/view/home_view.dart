import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
// import 'package:angelina_app/features/home/data/repo/category_repo.dart';
// import 'package:angelina_app/features/home/data/repo/product_repo.dart';
// import 'package:angelina_app/features/home/manger/category_cubit/category_cubit.dart';
// import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/custom_drawer.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FavoriteCubit()..loadFavorites()),
        ],
        child: HomeViewBody(),
      ),
    );
  }
}
