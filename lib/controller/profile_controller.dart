import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/get_submit_daily_task_model.dart';
import 'package:task_management/model/user_profile_model.dart';
import 'package:task_management/service/user_profile_service.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/submitted_task_pdf_report.dart';

class ProfileController extends GetxController {
  var isProfilePicUploading = false.obs;
  var nameTextEditingController = TextEditingController().obs;
  var emailTextEditingController = TextEditingController().obs;
  var mobileTextEditingController = TextEditingController().obs;
  var dobTextEditingController = TextEditingController().obs;
  var anniversaryDateController = TextEditingController().obs;
  final HomeController homeController = Get.put(HomeController());
  var profilePicPath = "".obs;
  var isPicUpdated = false.obs;
  Rx<File> pickedFile = File('').obs;
  RxList<String> anniversaryList = <String>["DOB", "Marriage Anniversary"].obs;
  RxList<String> genderList = <String>["Male", "Female"].obs;
  RxString? selectedGender = ''.obs;
  RxString? selectedAnniversary = ''.obs;
  var isProfileUpdating = false.obs;
  Future<void> updateProfile(
    String name,
    String email,
    String mobile,
    int? departmentId,
    int? id,
    String? value,
    String dob,
    String anniversaryType,
    String annivresaryDate,
    BuildContext context,
  ) async {
    isProfileUpdating.value = true;
    final result = await ProfileService().updateProfile(
      name,
      email,
      mobile,
      departmentId,
      id,
      value,
      pickedFile,
      dob,
      anniversaryType,
      annivresaryDate,
    );
    if (result != null) {
      await userDetails();
      await homeController.anniversarylist(context);
    } else {}
    isProfileUpdating.value = false;
  }

  var dataFromImagePicker = false.obs;
  var isUserDetailsLoading = false.obs;
  var isValidProfileImage = false.obs;
  RxString userRoleValue = ''.obs;
  Rx<UserProfileModel?> userProfileModel = Rx<UserProfileModel?>(null);
  RxList<AssetsData> assetsList = <AssetsData>[].obs;
  Future<void> userDetails() async {
    isUserDetailsLoading.value = true;
    final result = await ProfileService().userDetails();
    if (result != null) {
      isUserDetailsLoading.value = false;
      userProfileModel.value = result;
      dataFromImagePicker.value = false;
      assetsList.clear();
      if (userProfileModel.value!.data!.assets!.isNotEmpty) {
        assetsList.assignAll(userProfileModel.value!.data!.assets!);
      }
      profilePicPath.value = '';
      await Future.delayed(Duration(milliseconds: 100));
      profilePicPath.value = userProfileModel.value?.data?.image ?? '';
      profilePicPath.refresh();
      nameTextEditingController.value.text =
          userProfileModel.value?.data?.name ?? "";
      emailTextEditingController.value.text =
          userProfileModel.value?.data?.email ?? "";
      mobileTextEditingController.value.text =
          userProfileModel.value?.data?.phone ?? "";
      dobTextEditingController.value.text =
          userProfileModel.value?.data?.dob ?? "";
      anniversaryDateController.value.text =
          userProfileModel.value?.data?.anniversaryDate ?? "";
      selectedAnniversary?.value =
          userProfileModel.value?.data?.anniversaryType ?? "";
      profilePicPath.value = userProfileModel.value?.data?.image ?? "";
      selectedGender?.value = userProfileModel.value?.data?.gender ?? "";
      StorageHelper.setName(userProfileModel.value?.data?.name ?? '');
      StorageHelper.setEmail(userProfileModel.value?.data?.email ?? '');
      StorageHelper.setPhone(userProfileModel.value?.data?.phone ?? '');
      StorageHelper.setRole(userProfileModel.value?.data?.role ?? 0);
      StorageHelper.setDepartmentId(
          userProfileModel.value?.data?.departmentId ?? 0);
      StorageHelper.setGender(userProfileModel.value?.data?.gender ?? '');
      StorageHelper.setImage(userProfileModel.value?.data?.image ?? '');
      StorageHelper.setDob(userProfileModel.value?.data?.dob ?? '');
      refresh();
      if (userProfileModel.value!.data!.image != null) {
        isValidProfileImage.value = false;
      } else {
        if (userProfileModel.value?.data?.image != null) {
          if (userProfileModel.value!.data!.image!.contains('.jpg')) {
            isValidProfileImage.value = true;
          } else {
            isValidProfileImage.value = false;
          }
        }
      }
    } else {}
    isUserDetailsLoading.value = false;
  }

  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  RxList<String> selectedDepartmentListId = <String>[].obs;
  var isdepartmentListLoading = false.obs;
  Rx<DepartmentListData?> selectedDepartMentListData =
      Rx<DepartmentListData?>(null);
  RxList<DepartmentListData> departmentDataList = <DepartmentListData>[].obs;
  Future<void> departmentList(dynamic selectedProjectId) async {
    isdepartmentListLoading.value = true;
    final result = await ProfileService().departmentList(selectedProjectId);
    if (result != null) {
      selectedDepartMentListData.value = null;
      departmentDataList.clear();
      selectedDepartmentListId.clear();
      departmentDataList.add(
        DepartmentListData(
          id: 0,
          name: "Other",
          status: 1,
        ),
      );
      departmentDataList.addAll(result.data!);

      selectedDepartmentListId
          .addAll(List<String>.filled(departmentDataList.length, ''));

      isdepartmentListLoading.value = false;
      for (var deptId in departmentDataList) {
        if (userProfileModel.value?.data?.departmentId.toString() ==
            deptId.id.toString()) {
          selectedDepartMentListData.value = deptId;
          userPageControlelr.roleListApi(
            selectedDepartMentListData.value?.id,
          );
          return;
        }
      }
    } else {}
    isdepartmentListLoading.value = false;
  }

  var isDepartmentAdding = false.obs;
  Future<void> addDepartment(String deptName) async {
    isDepartmentAdding.value = true;
    final result = await ProfileService().addDepartment(deptName);
    if (result != null) {
      Get.back();
      await departmentList(0);
    } else {}
    isDepartmentAdding.value = false;
  }

  var isDailyTaskLoading = false.obs;
  var dailyTaskDataList = [].obs;
  RxList<bool> dailyTaskListCheckbox = <bool>[].obs;
  Future<void> dailyTaskList(BuildContext context, String s) async {
    isDailyTaskLoading.value = true;
    final result = await ProfileService().dailyTaskList();
    if (result != null) {
      isDailyTaskLoading.value = false;
      dailyTaskDataList.clear();
      dailyTaskListCheckbox.clear();
      dailyTaskDataList.assignAll(result['tasks']);
      dailyTaskListCheckbox
          .addAll(List<bool>.filled(dailyTaskDataList.length, false));
      isDailyTaskLoading.value = false;
      if (s == "pastTask") {
        Future.delayed(Duration(milliseconds: 100), () {
          showAlertDialog(context);
        });
      }

      if (dailyTaskDataList.isNotEmpty) {
        for (var dt in dailyTaskDataList) {
          DateTime dateTimedt = DateTime.now();
          String formattedDate = DateFormat("dd-MM-yyyy").format(dateTimedt);

          String dateInput = "${formattedDate} ${dt['task_time']}";
          print('Date input format in profile: $dateInput');

          DateTime? dateTime;
          try {
            DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
            dateTime = inputFormat.parse(dateInput.toLowerCase());
          } catch (e) {
            print("Error parsing with lowercase AM/PM: $e");
          }

          if (dateTime == null) {
            try {
              DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a", 'en_US');
              dateTime = inputFormat.parse(dateInput.toUpperCase());
            } catch (e) {
              print("Error parsing with uppercase AM/PM: $e");
            }
          }

          if (dateTime != null) {
            DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm", 'en_US');
            String dateOutput = outputFormat.format(dateTime);

            List<String> splitDt = dateOutput.split(" ");
            List<String> splitDt2 = splitDt.first.split('-');
            List<String> splitDt3 = splitDt[1].split(':');

            DateTime dtNow = DateTime.now();
            DateTime targetDate = DateTime(
              int.parse(splitDt2.last),
              int.parse(splitDt2[1]),
              int.parse(splitDt2.first),
              int.parse(splitDt3.first),
              int.parse(splitDt3.last),
              0,
            );

            if (targetDate.isAfter(dtNow)) {
              final notificationId =
                  DateTime.now().millisecondsSinceEpoch % 100000;

              LocalNotificationService().scheduleNotification(
                  targetDate, notificationId, dt['task_name'], 'daily-task');
            }
          } else {
            print("Failed to parse date for task: ${dt['task_name']}");
          }
        }
      }
    } else {}
    isDailyTaskLoading.value = false;
  }

  final TextEditingController selectedDateTextController =
      TextEditingController();
  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Obx(
                () => isPreviousTaskLoading.value == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Downloading....',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Download submitted report',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: CustomCalender(
                                  hintText: dateFormate,
                                  controller: selectedDateTextController,
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (selectedDateTextController
                                      .text.isNotEmpty) {
                                    await previousSubmittedTaskLoading(
                                        selectedDateTextController.text);
                                  } else {
                                    CustomToast()
                                        .showCustomToast('Please select date.');
                                  }
                                },
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/png/download_image.png',
                                      height: 30.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  var isDailyTaskAdding = false.obs;
  Future<void> addDailyTask(
      String taskName, BuildContext context, String taskTime) async {
    isDailyTaskAdding.value = true;
    final result = await ProfileService().addDailyTask(taskName, taskTime);
    if (result != null) {
      isDailyTaskAdding.value = false;
      Get.back();
      await dailyTaskList(context, '');
      Get.back();
    } else {
      isDailyTaskAdding.value = false;
    }
    isDailyTaskAdding.value = false;
  }

  var isDailyTaskDeleting = false.obs;
  Future<void> deleteDailyTask(int id, BuildContext context) async {
    isDailyTaskDeleting.value = true;
    final result = await ProfileService().deleteDailyTask(id);
    if (result != null) {
      isDailyTaskDeleting.value = false;
      await dailyTaskList(context, '');
    } else {
      isDailyTaskDeleting.value = false;
    }
    isDailyTaskDeleting.value = false;
  }

  var isDailyTaskEditing = false.obs;
  Future<void> editDailyTask(
      String? taskId, String title, String time, BuildContext context) async {
    isDailyTaskEditing.value = true;
    final result = await ProfileService().editDailyTask(taskId, title, time);
    if (result != null) {
      isDailyTaskEditing.value = false;
      Get.back();
      await dailyTaskList(context, '');
    } else {
      isDailyTaskEditing.value = false;
    }
    isDailyTaskEditing.value = false;
  }

  var isDailyTaskSubmitting = false.obs;
  RxList<DailyTaskSubmitModel> dailyTaskSubmitList =
      <DailyTaskSubmitModel>[].obs;
  Future<void> submitDailyTask(RxList<DailyTaskSubmitModel> dailyTaskSubmitList,
      BuildContext context) async {
    isDailyTaskSubmitting.value = true;
    final result = await ProfileService().submitDailyTask(dailyTaskSubmitList);
    if (result != null) {
      Get.back();
      isDailyTaskSubmitting.value = false;
      await dailyTaskList(context, '');
    } else {
      isDailyTaskSubmitting.value = false;
    }
    isDailyTaskSubmitting.value = false;
  }

  var isPreviousTaskLoading = false.obs;
  RxList<SubmitDailyTasksData> previousSubmittedTask =
      <SubmitDailyTasksData>[].obs;
  Future<void> previousSubmittedTaskLoading(String dateText) async {
    isPreviousTaskLoading.value = true;
    final result = await ProfileService().previousSubmittedTask(dateText);
    if (result != null) {
      previousSubmittedTask.clear();
      previousSubmittedTask.assignAll(result.tasks!);
      Get.back();
      final pdfGenerator = SubmittedTaskPdfReport(
          previousSubmittedTask, result.completedCount, dateText);
      await pdfGenerator.generatePDF();
    } else {
      isPreviousTaskLoading.value = false;
    }
    isPreviousTaskLoading.value = false;
  }

  var isAssestAssigning = false.obs;
  Future<void> assignAssets(
      List<AssetsSubmitModel> assetsList, RxList<String> assignedUserId) async {
    isAssestAssigning.value = true;
    final result =
        await ProfileService().assignAssets(assetsList, assignedUserId);
    if (result != null) {
    } else {
      isAssestAssigning.value = false;
    }
    isAssestAssigning.value = false;
  }

  var isAssestAssignEditing = false.obs;
  Future<void> editAssignAssets(
      int? id,
      TextEditingController? nameTextEditingController,
      TextEditingController? qtyTextEditingController,
      TextEditingController? serialNoTextEditingController) async {
    isAssestAssignEditing.value = true;
    final result = await ProfileService().editAssignAssets(
        id,
        nameTextEditingController,
        qtyTextEditingController,
        serialNoTextEditingController);
    if (result != null) {
      await userDetails();
    } else {
      isAssestAssignEditing.value = false;
    }
    isAssestAssignEditing.value = false;
  }

  var isAssestAssignDeleting = false.obs;
  Future<void> deleteAssignAssets(int? id) async {
    isAssestAssignDeleting.value = true;
    final result = await ProfileService().deleteAssignAssets(id);
    if (result != null) {
      await userDetails();
    } else {
      isAssestAssignDeleting.value = false;
    }
    isAssestAssignDeleting.value = false;
  }
}
