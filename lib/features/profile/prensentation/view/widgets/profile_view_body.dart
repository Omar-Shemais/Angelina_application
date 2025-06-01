import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/profile/prensentation/view/order_history_view.dart';
import 'package:angelina_app/features/profile/prensentation/view/widgets/profile_item.dart';
import 'package:angelina_app/features/profile/prensentation/view/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
          spacing: 20.h,
          children: [
            SizedBox(height: 20.h),
            AppText(
              title: 'My Profile',
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [UserInfo()],
            ),

            Divider(),
            PofileItem(
              leadingIcon: Icons.battery_charging_full,
              text: 'History of order',
              onTap: () {
                RouteUtils.push(OrderHistory());
              },
              showTrailingIcon: false,
            ),

            PofileItem(
              leadingIcon: Icons.privacy_tip_outlined,
              text: 'Privacy & policy',
              onTap: () {},
              showTrailingIcon: false,
            ),
            PofileItem(
              leadingIcon: Icons.help_outline,
              text: 'Help',
              onTap: () {},
              showTrailingIcon: false,
            ),
          ],
        ),
      ),
    );
  }
}
