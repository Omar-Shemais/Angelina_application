import 'dart:async';
import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      RouteUtils.pushAndPopAll(const HomeNavigationBar());
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image(
          image: const AssetImage('assets/images/logo.png'),
          fit: BoxFit.cover,
          width: 70.w,
          height: 70.h,
        ),
        // SvgPicture.asset(
        //   'assets/icons/logo.svg',
        //   height: 200.h,
        //   width: 200.w,
        //   fit: BoxFit.contain,
        // ),
      ),
    );
  }
}
// import 'dart:async';
// import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
// import 'package:flutter/material.dart';

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   _SplashViewState createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   @override
//   void initState() {
//     super.initState();

//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeNavigationBar()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           height: 150,
//           width: 150,
//           child: Column(children: [Image.asset('assets/images/logo.png')]),
//         ),
//       ),
//     );
//   }
// }
