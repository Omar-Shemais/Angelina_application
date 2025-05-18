import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.btnText,
    this.onTap,
    this.width = double.infinity,
    this.height = 45,
    this.borderRadius,
    this.isLoading = false,
    this.btnColor = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.icon,
    this.iconSpacing = 8,
    this.fontSize = 16,
  });

  final String btnText;
  final void Function()? onTap;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final bool isLoading;
  final Color? btnColor;
  final Color? textColor;
  final Widget? icon;
  final double iconSpacing;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppLoadingIndicator();

    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                btnText,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
              ),
              if (icon != null) ...[SizedBox(width: iconSpacing), icon!],
            ],
          ),
        ),
      ),
    );
  }
}
