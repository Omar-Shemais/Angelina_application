import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropMenu extends StatefulWidget {
  final List<String> colors;

  const CustomDropMenu({super.key, required this.colors});

  @override
  State<CustomDropMenu> createState() => _CustomDropMenuState();
}

class _CustomDropMenuState extends State<CustomDropMenu> {
  String dropdownvalue = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 29.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            widget.colors.isEmpty ? 'لا توجد ألوان' : 'تحديد أحد الخيارات',
            style: TextStyle(fontSize: 8.7),
            textAlign: TextAlign.right,
          ),
          value: dropdownvalue.isEmpty ? null : dropdownvalue,
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
          alignment: Alignment.centerRight,
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          items:
              widget.colors.map((String color) {
                return DropdownMenuItem<String>(
                  value: color,
                  child: Text(color, style: TextStyle(fontSize: 14)),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownvalue = newValue!;
            });
          },
        ),
      ),
    );
  }
}
