import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCounter extends StatefulWidget {
  const CustomCounter({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  final int quantity;
  final void Function(int) onQuantityChanged; // callback when quantity changes

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity;
  }

  void _increment() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(quantity); // notify parent
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity); // notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      width: 159.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _decrement,
            child: Icon(Icons.remove, color: AppColors.primaryColor),
          ),
          AppText(title: quantity.toString(), color: AppColors.boldTextColor),
          GestureDetector(
            onTap: _increment,
            child: Icon(Icons.add, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
