import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_management/constant/color_constant.dart';

class TaskInfo extends StatelessWidget {
  final String s;
  final int totalTask;
  final String icon;
  final Color color;
  const TaskInfo(this.s, this.totalTask, this.icon, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: lightGreyColor.withOpacity(0.1),
            blurRadius: 13.0,
            spreadRadius: 2,
            blurStyle: BlurStyle.normal,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.r),
                ),
              ),
              child: icon.toString().toLowerCase().contains(".svg")
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "$icon",
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image.asset('$icon'),
                    ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$s',
                  // '${index == 0 ? "Total Task" : index == 1 ? "Assigned" : index == 2 ? "Due today" : "Past due date"}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$totalTask',
                  // '${index == 0 ? totalTask : index == 1 ? totalTaskAssigned : index == 2 ? dueTodayTask : totalTasksPastDue}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
