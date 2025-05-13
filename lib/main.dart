import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/caching_utils/caching_utils.dart';
import 'package:angelina_app/core/utils/notification_utils/notification_utils.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/home/data/repo/category_repo.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:angelina_app/features/home/manger/category_cubit/category_cubit.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
import 'package:angelina_app/features/splash/presentaion/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachingUtils.init();
  await ScreenUtil.ensureScreenSize();
  // Initialize notification service
  await NotificationService.init();

  // Request permission to show notifications
  await requestNotificationPermission();

  final productCubit = ProductCubit(ProductRepository());

  // Start checking for new products periodically
  await productCubit.checkForNewProducts();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (_) => CartCubit()..loadCart(), // load on startup
        ),
        BlocProvider(
          create:
              (context) =>
                  ProductCubit(ProductRepository())..fetchInitialProducts(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(CategoryRepo())..fetchCategories(),
        ),
        // Add other Cubits if needed
        BlocProvider(create: (context) => FavoriteCubit()..loadFavorites()),
      ],
      child: const AngelinaApp(),
    ),
  );
}

class AngelinaApp extends StatelessWidget {
  const AngelinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RouteUtils.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primaryColor,
          selectionColor: AppColors.lightTextColor,
          selectionHandleColor: AppColors.primaryColor,
        ),
        primaryColor: Color(0xff355B5E),
      ),
      builder: (context, child) {
        ScreenUtil.init(context, designSize: const Size(375, 812));
        return child!;
      },
      routes: {
        '/home':
            (context) => HomeNavigationBar(
              selectedIndex: 0,
            ), // Replace with your actual Cart screen
      },
      title: "Angelina",
      home: const SplashView(),
    );
  }
}
