import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.secondaryColor,
        child: ListView(
          children: [
            DrawerHeader(child: Image.asset('assets/images/logo.png')),
            ListTile(
              title: AppText(title: 'الرئيسية'),
              onTap: () {
                RouteUtils.pop();
              },
            ),
            ListTile(
              title: AppText(title: 'المفضله'),
              onTap: () {
                RouteUtils.puAshReplacement(
                  HomeNavigationBar(selectedIndex: 1),
                );
              },
            ),
            ListTile(
              title: AppText(title: 'العربه'),
              onTap: () {
                RouteUtils.puAshReplacement(
                  HomeNavigationBar(selectedIndex: 2),
                );
              },
            ),
            ListTile(
              title: AppText(title: 'الملف الشخصي'),
              onTap: () {
                RouteUtils.puAshReplacement(
                  HomeNavigationBar(selectedIndex: 3),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
