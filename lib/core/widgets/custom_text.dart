import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.title,
    this.maxLines,
    this.color = AppColors.boldTextColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w400,
    this.textDecoration = TextDecoration.none,
    this.overflow,
    this.textAlign,
    this.cutoff,
  });

  final String title;
  final int? maxLines;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration textDecoration;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? cutoff;

  @override
  Widget build(BuildContext context) {
    String displayTitle = title;
    if (cutoff != null) {
      displayTitle = truncateWithEllipsis(cutoff!, title);
    }
    return Text(
      displayTitle,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        fontFamily: 'Roboto',
        decoration: textDecoration,
        overflow: overflow,
      ),
    );
  }
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}
