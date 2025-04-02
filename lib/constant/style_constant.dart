import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextStyle robotoRegular = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 16.sp,
);

TextStyle robotoMedium = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 20.sp,
);
TextStyle robotoNormalMedium = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 20.sp,
);

TextStyle robotoBold = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w700,
  fontSize: 22.sp,
);

TextStyle robotoBlack = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
  fontSize: 18.sp,
);

TextStyle robotoNormalBlack = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 18.sp,
);

TextStyle rubikRegular = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle rubikMedium = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle rubikBold = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);

TextStyle rubikSmall = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
);

TextStyle rubikSmallRegular = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);
TextStyle smallText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
);
TextStyle regularSmallText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 14.sp,
);
TextStyle mediumSizeText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);
TextStyle secondaryMediumSizeText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 14.sp,
);

TextStyle rubikVerySmall = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 10.sp,
);
TextStyle miniRubikVerySmall = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 10.sp,
);

TextStyle rubikBlack = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w500,
  fontSize: 16.sp,
);
TextStyle boldText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.bold,
  fontSize: 20.sp,
);

TextStyle changeTextColor(TextStyle textStyle, Color color) {
  return textStyle.copyWith(color: color);
}
