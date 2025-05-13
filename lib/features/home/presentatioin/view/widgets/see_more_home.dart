import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SeeMoreHome extends StatelessWidget {
  const SeeMoreHome({super.key, required this.title, this.onTap});
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap,
          child: AppText(
            title: 'المزيد',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        AppText(title: title, fontWeight: FontWeight.w700),
      ],
    );
  }
}
