import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/view/screen/task_details.dart';

class HomeTaskList extends StatelessWidget {
  final RxList homeTaskList;
  HomeTaskList(this.homeTaskList, {super.key});
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: homeTaskList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () {},
            onTap: () {
              Get.to(TaskDetails(
                  taskId: homeTaskList[index]['id'],
                  assignedStatus: taskController.selectedAssignedTask.value));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 45.h,
                        width: 45.h,
                        decoration: BoxDecoration(
                          color: Color(0xffF4E2FF),
                          borderRadius:
                              BorderRadius.all(Radius.circular(22.5.h)),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 160.w,
                                  child: Text(
                                    '${homeTaskList[index]['title'] ?? ""}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${homeTaskList[index]['task_date'] ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              '${homeTaskList[index]['description'] ?? ""}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff262626).withOpacity(0.38)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
