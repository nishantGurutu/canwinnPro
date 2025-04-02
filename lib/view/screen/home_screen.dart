import 'dart:developer';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/priority_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/add_project.dart';
import 'package:task_management/view/screen/attendence/checkin_screen.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/task_list.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:task_management/view/widgets/PriorityTaskSummary%20.dart';
import 'package:task_management/view/widgets/autoScrollListInfo.dart';
import 'package:task_management/view/widgets/custom_calender.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/custom_timer.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';
import 'package:task_management/view/widgets/home_discussion_list.dart';
import 'package:task_management/view/widgets/home_task_list.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';
import 'package:task_management/view/widgets/task_info.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RxString firstLetters = ''.obs;
  RxString userName = ''.obs;
  final HomeController homeController = Get.find();
  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  final BottomBarController bottomBarController = Get.find();

  RxList<AssetsSubmitModel> assetsList = <AssetsSubmitModel>[].obs;
  RxList<bool> assetsListCheckbox = <bool>[].obs;
  final FeedController feedController = Get.put(FeedController());
  final ChatController chatController = Get.put(ChatController());
  final PriorityController priorityController = Get.find();
  DateTime dt = DateTime.now();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    checkStoredNotificationData();
    super.initState();
    homeController.anniversarylist(context);
    profileController.dailyTaskList(context, '');
    _tabController = TabController(length: 2, vsync: this);
    taskController.responsiblePersonListApi(StorageHelper.getDepartmentId());
    StorageHelper.setIsCurrentDate(dt.toString());
    if (dt.toString() != StorageHelper.getIsCurrentDate().toString()) {
      homeController.onetimeMsglist().then((_) {
        if (homeController.onTimemsg.value.isNotEmpty) {
          openOneTimeMsg(homeController.onTimemsg.value,
              homeController.onTimemsgUrl.value);
        }
      });
    }

    SosPusherConfig().initPusher(_onPusherEvent,
        channelName: "test-channel", context: context);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        homeController.isButtonVisible.value = false;
      } else if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        homeController.isButtonVisible.value = true;
      }
    });
  }

  var isLoading = false.obs;
  void checkApiCall() async {
    isLoading.value = true;
    await homeController.homeDataApi('');
    isLoading.value = false;
  }

  void _onPusherEvent(PusherEvent event) {
    log("Pusher event received: ${event.eventName} - ${event.data}");
  }

  _launchURL(param0) async {
    final Uri url = Uri.parse('$param0');
    ErrorDescription(message);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }

  Future<void> openOneTimeMsg(String value, String urlValue) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: whiteColor,
                ),
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _launchURL(urlValue);
                        },
                        child: Text(
                          urlValue,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: blueColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 10.w,
                child: InkWell(
                  onTap: () {
                    List<String> listSplitDt = dt.toString().split(' ');
                    StorageHelper.setIsCurrentDate(
                        listSplitDt.first.toString());
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkStoredNotificationData() async {
    final prefs = await SharedPreferences.getInstance();
    String? notificationData = prefs.getString('notification_data');
    if (notificationData.toString() != "null" &&
        notificationData.toString() != "" &&
        notificationData.toString() != null) {
      Future.delayed(Duration.zero, () {
        ShowDialogFunction().sosMsg2(context, notificationData, dt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      body: Obx(
        () => homeController.isHomeDataLoading.value == true
            ? Scaffold(
                backgroundColor: whiteColor,
                body: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    if (homeController.anniversaryListData.isNotEmpty)
                      AutoScrollList(homeController.anniversaryListData),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        children: [
                          StorageHelper.getType() == 1
                              ? SizedBox(
                                  height: 10.h,
                                )
                              : SizedBox(),
                          StorageHelper.getType() == 1
                              ? selectUser()
                              : SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                          summary(
                            homeController.totalTask.value,
                            homeController.totalTaskAssigned.value,
                            homeController.dueTodayTask.value,
                            homeController.totalTasksPastDue.value,
                            homeController.newTask.value,
                            homeController.completedTask.value,
                            homeController.taskCreatedByMe.value,
                            homeController.progressTask.value,
                          ),
                          SizedBox(height: 10.h),
                          discussion(homeController.homeChatList,
                              homeController.homeTaskCommentsList),
                          SizedBox(height: 10.h),
                          pinedData(homeController.homePinnedNotes),
                          SizedBox(height: 10.h),
                          PriorityTaskSummary(
                            highValue:
                                homeController.totalTaskAssignedHigh.value,
                            lowValue: homeController.totalTaskAssignedLow.value,
                            mediumValue:
                                homeController.totalTaskAssignedMedium.value,
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        child: Icon(
          Icons.add,
          color: whiteColor,
          size: 30.h,
        ),
        onPressed: () {
          showAlertDialog(
              context,
              taskController.allProjectDataList,
              taskController.responsiblePersonList,
              priorityController.priorityList);
        },
      ),
    );
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source, String type) async {
    try {
      final pickedImage = await imagePicker.pickImage(
          source: source,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 30);
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

  Future<void> showAlertDialog(
    BuildContext context,
    RxList<AllProjectListData> allProjectDataList,
    RxList<ResponsiblePersonData> responsiblePersonList,
    RxList<PriorityData> priorityList,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add New",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onPressed: () async {
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
                          taskController.responsiblePersonSelectedCheckBox
                              .addAll(List<bool>.filled(
                                  responsiblePersonList.length, false));
                          taskController.reviewerCheckBox.addAll(
                              List<bool>.filled(
                                  taskController.responsiblePersonList.length,
                                  false));
                          taskController.profilePicPath.value = '';
                          priorityController.selectedPriorityData.value == null;
                          taskController.selectedAllProjectListData.value =
                              null;
                          profileController.selectedDepartMentListData.value =
                              null;
                          taskController.selectedAllProjectListData.value =
                              taskController.allProjectDataList.first;
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: addTaskBottomSheet(context, priorityList,
                                  allProjectDataList, responsiblePersonList),
                            ),
                          );
                        },
                        text: Text(
                          addTask2,
                          style: TextStyle(color: whiteColor),
                        ),
                        width: 101.w,
                        color: primaryColor,
                        height: 40.h,
                      ),
                      CustomButton(
                        onPressed: () {
                          Get.to(AddProject());
                        },
                        text: Text(
                          addProject,
                          style: TextStyle(color: whiteColor),
                        ),
                        width: 101.w,
                        color: secondaryColor,
                        height: 40.h,
                      ),
                      CustomButton(
                        onPressed: () {
                          Get.to(ToDoList(''));
                        },
                        text: Text(
                          todo,
                          style: TextStyle(color: whiteColor),
                        ),
                        width: 101.w,
                        color: chatColor,
                        height: 40.h,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  int selectedProjectId = 0;
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController dueTimeController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  Widget addTaskBottomSheet(
      BuildContext context,
      RxList<PriorityData> priorityList,
      RxList<AllProjectListData> allProjectDataList,
      RxList<ResponsiblePersonData> responsiblePersonList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
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
                                      item.name ?? '',
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
                                    .selectedAllProjectListData.value,
                                onChanged: (AllProjectListData? value) {
                                  if (value != null) {
                                    taskController.selectedAllProjectListData
                                        .value = value;
                                    profileController.departmentList(value.id);
                                  }
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
                                  "Select Project".tr,
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
                              takePhoto(ImageSource.gallery, '');
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
                          Obx(
                            () => Badge(
                              backgroundColor: secondaryPrimaryColor,
                              isLabelVisible:
                                  taskController.assignedUserId.isEmpty
                                      ? false
                                      : true,
                              label: Text(
                                "${taskController.assignedUserId.length}",
                                style:
                                    TextStyle(color: textColor, fontSize: 16),
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
                                      child: ResponsiblePersonList('assign'),
                                    ),
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
                          ),
                          Obx(
                            () => Badge(
                              backgroundColor: secondaryPrimaryColor,
                              isLabelVisible:
                                  taskController.reviewerUserId.isEmpty
                                      ? false
                                      : true,
                              label: Text(
                                "${taskController.reviewerUserId.length}",
                                style:
                                    TextStyle(color: textColor, fontSize: 16),
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

  final dropDownKey = GlobalKey<DropdownSearchState>();
  Widget selectUser() {
    return Obx(
      () => Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: lightSecondaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: DropdownMenu<ResponsiblePersonData>(
            controller: menuController,
            width: double.infinity,
            trailingIcon: Image.asset(
              'assets/images/png/Vector 3.png',
              color: primaryColor,
              height: 8.h,
            ),
            selectedTrailingIcon: Image.asset(
              'assets/images/png/Vector 3.png',
              color: primaryColor,
              height: 8.h,
            ),
            menuHeight: 350.h,
            hintText: "Select Menu",
            requestFocusOnTap: true,
            enableSearch: true,
            enableFilter: true,
            inputDecorationTheme:
                InputDecorationTheme(border: InputBorder.none),
            menuStyle: MenuStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(lightSecondaryColor),
            ),
            onSelected: (ResponsiblePersonData? value) {
              if (value != null) {
                taskController.selectedResponsiblePersonData.value = value;
                homeController.homeDataApi(
                    taskController.selectedResponsiblePersonData.value?.id);
              }
            },
            dropdownMenuEntries: taskController.responsiblePersonList
                .map<DropdownMenuEntry<ResponsiblePersonData>>(
                    (ResponsiblePersonData menu) {
              return DropdownMenuEntry<ResponsiblePersonData>(
                value: menu,
                label: menu.name ?? '',
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget summary(
      int totalTask,
      int totalTaskAssigned,
      int dueTodayTask,
      int totalTasksPastDue,
      int newTask,
      int completedTask,
      int taskCreatedByMe,
      int progressTask) {
    int totalTaskCount = totalTaskAssigned + taskCreatedByMe;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskListPage(
                      taskType: 'All Task',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: TaskInfo(
                    'Total Task',
                    totalTaskCount,
                    'assets/task_images/ic_checklist.svg',
                    const Color.fromARGB(255, 76, 175, 175)),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskListPage(
                      taskType: 'All Task',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: TaskInfo(
                    'Assigned',
                    totalTaskAssigned,
                    'assets/task_images/ic_person.svg',
                    const Color.fromARGB(255, 244, 54, 54)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => TaskListPage(
                      taskType: 'Due Today',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString(),
                    ),
                  );
                },
                child: TaskInfo(
                    "Due today",
                    dueTodayTask,
                    'assets/task_images/ic_calender.svg',
                    Color.fromARGB(255, 152, 33, 243)),
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => TaskListPage(
                      taskType: 'Past Due',
                      assignedType: "Assigned to me",
                      '',
                      taskController.selectedResponsiblePersonData.value?.id
                          .toString()));
                },
                child: TaskInfo(
                    "Past due date",
                    totalTasksPastDue,
                    'assets/task_images/ic_person.svg',
                    const Color.fromARGB(255, 255, 163, 59)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () {
            Get.to(
              () => TaskListPage(
                taskType: 'Progress',
                assignedType: "Assigned to me",
                '',
                taskController.selectedResponsiblePersonData.value?.id
                    .toString(),
              ),
            );
          },
          child: TaskInfo("Progress task", progressTask,
              'assets/task_images/ic_checklist.svg', Colors.blue),
        ),
        SizedBox(height: 10.h),
        Container(
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
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Summary",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => TaskListPage(
                              taskType: 'New Task',
                              assignedType: "Assigned to me",
                              '',
                              taskController
                                  .selectedResponsiblePersonData.value?.id
                                  .toString(),
                            ),
                          );
                        },
                        child: Container(
                          height: 65.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            color: lightBlueColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: darkBlue,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                      "assets/task_images/ic_checklist.svg",
                                    ),
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
                                      'New task',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${newTask}',
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
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => TaskListPage(
                              taskType: 'Completed',
                              assignedType: "Assigned to me",
                              '',
                              taskController
                                  .selectedResponsiblePersonData.value?.id
                                  .toString(),
                            ),
                          );
                        },
                        child: Container(
                          height: 65.h,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.r)),
                            color: lightSecondaryGreenColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: darkGreen,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                      "assets/task_images/ic_checklist.svg",
                                    ),
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
                                      'Closed task',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${completedTask}',
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget discussion(RxList homeChatList, RxList homeTaskList) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discussion',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    bottomBarController.currentPageIndex.value = 1;
                    Get.to(BottomNavigationBarExample(from: 'home'));
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: blueColor),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/png/general.png',
                        height: 20.h,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'General',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list),
                      SizedBox(width: 5.w),
                      Text(
                        'Task',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Container(
              height: 230.h,
              child: TabBarView(
                controller: _tabController,
                children: [
                  HomeDiscussionList(homeChatList),
                  HomeTaskList(homeTaskList),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pinedData(RxList homePinnedNotes) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pinned Notes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: homePinnedNotes.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: viewNotesBottomSheet(
                              context, homePinnedNotes[index]),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 7),
                      child: Container(
                        decoration: BoxDecoration(
                          color: lightBlue,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 300.w,
                                child: Text(
                                  '${homePinnedNotes[index]['title']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                width: 300.w,
                                child: Text(
                                  '${homePinnedNotes[index]['description']}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget viewNotesBottomSheet(
    BuildContext context,
    dynamic homePinnedNot,
  ) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      width: double.infinity,
      height: 400.h,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${homePinnedNot['title']}',
                    style: changeTextColor(rubikBlack, darkGreyColor)),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: 335.w,
              child: Text('${homePinnedNot['description']}',
                  style: changeTextColor(rubikRegular, lightGreyColor)),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Container(
                  height: 10.h,
                  width: 10.w,
                  decoration: BoxDecoration(
                    color: homePinnedNot['tags'].toString() == '1'
                        ? Colors.blue
                        : homePinnedNot['tags'].toString() == '2'
                            ? Colors.green
                            : homePinnedNot['tags'].toString() == '3'
                                ? Colors.yellow[800]
                                : Colors.redAccent,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  '${homePinnedNot['tags'].toString() == '1' ? "Work" : homePinnedNot['tags'].toString() == '2' ? 'Social' : homePinnedNot['tags'].toString() == '3' ? 'Personal' : 'Public'}',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: homePinnedNot['tags'].toString() == '1'
                          ? Colors.blue
                          : homePinnedNot['tags'].toString() == '2'
                              ? Colors.green
                              : homePinnedNot['tags'].toString() == '3'
                                  ? Colors.yellow[800]
                                  : Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
