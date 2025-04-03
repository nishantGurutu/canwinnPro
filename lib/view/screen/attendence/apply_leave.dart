import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/leave_type_model.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  final AttendenceController attendenceController = Get.find();
  final TextEditingController leaveStartDateController =
      TextEditingController();
  final TextEditingController leaveEndDateController = TextEditingController();
  final TextEditingController leaveDurationController = TextEditingController();
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController leaveDescriptionController =
      TextEditingController();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    attendenceController.leaveTypeLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          applyLeave,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: applyLeaveBottomSheet(
                          context,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      color: whiteColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: Text(
                        'Apply Leave',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 3,
            //     itemBuilder: (context, index) {
            //       return Container();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget applyLeaveBottomSheet(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 420.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Leave Start Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender(
                      hintText: dateFormate,
                      controller: leaveStartDateController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave End Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomCalender(
                      hintText: dateFormate,
                      controller: leaveEndDateController,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Type',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomDropdown<LeaveTypeData>(
                      items: attendenceController.leaveTypeList,
                      itemLabel: (item) => item.name ?? "",
                      selectedValue: null,
                      onChanged: (value) {
                        attendenceController.selectedLeaveType.value = value;
                      },
                      hintText: selectPriority,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Leave Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    TaskCustomTextField(
                      controller: leaveDescriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      data: taskName,
                      hintText: enterLeaveDescription,
                      labelText: enterLeaveDescription,
                      index: 4,
                      focusedIndexNotifier: focusedIndexNotifier,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => CustomButton(
                        onPressed: () async {
                          if (attendenceController.isApplyingLeave.value ==
                              false) {
                            await attendenceController.aplyingLeave(
                              leaveStartDateController.text,
                              leaveEndDateController.text,
                              leaveDurationController.text,
                              leaveTypeController.text,
                              leaveDescriptionController.text,
                            );
                          }
                        },
                        text: attendenceController.isApplyingLeave.value == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    loading,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: whiteColor),
                                  ),
                                ],
                              )
                            : Text(
                                submit,
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        width: double.infinity,
                        color: primaryColor,
                        height: 45.h,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
                Positioned(
                  right: 1,
                  child: Container(
                    width: 20.w,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
