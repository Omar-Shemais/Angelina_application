import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors/app_colors.dart' show AppColors;

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.onChange,
    this.isObsecure,
    this.onTap,
    this.controller,
    this.textInputAction,
    this.validator,
    this.hasUnderline = false,
    this.height,
    this.width,
    this.borderRadius, // New customizable radius
    this.keyboardType,
    this.readOnly, // New customizable keyboardType
  });

  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChange;
  final bool? isObsecure;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final bool hasUnderline;

  final double? height; // New
  final double? width; // New
  final BorderRadiusGeometry? borderRadius; // New
  final TextInputType? keyboardType; // New
  final bool? readOnly; // 🔥 add this

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 0.w, left: 0.w),
      child: SizedBox(
        height: widget.height?.h,
        width: widget.width?.w,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
            color: _isFocused ? AppColors.secondaryColor : AppColors.white,
          ),
          child: TextFormField(
            textAlign: TextAlign.right,
            readOnly: widget.readOnly ?? false,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            focusNode: _focusNode,
            cursorColor: AppColors.black,
            cursorWidth: 1,
            obscureText: widget.isObsecure ?? false,
            onChanged: widget.onChange,
            onTap: widget.onTap,
            controller: widget.controller,
            validator: widget.validator,
            textInputAction: widget.textInputAction,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              hintText: _isFocused ? '' : widget.hint,
              hintStyle: TextStyle(
                color: AppColors.lightTextColor,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w900,
                fontSize: 14.w,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 15.h,
                horizontal: 20.w,
              ),
              border:
                  widget.hasUnderline
                      ? const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightTextColor,
                          width: 1,
                        ),
                      )
                      : InputBorder.none,
              focusedBorder:
                  widget.hasUnderline
                      ? const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightTextColor,
                          width: 1,
                        ),
                      )
                      : InputBorder.none,
              enabledBorder:
                  widget.hasUnderline
                      ? const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.lightTextColor,
                          width: 1,
                        ),
                      )
                      : InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
