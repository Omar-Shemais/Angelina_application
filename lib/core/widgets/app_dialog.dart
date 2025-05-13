import 'package:angelina_app/core/widgets/custom_button.dart' show AppButton;
import 'package:angelina_app/core/widgets/custom_text.dart' show AppText;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors/app_colors.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.message,
    required this.confirmTitle,
    required this.onConfirm,
    this.onCancel,
  });

  static void show(
    BuildContext context, {
    required String message,
    String confirmTitle = 'Save',
    required void Function() onConfirm,
    void Function()? onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      barrierColor: AppColors.black.withOpacity(0.5),
      builder:
          (context) => AppDialog(
            message: message,
            confirmTitle: confirmTitle,
            onConfirm: onConfirm,
            onCancel: onCancel,
          ),
    );
  }

  final String message;
  final String confirmTitle;
  final void Function() onConfirm;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            AppText(
              title: 'الغاء عمليه الدفع',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            AppText(
              title: message,
              color: AppColors.lightTextColor,
              textAlign: TextAlign.center,
            ),

            AppButton(
              btnText: 'الغاء',
              textColor: AppColors.primaryColor,
              onTap: onConfirm,
              btnColor: AppColors.white,
              width: double.infinity,
            ),

            AppButton(
              btnText: 'متابعه',
              width: double.infinity,
              onTap: () {
                if (onCancel == null) {
                  Navigator.pop(context);
                  return;
                }
                onCancel!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
