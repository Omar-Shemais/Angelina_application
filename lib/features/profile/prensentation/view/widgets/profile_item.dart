import 'package:angelina_app/core/utils/app_colors/app_colors.dart'
    show AppColors;
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PofileItem extends StatelessWidget {
  const PofileItem({
    super.key,
    required this.leadingIcon,
    required this.text,
    this.textStyle,
    this.onTap,
    this.icon,
    this.showTrailingIcon = true,
  });

  final IconData leadingIcon;
  final String text;
  final TextStyle? textStyle;
  final IconData? icon;
  final void Function()? onTap;
  final bool showTrailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leadingIcon, color: AppColors.primaryColor),
              SizedBox(width: 8.w),
              AppText(title: text),
            ],
          ),
          // if  (showTrailingIcon) Icon(icon ?? Icons.arrow_forward_ios, size: 20),
          showTrailingIcon != true
              ? const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: AppColors.primaryColor,
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
