import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/view/screen/attendence/widget/attendence_details.dart';

class AttendenceList extends StatelessWidget {
  final List<AttendenceListData>? list;
  const AttendenceList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: InkWell(
            onTap: () {
              Get.to(
                  () => AttendenceDetail(list?[index] ?? AttendenceListData()));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.r),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 100.w,
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${list![index].checkindate}'),
                              Text('${list![index].checkinday}'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${list![index].approvalStatus}'),
                              Text(
                                  '${list![index].checkintime} - ${list![index].checkouttime}'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 18.h,
                      ),
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
