import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    required this.text,
    this.textColor = AppColors.black,
  });
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: <Widget>[
          const Expanded(child: Divider(color: AppColors.black, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppText(
              title: text,
              fontWeight: FontWeight.w400,
              color: textColor,
              fontSize: 16,
            ),
          ),
          const Expanded(child: Divider(color: AppColors.black, thickness: 1)),
        ],
      ),
    );
  }
}
