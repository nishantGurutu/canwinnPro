import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';

class CustomTimer extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  CustomTimer({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.access_time,
          color: secondaryColor,
        ),
        hintText: hintText,
        hintStyle: rubikRegular,
        fillColor: lightSecondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightSecondaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          // Format time as "hh:mm a" (e.g., 05:30 PM)
          final now = DateTime.now();
          final selectedTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          String formattedTime = DateFormat('hh:mm a').format(selectedTime);
          controller.text = formattedTime;
        }
      },
    );
  }
}
