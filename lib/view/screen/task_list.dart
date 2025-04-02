// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/costom_select_attachment.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/screen/task_details.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';
import 'package:task_management/view/widgets/edit_class.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';

class TaskListPage extends StatefulWidget {
  final String taskType;
  final String assignedType;
  final String? navigationType;
  final String? userId;
  const TaskListPage(this.navigationType, this.userId,
      {super.key, required this.taskType, required this.assignedType});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    taskController.pagevalue.value = 1;
    taskController.selectedAssignedTask.value = widget.assignedType;
    _scrollController.addListener(_scrollListener);
    taskController.checkAllTaskList.clear();
    taskController.allTaskList.clear();
    taskController.newTaskList.clear();
    taskController.progressTaskList.clear();
    taskController.completeTaskList.clear();
    taskController.pagevalue.value = 1;
    taskController.responsiblePersonListApi(
        profileController.selectedDepartMentListData.value?.id);
    taskController.selectedTaskType.value = widget.taskType;
    taskController.selectedAssignedTask.value = widget.assignedType;
    priorityController.priorityApi();
    taskController.allProjectListApi();
    taskController.taskListApi(
        widget.taskType,
        taskController.selectedAssignedTask.value,
        'initstate',
        '',
        widget.userId);
    super.initState();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      taskController.pagevalue.value += 1;
      taskController.taskListApi(
          widget.taskType,
          taskController.selectedAssignedTask.value,
          'scroll',
          '',
          widget.userId);
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      taskController.pagevalue.value -= 1;
      taskController.taskListApi(
          widget.taskType,
          taskController.selectedAssignedTask.value,
          'scroll',
          '',
          widget.userId);
    }
  }

  List<Color> colorList = [backgroundColor, whiteColor];

  @override
  void dispose() {
    _scrollController.dispose();
    taskController.isProgressStatus?.value = false;
    profileController.selectedDepartMentListData.value = null;
    taskController.selectedTaskType.value = 'All Task';
    taskController.selectedAssignedTask.value = 'Task created by me';
    super.dispose();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      taskController.isProfilePicUploading.value = true;
      taskController.pickedFile.value = File(pickedImage.path);
      taskController.profilePicPath.value = pickedImage.path.toString();
      taskController.isProfilePicUploading.value = false;
    } catch (e) {
      taskController.isProfilePicUploading.value = false;
    } finally {
      taskController.isProfilePicUploading.value = false;
    }
  }

  bool _isBackButtonPressed = false;
  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      if (widget.navigationType == "notification") {
        Get.offAll(() => SplashScreen());
      } else {
        Get.back();
      }
      return true;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              if (widget.navigationType.toString() == 'notification') {
                Get.offAll(() => SplashScreen());
              } else {
                Get.back();
              }
            },
            icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
          ),
          title: Text(
            task,
            style: TextStyle(
                color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130.w,
                      height: 40.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              items: taskController.taskType.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Roboto',
                                      color: darkGreyColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              value:
                                  taskController.selectedTaskType.value.isEmpty
                                      ? null
                                      : taskController.selectedTaskType.value,
                              onChanged: (String? value) {
                                taskController.updateTaskType(value);
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border:
                                      Border.all(color: lightSecondaryColor),
                                  color: lightSecondaryColor,
                                ),
                              ),
                              hint: Text(
                                'Select Task'.tr,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontFamily: 'Roboto',
                                  color: darkGreyColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              iconStyleData: IconStyleData(
                                icon: Image.asset(
                                  'assets/images/png/Vector 3.png',
                                  color: secondaryColor,
                                  height: 8.h,
                                ),
                                iconSize: 14,
                                iconEnabledColor: lightGreyColor,
                                iconDisabledColor: lightGreyColor,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 330,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: lightSecondaryColor,
                                    border:
                                        Border.all(color: lightSecondaryColor)),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        profileController.profilePicPath.value = '';
                        taskNameController.clear();
                        remarkController.clear();
                        startDateController.clear();
                        dueDateController.clear();
                        dueTimeController.clear();

                        profileController.selectedDepartMentListData.value =
                            null;

                        taskController.assignedUserId.clear();
                        taskController.reviewerUserId.clear();
                        taskController.reviewerCheckBox.clear();
                        taskController.responsiblePersonSelectedCheckBox
                            .clear();
                        taskController.responsiblePersonSelectedCheckBox.addAll(
                            List<bool>.filled(
                                taskController.responsiblePersonList.length,
                                false));
                        taskController.reviewerCheckBox.addAll(
                            List<bool>.filled(
                                taskController.responsiblePersonList.length,
                                false));

                        taskController.profilePicPath.value = '';
                        priorityController.selectedPriorityData.value == null;

                        taskController.selectedAllProjectListData.value = null;
                        profileController.selectedDepartMentListData.value =
                            null;
                        taskController.selectedAllProjectListData.value =
                            taskController.allProjectDataList.first;

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: addTaskBottomSheet(
                              context,
                              priorityController.priorityList,
                              taskController.allProjectDataList,
                              taskController.responsiblePersonList,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 40.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.add,
                                  color: whiteColor,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                addTask,
                                style:
                                    changeTextColor(rubikRegular, whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            items: taskController.taskSelectedType
                                .map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            value: taskController
                                    .selectedAssignedTask.value.isEmpty
                                ? null
                                : taskController.selectedAssignedTask.value,
                            onChanged: (String? value) {
                              taskController.updateAssignedTask(value);
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(color: lightSecondaryColor),
                                color: lightSecondaryColor,
                              ),
                            ),
                            hint: Text(
                              'Select Task Type'.tr,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontFamily: 'Roboto',
                                color: darkGreyColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            iconStyleData: IconStyleData(
                              icon: Image.asset(
                                'assets/images/png/Vector 3.png',
                                color: secondaryColor,
                                height: 8.h,
                              ),
                              iconSize: 14,
                              iconEnabledColor: lightGreyColor,
                              iconDisabledColor: lightGreyColor,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 330,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: lightSecondaryColor,
                                  border:
                                      Border.all(color: lightSecondaryColor)),
                              offset: const Offset(0, 0),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: WidgetStateProperty.all<double>(6),
                                thumbVisibility:
                                    WidgetStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160.w,
                      child: TextField(
                        controller: dueDateController,
                        decoration: InputDecoration(
                          fillColor: lightSecondaryColor,
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Image.asset(
                              'assets/images/png/callender.png',
                              color: secondaryColor,
                              height: 10.h,
                            ),
                          ),
                          hintText: dateFormate,
                          hintStyle: rubikRegular,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: lightSecondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightSecondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightSecondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightSecondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(pickedDate);
                            dueDateController.text = formattedDate;
                            taskController.taskListApi(
                                widget.taskType,
                                widget.assignedType,
                                '',
                                dueDateController.text,
                                widget.userId);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Obx(
                    () => taskController.isTaskLoading.value == true
                        ? SizedBox(
                            height: 700.h,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  taskController.todayTaskDate.value,
                                  style: rubikBold,
                                ),
                              ),
                              Obx(
                                () => taskController.selectedTaskType.value ==
                                        "All Task"
                                    ? allTaskList(taskController.allTaskList)
                                    : taskController.selectedTaskType.value ==
                                                "New Task" ||
                                            taskController
                                                    .selectedTaskType.value ==
                                                "Past Due" ||
                                            taskController
                                                    .selectedTaskType.value ==
                                                "Due Today"
                                        ? newTaskList(
                                            taskController.newTaskList)
                                        : taskController
                                                    .selectedTaskType.value ==
                                                "Progress"
                                            ? progressTaskList(
                                                taskController.progressTaskList)
                                            : completeTaskList(taskController
                                                .completeTaskList),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController taskNameController3 = TextEditingController();
  final TextEditingController remarkController3 = TextEditingController();
  final TextEditingController startDateController3 = TextEditingController();
  final TextEditingController dueDateController3 = TextEditingController();
  final TextEditingController dueTimeController3 = TextEditingController();
  Widget allTaskList(RxList newTaskList) {
    return Obx(
      () => taskController.isTaskLoading.value == true
          ? Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : newTaskList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No data',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: newTaskList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == newTaskList.length) {
                        return Obx(
                            () => taskController.isScrolling.value == true
                                ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink());
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: InkWell(
                          onTap: () {
                            Get.to(TaskDetails(
                                taskId: newTaskList[index]['id'],
                                assignedStatus:
                                    taskController.selectedAssignedTask.value));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: lightGreyColor.withOpacity(0.2),
                                  blurRadius: 13.0,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Task ID ${newTaskList[index]['id']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: newTaskList[index]
                                                          ['is_late_completed']
                                                      .toString()
                                                      .toLowerCase() !=
                                                  "0"
                                              ? redColor
                                              : textColor,
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        height: 30.h,
                                        width: 25.w,
                                        child: PopupMenuButton<String>(
                                          color: whiteColor,
                                          constraints: BoxConstraints(
                                            maxWidth: 200.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.r)),
                                          shadowColor: lightGreyColor,
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (String result) {
                                            switch (result) {
                                              case 'edit':
                                                for (var projectData
                                                    in projectController
                                                        .allProjectDataList) {
                                                  if (projectData.id
                                                          .toString() ==
                                                      newTaskList[index]
                                                              ['project_id']
                                                          .toString()) {
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value = projectData;
                                                    profileController
                                                        .departmentList(
                                                            projectController
                                                                .selectedAllProjectListData
                                                                .value
                                                                ?.id);
                                                    break;
                                                  }
                                                }
                                                taskController
                                                    .responsiblePersonListApi(
                                                        profileController
                                                            .selectedDepartMentListData
                                                            .value
                                                            ?.id);
                                                taskNameController3.text =
                                                    newTaskList[index]['title'];
                                                remarkController3.text =
                                                    newTaskList[index]
                                                        ['description'];
                                                startDateController3.text =
                                                    newTaskList[index]
                                                        ['start_date'];
                                                dueDateController3.text =
                                                    newTaskList[index]
                                                        ['due_date'];
                                                dueTimeController3.text =
                                                    newTaskList[index]
                                                        ['due_time'];

                                                for (var priorityData
                                                    in priorityController
                                                        .priorityList) {
                                                  if (priorityData.id
                                                          .toString() ==
                                                      newTaskList[index]
                                                              ['priority']
                                                          .toString()) {
                                                    priorityController
                                                        .selectedPriorityData
                                                        .value = priorityData;
                                                    break;
                                                  }
                                                }

                                                for (var deptData
                                                    in profileController
                                                        .departmentDataList) {
                                                  if (deptData.id.toString() ==
                                                      newTaskList[index]
                                                              ['department_id']
                                                          .toString()) {
                                                    profileController
                                                        .selectedDepartMentListData
                                                        .value = deptData;
                                                    break;
                                                  }
                                                }
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child: EditTaskClass()
                                                        .editTaskBottomSheet(
                                                            context,
                                                            priorityController
                                                                .priorityList,
                                                            projectController
                                                                .allProjectDataList,
                                                            taskController
                                                                .responsiblePersonList,
                                                            newTaskList[index]
                                                                ['id'],
                                                            taskNameController3,
                                                            remarkController3,
                                                            startDateController3,
                                                            dueDateController3,
                                                            dueTimeController3),
                                                  ),
                                                );
                                                break;
                                              case 'delete':
                                                taskController.deleteTask(
                                                    newTaskList[index]['id']);
                                                break;
                                              case 'status':
                                                taskController.isCompleteStatus
                                                    ?.value = false;
                                                taskController.isProgressStatus
                                                    ?.value = false;
                                                statusRemarkController.clear();
                                                taskController
                                                    .profilePicPath2.value = '';
                                                changeStatusDialog(
                                                  context,
                                                  newTaskList[index]['id'],
                                                  newTaskList[index]['status'],
                                                  newTaskList[index]
                                                      ['parent_id'],
                                                  newTaskList[index]
                                                      ['is_subtask_completed'],
                                                  newTaskList[index]
                                                      ['effective_status'],
                                                );
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<String>>[
                                            if (taskController
                                                    .selectedAssignedTask
                                                    .value ==
                                                "Task created by me")
                                              PopupMenuItem<String>(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    "assets/images/png/edit-icon.png",
                                                    height: 20.h,
                                                  ),
                                                  title: Text(
                                                    'Edit',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            if (taskController
                                                    .selectedAssignedTask
                                                    .value ==
                                                "Task created by me")
                                              PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    'assets/images/png/delete-icon.png',
                                                    height: 20.h,
                                                  ),
                                                  title: Text(
                                                    'Delete',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            if (taskController
                                                    .selectedAssignedTask
                                                    .value ==
                                                "Assigned to me")
                                              PopupMenuItem<String>(
                                                value: 'status',
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    'assets/images/png/document.png',
                                                    height: 20.h,
                                                  ),
                                                  title: Text(
                                                    'Change Status',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '${newTaskList[index]['title']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: newTaskList[index]
                                                      ['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    '${newTaskList[index]['description']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: newTaskList[index]
                                                      ['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 4.h),
                                          child: Text(
                                            '${newTaskList[index]['priority_name']}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'medium'
                                                  ? mediumColor
                                                  : newTaskList[index][
                                                                  'priority_name']
                                                              ?.toLowerCase() ==
                                                          'low'
                                                      ? secondaryTextColor
                                                      : blueColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 4.h),
                                          child: Center(
                                            child: Text(
                                              '${newTaskList[index]['effective_status'].toString()}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: newTaskList[index][
                                                                'effective_status']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "pending"
                                                    ? buttonRedColor
                                                    : newTaskList[index][
                                                                    'effective_status']
                                                                .toString()
                                                                .toLowerCase() ==
                                                            "progress"
                                                        ? mediumColor
                                                        : blueColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6.w,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${newTaskList[index]['task_date']}',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: secondaryTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20.h);
                    },
                  ),
                ),
    );
  }

  Widget newTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No New data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: InkWell(
                      onTap: () {
                        Get.to(TaskDetails(
                            taskId: newTaskList[index]['id'],
                            assignedStatus:
                                taskController.selectedAssignedTask.value));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: lightGreyColor.withOpacity(0.2),
                              blurRadius: 13.0,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: newTaskList[index]
                                                      ['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 30.h,
                                    width: 25.w,
                                    child: PopupMenuButton<String>(
                                      color: whiteColor,
                                      constraints: BoxConstraints(
                                        maxWidth: 200.w,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      shadowColor: lightGreyColor,
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (String result) {
                                        switch (result) {
                                          case 'edit':
                                            for (var projectData
                                                in projectController
                                                    .allProjectDataList) {
                                              if (projectData.id.toString() ==
                                                  newTaskList[index]
                                                          ['project_id']
                                                      .toString()) {
                                                projectController
                                                    .selectedAllProjectListData
                                                    .value = projectData;
                                                profileController.departmentList(
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value
                                                        ?.id);
                                                break;
                                              }
                                            }
                                            taskController
                                                .responsiblePersonListApi(
                                                    profileController
                                                        .selectedDepartMentListData
                                                        .value
                                                        ?.id);
                                            taskNameController3.text =
                                                newTaskList[index]['title'];
                                            remarkController3.text =
                                                newTaskList[index]
                                                    ['description'];
                                            startDateController3.text =
                                                newTaskList[index]
                                                    ['start_date'];
                                            dueDateController3.text =
                                                newTaskList[index]['due_date'];
                                            dueTimeController3.text =
                                                newTaskList[index]['due_time'];

                                            for (var priorityData
                                                in priorityController
                                                    .priorityList) {
                                              if (priorityData.id.toString() ==
                                                  newTaskList[index]['priority']
                                                      .toString()) {
                                                priorityController
                                                    .selectedPriorityData
                                                    .value = priorityData;
                                                break;
                                              }
                                            }

                                            for (var deptData
                                                in profileController
                                                    .departmentDataList) {
                                              if (deptData.id.toString() ==
                                                  newTaskList[index]
                                                          ['department_id']
                                                      .toString()) {
                                                profileController
                                                    .selectedDepartMentListData
                                                    .value = deptData;
                                                break;
                                              }
                                            }
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: EditTaskClass()
                                                    .editTaskBottomSheet(
                                                        context,
                                                        priorityController
                                                            .priorityList,
                                                        projectController
                                                            .allProjectDataList,
                                                        taskController
                                                            .responsiblePersonList,
                                                        newTaskList[index]
                                                            ['id'],
                                                        taskNameController3,
                                                        remarkController3,
                                                        startDateController3,
                                                        dueDateController3,
                                                        dueTimeController3),
                                              ),
                                            );
                                            break;
                                          case 'delete':
                                            taskController.deleteTask(
                                                newTaskList[index]['id']);
                                            break;
                                          case 'status':
                                            taskController.isCompleteStatus
                                                ?.value = false;
                                            taskController.isProgressStatus
                                                ?.value = false;
                                            statusRemarkController.clear();
                                            taskController
                                                .profilePicPath2.value = '';
                                            changeStatusDialog(
                                              context,
                                              newTaskList[index]['id'],
                                              newTaskList[index]['status'],
                                              newTaskList[index]['parent_id'],
                                              newTaskList[index]
                                                  ['is_subtask_completed'],
                                              newTaskList[index]
                                                  ['effective_status'],
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: ListTile(
                                              leading: Image.asset(
                                                "assets/images/png/edit-icon.png",
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Edit',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/delete-icon.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Delete',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Assigned to me")
                                          PopupMenuItem<String>(
                                            value: 'status',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/document.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Change Status',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${newTaskList[index]['title']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '${newTaskList[index]['description']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Text(
                                        '${newTaskList[index]['priority_name']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? mediumColor
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? secondaryTextColor
                                                  : blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Center(
                                        child: Text(
                                          '${newTaskList[index]['effective_status'].toString()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: newTaskList[index]
                                                            ['effective_status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "pending"
                                                ? buttonRedColor
                                                : newTaskList[index][
                                                                'effective_status']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "progress"
                                                    ? mediumColor
                                                    : blueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  Widget progressTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No Progress data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: InkWell(
                      onTap: () {
                        Get.to(TaskDetails(
                            taskId: newTaskList[index]['id'],
                            assignedStatus:
                                taskController.selectedAssignedTask.value));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: lightGreyColor.withOpacity(0.2),
                              blurRadius: 13.0,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: newTaskList[index]
                                                      ['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 30.h,
                                    width: 25.w,
                                    child: PopupMenuButton<String>(
                                      color: whiteColor,
                                      constraints: BoxConstraints(
                                        maxWidth: 200.w,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      shadowColor: lightGreyColor,
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (String result) {
                                        switch (result) {
                                          case 'edit':
                                            for (var projectData
                                                in projectController
                                                    .allProjectDataList) {
                                              if (projectData.id.toString() ==
                                                  newTaskList[index]
                                                          ['project_id']
                                                      .toString()) {
                                                projectController
                                                    .selectedAllProjectListData
                                                    .value = projectData;
                                                profileController.departmentList(
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value
                                                        ?.id);
                                                break;
                                              }
                                            }
                                            taskController
                                                .responsiblePersonListApi(
                                                    profileController
                                                        .selectedDepartMentListData
                                                        .value
                                                        ?.id);
                                            taskNameController3.text =
                                                newTaskList[index]['title'];
                                            remarkController3.text =
                                                newTaskList[index]
                                                    ['description'];
                                            startDateController3.text =
                                                newTaskList[index]
                                                    ['start_date'];
                                            dueDateController3.text =
                                                newTaskList[index]['due_date'];
                                            dueTimeController3.text =
                                                newTaskList[index]['due_time'];

                                            for (var priorityData
                                                in priorityController
                                                    .priorityList) {
                                              if (priorityData.id.toString() ==
                                                  newTaskList[index]['priority']
                                                      .toString()) {
                                                priorityController
                                                    .selectedPriorityData
                                                    .value = priorityData;
                                                break;
                                              }
                                            }

                                            for (var deptData
                                                in profileController
                                                    .departmentDataList) {
                                              if (deptData.id.toString() ==
                                                  newTaskList[index]
                                                          ['department_id']
                                                      .toString()) {
                                                profileController
                                                    .selectedDepartMentListData
                                                    .value = deptData;
                                                break;
                                              }
                                            }
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: EditTaskClass()
                                                    .editTaskBottomSheet(
                                                        context,
                                                        priorityController
                                                            .priorityList,
                                                        projectController
                                                            .allProjectDataList,
                                                        taskController
                                                            .responsiblePersonList,
                                                        newTaskList[index]
                                                            ['id'],
                                                        taskNameController3,
                                                        remarkController3,
                                                        startDateController3,
                                                        dueDateController3,
                                                        dueTimeController3),
                                              ),
                                            );
                                            break;
                                          case 'delete':
                                            taskController.deleteTask(
                                                newTaskList[index]['id']);
                                            break;
                                          case 'status':
                                            taskController.isCompleteStatus
                                                ?.value = false;
                                            taskController.isProgressStatus
                                                ?.value = false;
                                            statusRemarkController.clear();
                                            taskController
                                                .profilePicPath2.value = '';
                                            changeStatusDialog(
                                              context,
                                              newTaskList[index]['id'],
                                              newTaskList[index]['status'],
                                              newTaskList[index]['parent_id'],
                                              newTaskList[index]
                                                  ['is_subtask_completed'],
                                              newTaskList[index]
                                                  ['effective_status'],
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: ListTile(
                                              leading: Image.asset(
                                                "assets/images/png/edit-icon.png",
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Edit',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/delete-icon.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Delete',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Assigned to me")
                                          PopupMenuItem<String>(
                                            value: 'status',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/document.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Change Status',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${newTaskList[index]['title']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '${newTaskList[index]['description']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Text(
                                        '${newTaskList[index]['priority_name']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? mediumColor
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? secondaryTextColor
                                                  : blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Center(
                                        child: Text(
                                          '${newTaskList[index]['effective_status'].toString()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: newTaskList[index]
                                                            ['effective_status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "pending"
                                                ? buttonRedColor
                                                : newTaskList[index][
                                                                'effective_status']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "progress"
                                                    ? mediumColor
                                                    : blueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  Widget completeTaskList(RxList newTaskList) {
    return Obx(
      () => newTaskList.isEmpty
          ? Expanded(
              child: Center(
                child: Text(
                  'No Completed data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            )
          : Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: newTaskList.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == newTaskList.length) {
                    return Obx(() => taskController.isScrolling.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          )
                        : SizedBox.shrink());
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: InkWell(
                      onTap: () {
                        Get.to(TaskDetails(
                            taskId: newTaskList[index]['id'],
                            assignedStatus:
                                taskController.selectedAssignedTask.value));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: lightGreyColor.withOpacity(0.2),
                              blurRadius: 13.0,
                              spreadRadius: 2,
                              blurStyle: BlurStyle.normal,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Task ID ${newTaskList[index]['id']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: newTaskList[index]
                                                      ['is_late_completed']
                                                  .toString()
                                                  .toLowerCase() !=
                                              "0"
                                          ? redColor
                                          : textColor,
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    height: 30.h,
                                    width: 25.w,
                                    child: PopupMenuButton<String>(
                                      color: whiteColor,
                                      constraints: BoxConstraints(
                                        maxWidth: 200.w,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      shadowColor: lightGreyColor,
                                      padding: const EdgeInsets.all(0),
                                      icon: const Icon(Icons.more_vert),
                                      onSelected: (String result) {
                                        switch (result) {
                                          case 'edit':
                                            for (var projectData
                                                in projectController
                                                    .allProjectDataList) {
                                              if (projectData.id.toString() ==
                                                  newTaskList[index]
                                                          ['project_id']
                                                      .toString()) {
                                                projectController
                                                    .selectedAllProjectListData
                                                    .value = projectData;
                                                profileController.departmentList(
                                                    projectController
                                                        .selectedAllProjectListData
                                                        .value
                                                        ?.id);
                                                break;
                                              }
                                            }
                                            taskController
                                                .responsiblePersonListApi(
                                                    profileController
                                                        .selectedDepartMentListData
                                                        .value
                                                        ?.id);
                                            taskNameController3.text =
                                                newTaskList[index]['title'];
                                            remarkController3.text =
                                                newTaskList[index]
                                                    ['description'];
                                            startDateController3.text =
                                                newTaskList[index]
                                                    ['start_date'];
                                            dueDateController3.text =
                                                newTaskList[index]['due_date'];
                                            dueTimeController3.text =
                                                newTaskList[index]['due_time'];

                                            for (var priorityData
                                                in priorityController
                                                    .priorityList) {
                                              if (priorityData.id.toString() ==
                                                  newTaskList[index]['priority']
                                                      .toString()) {
                                                priorityController
                                                    .selectedPriorityData
                                                    .value = priorityData;
                                                break;
                                              }
                                            }

                                            for (var deptData
                                                in profileController
                                                    .departmentDataList) {
                                              if (deptData.id.toString() ==
                                                  newTaskList[index]
                                                          ['department_id']
                                                      .toString()) {
                                                profileController
                                                    .selectedDepartMentListData
                                                    .value = deptData;
                                                break;
                                              }
                                            }
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: EditTaskClass()
                                                    .editTaskBottomSheet(
                                                        context,
                                                        priorityController
                                                            .priorityList,
                                                        projectController
                                                            .allProjectDataList,
                                                        taskController
                                                            .responsiblePersonList,
                                                        newTaskList[index]
                                                            ['id'],
                                                        taskNameController3,
                                                        remarkController3,
                                                        startDateController3,
                                                        dueDateController3,
                                                        dueTimeController3),
                                              ),
                                            );
                                            break;
                                          case 'delete':
                                            taskController.deleteTask(
                                                newTaskList[index]['id']);
                                            break;
                                          case 'status':
                                            taskController.isCompleteStatus
                                                ?.value = false;
                                            taskController.isProgressStatus
                                                ?.value = false;
                                            statusRemarkController.clear();
                                            taskController
                                                .profilePicPath2.value = '';
                                            changeStatusDialog(
                                              context,
                                              newTaskList[index]['id'],
                                              newTaskList[index]['status'],
                                              newTaskList[index]['parent_id'],
                                              newTaskList[index]
                                                  ['is_subtask_completed'],
                                              newTaskList[index]
                                                  ['effective_status'],
                                            );
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: ListTile(
                                              leading: Image.asset(
                                                "assets/images/png/edit-icon.png",
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Edit',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Task created by me")
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/delete-icon.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Delete',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        if (taskController
                                                .selectedAssignedTask.value ==
                                            "Assigned to me")
                                          PopupMenuItem<String>(
                                            value: 'status',
                                            child: ListTile(
                                              leading: Image.asset(
                                                'assets/images/png/document.png',
                                                height: 20.h,
                                              ),
                                              title: Text(
                                                'Change Status',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${newTaskList[index]['title']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '${newTaskList[index]['description']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: newTaskList[index]['is_late_completed']
                                              .toString()
                                              .toLowerCase() !=
                                          "0"
                                      ? redColor
                                      : textColor,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Text(
                                        '${newTaskList[index]['priority_name']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: newTaskList[index]
                                                          ['priority_name']
                                                      ?.toLowerCase() ==
                                                  'medium'
                                              ? mediumColor
                                              : newTaskList[index]
                                                              ['priority_name']
                                                          ?.toLowerCase() ==
                                                      'low'
                                                  ? secondaryTextColor
                                                  : blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 4.h),
                                      child: Center(
                                        child: Text(
                                          '${newTaskList[index]['effective_status'].toString()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: newTaskList[index]
                                                            ['effective_status']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "pending"
                                                ? buttonRedColor
                                                : newTaskList[index][
                                                                'effective_status']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "progress"
                                                    ? mediumColor
                                                    : blueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 4),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${newTaskList[index]['task_date']}',
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: secondaryTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20.h);
                },
              ),
            ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final TextEditingController statusRemarkController = TextEditingController();
  Future<void> changeStatusDialog(
    BuildContext context,
    newTaskListId,
    newTaskListStatus,
    parentId,
    isubtaskCompleted,
    efectiveStatus,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            width: double.infinity,
            height: efectiveStatus.toString().toLowerCase() == "completed"
                ? 230.h
                : 340.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: efectiveStatus.toString().toLowerCase() == "completed"
                  ? Center(
                      child: Text(
                        'Status Complete',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Change Status',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Container(
                                    height: 25.h,
                                    width: 25.w,
                                    child: Checkbox(
                                      value: taskController
                                          .isProgressStatus?.value,
                                      onChanged: (value) {
                                        taskController.isProgressStatus?.value =
                                            value!;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            efectiveStatus.toString().toLowerCase() ==
                                    "progress"
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => Container(
                                          height: 25.h,
                                          width: 25.w,
                                          child: Checkbox(
                                            value: taskController
                                                .isCompleteStatus?.value,
                                            onChanged: (value) {
                                              taskController.isProgressStatus
                                                  ?.value = false;
                                              taskController.isCompleteStatus
                                                  ?.value = value!;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Text(
                                        'Complete',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                AttachmentClass()
                                    .selectAttachmentDialog(context);
                              },
                              child: Container(
                                height: 35.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: lightSecondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/png/attachment-icon.png',
                                      width: 35.w,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Add Attachment',
                                      style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Obx(
                              () => taskController
                                      .profilePicPath2.value.isNotEmpty
                                  ? Container(
                                      height: 40.h,
                                      width: 60.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: secondaryTextColor),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        child: Image.file(
                                          File(taskController
                                              .profilePicPath2.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        TaskCustomTextField(
                          controller: statusRemarkController,
                          textCapitalization: TextCapitalization.sentences,
                          data: statusRemark,
                          hintText: statusRemark,
                          labelText: statusRemark,
                          index: 0,
                          maxLine: 3,
                          focusedIndexNotifier: focusedIndexNotifier,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Obx(
                          () => CustomButton(
                            onPressed: () {
                              if (taskController.isProgressUpdating.value ==
                                  false) {
                                if (taskController.isProgressStatus?.value ==
                                        true ||
                                    taskController.isCompleteStatus?.value ==
                                        true) {
                                  if (statusRemarkController.text.isNotEmpty) {
                                    if (efectiveStatus
                                            .toString()
                                            .toLowerCase() ==
                                        "pending") {
                                      taskController.taskIdFromDetails =
                                          newTaskListId;
                                      taskController.updateProgressTask(
                                          newTaskListId,
                                          statusRemarkController.text,
                                          1,
                                          from: 'list');
                                    } else if (efectiveStatus
                                            .toString()
                                            .toLowerCase() ==
                                        "progress") {
                                      if (taskController
                                              .isCompleteStatus?.value ==
                                          true) {
                                        taskController.taskIdFromDetails =
                                            newTaskListId;
                                        taskController.updateProgressTask(
                                            newTaskListId,
                                            statusRemarkController.text,
                                            2,
                                            from: 'list');
                                      } else {
                                        taskController.taskIdFromDetails =
                                            newTaskListId;
                                        taskController.updateProgressTask(
                                            newTaskListId,
                                            statusRemarkController.text,
                                            1,
                                            from: 'list');
                                      }
                                    }
                                  } else {
                                    CustomToast()
                                        .showCustomToast("Please add remark.");
                                  }
                                } else {
                                  CustomToast()
                                      .showCustomToast("Please select status");
                                }
                              }
                            },
                            text: taskController.isProgressUpdating.value ==
                                    true
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
                                    done,
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
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int selectedProjectId = 0;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  Widget addTaskBottomSheet(
      BuildContext context,
      RxList<PriorityData> priorityList,
      RxList<AllProjectListData> allProjectDataList,
      RxList<ResponsiblePersonData> responsiblePersonList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      createNewTask,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                TaskCustomTextField(
                  controller: taskNameController,
                  textCapitalization: TextCapitalization.sentences,
                  data: taskName,
                  hintText: taskName,
                  labelText: taskName,
                  index: 0,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                SizedBox(
                  height: 10.h,
                ),
                TaskCustomTextField(
                  controller: remarkController,
                  textCapitalization: TextCapitalization.sentences,
                  data: enterRemark,
                  hintText: enterRemark,
                  labelText: enterRemark,
                  index: 1,
                  maxLine: 3,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectProject,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          Obx(
                            () => DropdownButtonHideUnderline(
                              child: DropdownButton2<AllProjectListData>(
                                isExpanded: true,
                                items: taskController.allProjectDataList
                                    .map((AllProjectListData item) {
                                  return DropdownMenuItem<AllProjectListData>(
                                    value: item,
                                    child: Text(
                                      item.name ?? "",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Roboto',
                                        color: darkGreyColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                value: taskController
                                            .selectedAllProjectListData.value ==
                                        null
                                    ? null
                                    : taskController
                                        .selectedAllProjectListData.value,
                                onChanged: (AllProjectListData? value) {
                                  taskController
                                      .selectedAllProjectListData.value = value;
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border:
                                        Border.all(color: lightSecondaryColor),
                                    color: lightSecondaryColor,
                                  ),
                                ),
                                hint: Text(
                                  'Select Project'.tr,
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontFamily: 'Roboto',
                                    color: darkGreyColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                iconStyleData: IconStyleData(
                                  icon: Image.asset(
                                    'assets/images/png/Vector 3.png',
                                    color: secondaryColor,
                                    height: 8.h,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: lightGreyColor,
                                  iconDisabledColor: lightGreyColor,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 330,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.r),
                                      color: lightSecondaryColor,
                                      border: Border.all(
                                          color: lightSecondaryColor)),
                                  offset: const Offset(0, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        WidgetStateProperty.all<double>(6),
                                    thumbVisibility:
                                        WidgetStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectDepartment,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          SizedBox(width: 150.w, child: DepartmentList()),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              takePhoto(ImageSource.gallery);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 10.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Attachment",
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Image.asset(
                                      'assets/images/png/attachment_rounded.png',
                                      color: whiteColor,
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Badge(
                            backgroundColor: secondaryPrimaryColor,
                            isLabelVisible:
                                taskController.assignedUserId.isEmpty
                                    ? false
                                    : true,
                            label: Text(
                              "${taskController.assignedUserId.length}",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            child: InkWell(
                              onTap: () {
                                taskController.assignedUserId.clear();
                                taskController
                                    .responsiblePersonSelectedCheckBox2
                                    .clear();
                                for (var person in responsiblePersonList) {
                                  taskController
                                          .responsiblePersonSelectedCheckBox2[
                                      person.id] = false;
                                }
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: ResponsiblePersonList('assign')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.r)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 17.w, vertical: 11.2.h),
                                  child: Text(
                                    "Assigned To",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Badge(
                            backgroundColor: secondaryPrimaryColor,
                            isLabelVisible:
                                taskController.reviewerUserId.isEmpty
                                    ? false
                                    : true,
                            label: Text(
                              "${taskController.reviewerUserId.length}",
                              style: TextStyle(color: textColor, fontSize: 16),
                            ),
                            child: InkWell(
                              onTap: () {
                                taskController.reviewerUserId.clear();
                                taskController
                                    .responsiblePersonSelectedCheckBox2
                                    .clear();
                                for (var person in responsiblePersonList) {
                                  taskController
                                          .responsiblePersonSelectedCheckBox2[
                                      person.id] = false;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ResponsiblePersonList(
                                      'reviewer',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: blueColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7.r)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 11.2.h),
                                  child: Text(
                                    "Reviewer",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      taskController.profilePicPath.value.isEmpty
                          ? SizedBox()
                          : InkWell(
                              onTap: () {
                                openFile(
                                    File(taskController.profilePicPath.value));
                              },
                              child: Container(
                                height: 40.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: lightGreyColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(taskController.profilePicPath.value),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          "Invalid Image",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${startDate} *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          CustomCalender(
                            hintText: dateFormate,
                            controller: startDateController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${dueDate} *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          CustomCalender(
                            hintText: dateFormate,
                            controller: dueDateController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${dueTime} *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          CustomTimer(
                            hintText: "",
                            controller: dueTimeController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 161.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${selectPriority} *",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.w,
                          ),
                          CustomDropdown<PriorityData>(
                            items: priorityController.priorityList,
                            itemLabel: (item) => item.priorityName ?? "",
                            selectedValue: null,
                            onChanged: (value) {
                              priorityController.selectedPriorityData.value =
                                  value;
                            },
                            hintText: selectPriority,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      if (taskController.isTaskAdding.value == false) {
                        if (taskController.assignedUserId.isNotEmpty) {
                          if (taskController.reviewerUserId.isNotEmpty) {
                            if (priorityController.selectedPriorityData.value !=
                                    null &&
                                dueTimeController.text.isNotEmpty &&
                                dueDateController.text.isNotEmpty &&
                                startDateController.text.isNotEmpty) {
                              if (profileController
                                      .selectedDepartMentListData.value !=
                                  null) {
                                if (_formKey.currentState!.validate()) {
                                  taskController.addTask(
                                      taskNameController.text,
                                      remarkController.text,
                                      selectedProjectId,
                                      profileController
                                          .selectedDepartMentListData.value?.id,
                                      startDateController.text,
                                      dueDateController.text,
                                      dueTimeController.text,
                                      priorityController
                                          .selectedPriorityData.value?.id,
                                      'bottom');
                                }
                              } else {
                                CustomToast().showCustomToast(
                                    "Please select department.");
                              }
                            } else {
                              CustomToast()
                                  .showCustomToast("Please select * value.");
                            }
                          } else {
                            CustomToast().showCustomToast(
                                "Please select reviewer person.");
                          }
                        } else {
                          CustomToast()
                              .showCustomToast("Please select assign person.");
                        }
                      }
                    },
                    text: taskController.isTaskAdding.value == true
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
                            create,
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
          ),
        ),
      ),
    );
  }

  void openFile(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: file),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  ValueNotifier<int?> focusedIndexNotifier3 = ValueNotifier<int?>(null);
}
