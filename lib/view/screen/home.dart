import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/dialog_class.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/pusher_config.dart';
import 'package:task_management/helper/sos_pusher.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/contact.dart';
import 'package:task_management/view/screen/notes.dart';
import 'package:task_management/view/screen/task_list.dart';
import 'package:task_management/view/widgets/autoScrollListInfo.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';
import 'package:task_management/view/widgets/responsible_person_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RxString firstLetters = ''.obs;
  RxString userName = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  final ProfileController profileController = Get.find();
  final TaskController taskController = Get.find();
  final BottomBarController bottomBarController = Get.find();
  RxList<AssetsSubmitModel> assetsList = <AssetsSubmitModel>[].obs;
  RxList<bool> assetsListCheckbox = <bool>[].obs;
  final FeedController feedController = Get.put(FeedController());

  @override
  void dispose() {
    assetsList.clear();
    assetsListCheckbox.clear();
    PusherConfig().disconnect();
    super.dispose();
  }

  DateTime dt = DateTime.now();
  @override
  void initState() {
    checkStoredNotificationData();
    homeController.anniversarylist(context);
    super.initState();
    profileController.dailyTaskList(context, '');
    homeController.homeDataApi('');

    StorageHelper.setIsCurrentDate(dt.toString());
    if (dt.toString() != StorageHelper.getIsCurrentDate().toString()) {
      homeController.onetimeMsglist().then((_) {
        if (homeController.onTimemsg.value.isNotEmpty) {
          openOneTimeMsg(homeController.onTimemsg.value,
              homeController.onTimemsgUrl.value);
        }
      });
    }
    taskController.responsiblePersonListApi(StorageHelper.getDepartmentId());
    SosPusherConfig().initPusher(_onPusherEvent,
        channelName: "test-channel", context: context);
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.isHomeDataLoading.value == true &&
              homeController.isOneTimeMsgLoading.value == true &&
              taskController.isResponsiblePersonLoading.value == true &&
              homeController.isAnniversaryLoading.value == true
          ? Scaffold(
              backgroundColor: whiteColor,
              body:
                  Center(child: CircularProgressIndicator(color: primaryColor)),
            )
          : Scaffold(
              body: Container(
                color: backgroundColor,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () {
                        return Future.delayed(
                          Duration(milliseconds: 500),
                          () {},
                        );
                      },
                      child: Column(
                        children: [
                          if (homeController.anniversaryListData.isNotEmpty)
                            AutoScrollList(homeController.anniversaryListData),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                                bannerWidget(
                                    homeController.taskProgressDetail.value),
                                SizedBox(
                                  height: 30.h,
                                ),
                                inProgress(
                                  homeController.taskCreatedByMe.value,
                                  homeController.totalTaskAssigned.value,
                                  homeController.dueTodayTask.value,
                                  homeController.totalTasksPastDue.value,
                                  homeController.progressTask.value,
                                  homeController.avgTaskCreated.value,
                                  homeController.avgTaskAssigned.value,
                                  homeController.avgTaskDue.value,
                                  homeController.avgPastTaskDue.value,
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                taskGroup(
                                  homeController.newTask.value,
                                  homeController.completedTask.value,
                                  homeController.progressTask.value,
                                ),
                                StorageHelper.getType() == 1
                                    ? SizedBox(
                                        height: 20.h,
                                      )
                                    : SizedBox(
                                        height: 100.h,
                                      ),
                                StorageHelper.getType() == 1
                                    ? activitylist()
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  final TextEditingController menuController = TextEditingController();
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

  Widget bannerWidget(double value) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(11.r),
            ),
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.3),
                blurRadius: 24.0,
                spreadRadius: 1,
                blurStyle: BlurStyle.normal,
                offset: Offset(0, 11),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              children: [
                Container(
                  width: 160.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your today’s task\nalmost done",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(
                            TaskListPage(
                                taskType: "All Task",
                                assignedType: "Assigned to me",
                                '',
                                taskController
                                    .selectedResponsiblePersonData.value?.id
                                  ..toString()),
                          );
                        },
                        child: Container(
                          height: 40.h,
                          width: 118.w,
                          decoration: BoxDecoration(
                            color: lightButtonColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: iconColor.withOpacity(0.33),
                                blurRadius: 7.0,
                                spreadRadius: 0.7,
                                blurStyle: BlurStyle.normal,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'View Task',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: buttonTextColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CircularPercentIndicator(
                  radius: 55.0,
                  lineWidth: 10.0,
                  percent: value / 100,
                  animationDuration: 200,
                  reverse: true,
                  center: Text(
                    "${value.toString().split('.').first}",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w600),
                  ),
                  progressColor: whiteColor,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: PopupMenuButton<String>(
            constraints: BoxConstraints(
              maxWidth: 150.w,
            ),
            color: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.all(
                  Radius.circular(4.r),
                ),
              ),
              child: Center(
                child: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              ),
            ),
            onSelected: (String result) async {
              switch (result) {
                case 'notes':
                  Get.back();
                  Get.to(const NotesPages());
                  break;
                case 'calender':
                  Get.back();
                  Get.to(const CalenderScreen(''));
                  break;
                case 'event':
                  feedController.fromPage.value = 'home';
                  bottomBarController.currentPageIndex.value = 2;
                  Get.to(BottomNavigationBarExample(from: 'home'));
                  break;
                case 'contact':
                  Get.back();
                  Get.to(const ContactPage());
                  break;

                case 'assign_assets':
                  Get.back();
                  selectedAssetsList.clear();
                  assetsList.clear();
                  assetsNameTextController.clear();
                  assetsSrnoTextController.clear();
                  quantityTextController.clear();
                  taskController.assignedUserId.clear();

                  taskController.responsiblePersonSelectedCheckBox.clear();
                  taskController.responsiblePersonSelectedCheckBox.addAll(
                      List<bool>.filled(
                          taskController.responsiblePersonList.length, false));
                  taskController.selectAll.value = false;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: assignAssets(context),
                    ),
                  );

                  break;
                case 'submit_task':
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: dailyTaskListWidget(context),
                    ),
                  );
                  break;
                case 'past_task':
                  await profileController.dailyTaskList(context, 'pastTask');
                  Get.back();

                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'notes',
                child: ListTile(
                  leading: Image.asset(
                    notesIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'Notes',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'calender',
                child: ListTile(
                  leading: Image.asset(
                    calenderIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'Calender',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'event',
                child: ListTile(
                  leading: Image.asset(
                    calenderIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'Event',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'contact',
                child: ListTile(
                  leading: Image.asset(
                    contactIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'Contact',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (StorageHelper.getType() == 1)
                PopupMenuItem<String>(
                  value: 'assign_assets',
                  child: ListTile(
                    leading: Image.asset(
                      contactIcon,
                      color: secondaryColor,
                      height: 20.h,
                    ),
                    title: Text(
                      'Assign Assets',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              PopupMenuItem<String>(
                value: 'submit_task',
                child: ListTile(
                  leading: Image.asset(
                    contactIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'Submit Daily Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'past_task',
                child: ListTile(
                  leading: Image.asset(
                    contactIcon,
                    color: secondaryColor,
                    height: 20.h,
                  ),
                  title: Text(
                    'View Past Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final List<TextEditingController> timeControllers = [];
  final List<TextEditingController> remarkControllers = [];
  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);

  void initializeTimeControllers(int count) {
    timeControllers.clear();
    for (int i = 0; i < count; i++) {
      timeControllers.add(TextEditingController());
      remarkControllers.add(TextEditingController());
    }
  }

  Widget dailyTaskListWidget(BuildContext context) {
    if (timeControllers.isEmpty ||
        timeControllers.length != profileController.dailyTaskDataList.length) {
      initializeTimeControllers(profileController.dailyTaskDataList.length);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Obx(
        () => profileController.isDailyTaskLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Daily Task List',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    profileController.isDailyTaskLoading.value == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount:
                                  profileController.dailyTaskDataList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                lightGreyColor.withOpacity(0.2),
                                            blurRadius: 13.0,
                                            spreadRadius: 2,
                                            blurStyle: BlurStyle.normal,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 8.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${index + 1}.',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(width: 10.w),
                                                Container(
                                                  width: 260.w,
                                                  child: Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    '${profileController.dailyTaskDataList[index]['task_name']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Spacer(),
                                                Obx(
                                                  () => SizedBox(
                                                    height: 20.h,
                                                    width: 20.w,
                                                    child: Checkbox(
                                                      value: profileController
                                                              .dailyTaskListCheckbox[
                                                          index],
                                                      onChanged: (value) {
                                                        if (profileController
                                                                .isDailyTaskSubmitting
                                                                .value ==
                                                            false) {
                                                          if (timeControllers[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty &&
                                                              remarkControllers[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                            profileController
                                                                    .dailyTaskListCheckbox[
                                                                index] = value!;
                                                            if (value) {
                                                              final taskId =
                                                                  profileController
                                                                          .dailyTaskDataList[
                                                                      index]['id'];

                                                              profileController
                                                                  .dailyTaskSubmitList
                                                                  .add(
                                                                DailyTaskSubmitModel(
                                                                    taskId:
                                                                        taskId,
                                                                    doneTime:
                                                                        timeControllers[index]
                                                                            .text,
                                                                    remarks: remarkControllers[
                                                                            index]
                                                                        .text),
                                                              );
                                                            } else {
                                                              final taskId =
                                                                  profileController
                                                                              .dailyTaskDataList[
                                                                          index]
                                                                      [
                                                                      'task_id'];
                                                              profileController
                                                                  .dailyTaskSubmitList
                                                                  .removeWhere(
                                                                (task) =>
                                                                    task.taskId ==
                                                                    taskId,
                                                              );
                                                            }
                                                          } else {
                                                            CustomToast()
                                                                .showCustomToast(
                                                                    "Please select time & remarks.");
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 120.w,
                                                  child: TextField(
                                                    controller:
                                                        timeControllers[index],
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.access_time,
                                                        color: secondaryColor,
                                                      ),
                                                      hintText: timeFormate,
                                                      hintStyle: rubikRegular,
                                                      fillColor:
                                                          lightSecondaryColor,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                lightSecondaryColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.r)),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 10.h),
                                                    ),
                                                    readOnly: true,
                                                    onTap: () async {
                                                      TimeOfDay? pickedTime =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      );

                                                      if (pickedTime != null) {
                                                        final now =
                                                            DateTime.now();
                                                        final selectedTime =
                                                            DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          pickedTime.hour,
                                                          pickedTime.minute,
                                                        );
                                                        String formattedTime =
                                                            DateFormat(
                                                                    'hh:mm a')
                                                                .format(
                                                                    selectedTime);
                                                        timeControllers[index]
                                                                .text =
                                                            formattedTime;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                InkWell(
                                                  onTap: () {
                                                    remarkShowAlertDialog(
                                                        context, index);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          lightSecondaryColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5.r)),
                                                    ),
                                                    width: 180.w,
                                                    height: 40.h,
                                                    child: Center(
                                                      child: Text(
                                                        '${remarkControllers[index].text.isEmpty ? "Add Remark" : remarkControllers[index].text}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: textColor),
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
                                    SizedBox(height: 10.h),
                                  ],
                                );
                              },
                            ),
                          ),
                    Obx(
                      () => CustomButton(
                        onPressed: () {
                          if (profileController.isDailyTaskSubmitting.value ==
                              false) {
                            if (profileController
                                .dailyTaskSubmitList.isNotEmpty) {
                              profileController.submitDailyTask(
                                  profileController.dailyTaskSubmitList,
                                  context);
                              timeControllers.clear();
                              remarkControllers.clear();
                            } else {
                              CustomToast()
                                  .showCustomToast("Please select daily task.");
                            }
                          }
                        },
                        text: profileController.isDailyTaskSubmitting.value ==
                                true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: CircularProgressIndicator(
                                    color: whiteColor,
                                  )),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Loading...',
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
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> remarkShowAlertDialog(
    BuildContext context,
    int index,
  ) async {
    return showDialog(
      // barrierDismissible: false,
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
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TaskCustomTextField(
                    controller: remarkControllers[index],
                    textCapitalization: TextCapitalization.sentences,
                    data: remark,
                    hintText: remark,
                    labelText: remark,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                      color: primaryColor,
                      text: Text(
                        add,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: whiteColor),
                      ),
                      onPressed: () {
                        remarkControllers[index].text =
                            remarkControllers[index].text.trim();
                        Get.back();
                      },
                      width: 200,
                      height: 40.h)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController assetsSrnoTextController =
      TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  RxList<AssetsSubmitModel> selectedAssetsList = <AssetsSubmitModel>[].obs;
  Widget assignAssets(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Assign Assets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: assetsNameTextController,
                    textCapitalization: TextCapitalization.sentences,
                    data: assets,
                    hintText: assets,
                    labelText: assets,
                    index: 0,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: quantityTextController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    data: qty,
                    hintText: qty,
                    labelText: qty,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            SizedBox(
              // width: 160.w,
              child: TaskCustomTextField(
                controller: assetsSrnoTextController,
                textCapitalization: TextCapitalization.sentences,
                data: srNo,
                hintText: srNo,
                labelText: srNo,
                index: 3,
                focusedIndexNotifier: focusedIndexNotifier,
              ),
            ),
            SizedBox(height: 15.h),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ResponsiblePersonList('assets'),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: lightSecondaryColor),
                  color: lightSecondaryColor,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Text(
                    'Select assign user',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  color: primaryColor,
                  text: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    int qty = int.parse(quantityTextController.text.trim());
                    List<String> serialNumbers = assetsSrnoTextController.text
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList();
                    if (assetsNameTextController.text.isNotEmpty &&
                        quantityTextController.text.isNotEmpty &&
                        assetsSrnoTextController.text.isNotEmpty) {
                      if (qty == serialNumbers.length) {
                        assetsList.add(
                          AssetsSubmitModel(
                            name: assetsNameTextController.text.trim(),
                            qty: int.parse(quantityTextController.text.trim()),
                            serialNo: serialNumbers,
                          ),
                        );
                        assetsListCheckbox.addAll(
                            List<bool>.filled(assetsList.length, false));
                        assetsNameTextController.clear();
                        quantityTextController.clear();
                        assetsSrnoTextController.clear();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Add serial number according to quantity.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please enter Asset Name, Quantity, and Serial Numbers",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                  width: 150.w,
                  height: 40.h,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            profileController.isDailyTaskLoading.value == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: whiteColor,
                    ),
                  )
                : Obx(
                    () => Expanded(
                      child: ListView.builder(
                        itemCount: assetsList.length,
                        itemBuilder: (context, index) {
                          String srNumberString =
                              assetsList[index].serialNo.join(", ");

                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
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
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 110.w,
                                            child: Text(
                                              '$srNumberString',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Container(
                                            width: 110.w,
                                            child: Text(
                                              '${assetsList[index].name ?? ""}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Container(
                                            width: 40.w,
                                            child: Center(
                                              child: Text(
                                                '${assetsList[index].qty ?? ""}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Spacer(),
                                          Obx(
                                            () => SizedBox(
                                              height: 20.h,
                                              width: 20.w,
                                              child: Checkbox(
                                                value:
                                                    assetsListCheckbox[index],
                                                onChanged: (value) {
                                                  assetsListCheckbox[index] =
                                                      value!;
                                                  if (value) {
                                                    if (!selectedAssetsList
                                                        .contains(assetsList[
                                                            index])) {
                                                      selectedAssetsList.add(
                                                          assetsList[index]);
                                                    }
                                                  } else {
                                                    selectedAssetsList.remove(
                                                        assetsList[index]);
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
            CustomButton(
              onPressed: () {
                if (selectedAssetsList.isNotEmpty) {
                  profileController.assignAssets(
                      selectedAssetsList, taskController.assignedUserId);
                } else {
                  CustomToast().showCustomToast("Please select assets.");
                }
              },
              text: Text(
                assigneButton,
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
          ],
        ),
      ),
    );
  }

  List<Color> colorList = <Color>[
    lightSecondaryPrimaryColor,
    lightRedColor,
    lightBlue,
    lightButtonColor,
  ];
  List<Color> linearColorList = <Color>[
    secondaryPrimaryColor,
    redColor,
    blueColor,
    secondaryColor,
  ];
  List<String> textList = <String>[
    "Due Today",
    "Past due task",
    'Task Created By Me',
    "Assigned to me",
  ];
  List<String> textAssignList = <String>[
    "Due Today",
    "Past Due Date",
    'ask Created By Me',
    "Assigned",
  ];
  Widget inProgress(
    int? totalTask,
    int? totalTaskAssigned,
    int? dueTodayTask,
    int? totalTasksPastDue,
    int? progressTask,
    int? avgTaskCreated,
    int? avgTaskAssigned,
    int? avgTaskDue,
    int avgPastTaskDue,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(
              TaskListPage(
                  taskType: 'Progress',
                  assignedType: "Assigned to me",
                  '',
                  taskController.selectedResponsiblePersonData.value?.id
                      .toString()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'In Progress',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: 8.w,
              ),
              Container(
                height: 20.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: lightPrimaryColor2,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "${progressTask}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: 125.h,
          child: ListView.separated(
            itemCount: colorList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (index == 0) {
                    Get.to(TaskListPage(
                        taskType: 'Due Today',
                        assignedType: "Assigned to me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString()));
                  } else if (index == 1) {
                    Get.to(TaskListPage(
                        taskType: 'Past Due',
                        assignedType: "Assigned to me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString()));
                  } else if (index == 2) {
                    Get.to(TaskListPage(
                        taskType: 'All Task',
                        assignedType: "Task created by me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString()));
                  } else {
                    Get.to(TaskListPage(
                        taskType: 'All Task',
                        assignedType: "Assigned to me",
                        '',
                        taskController.selectedResponsiblePersonData.value?.id
                            .toString()));
                  }
                },
                child: Container(
                  height: 121.h,
                  width: 224.w,
                  decoration: BoxDecoration(
                    color: colorList[index],
                    borderRadius: BorderRadius.all(
                      Radius.circular(16.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${textList[index]}'),
                            Text(
                              '${index == 0 ? dueTodayTask : index == 1 ? totalTasksPastDue : index == 2 ? totalTask : totalTaskAssigned}',
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${textList[index]}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        avgTaskCreated == null
                            ? SizedBox()
                            : LinearProgressBar(
                                maxSteps: 100,
                                progressType:
                                    LinearProgressBar.progressTypeLinear,
                                currentStep: index == 0
                                    ? avgTaskDue
                                    : index == 1
                                        ? avgPastTaskDue
                                        : index == 2
                                            ? avgTaskCreated.toInt()
                                            : avgTaskAssigned,
                                progressColor: linearColorList[index],
                                backgroundColor: dotColor,
                                minHeight: 6.5.h,
                                borderRadius: BorderRadius.circular(15),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 8.w,
              );
            },
          ),
        )
      ],
    );
  }

  Widget activitylist() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                'Updates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Select Department',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropdown<DepartmentListData>(
                    items: profileController.departmentDataList,
                    itemLabel: (item) => item.name ?? '',
                    onChanged: (value) {
                      profileController.selectedDepartMentListData.value =
                          value!;
                      taskController.selectedResponsiblePersonData.value = null;
                      taskController.responsiblePersonListApi(profileController
                          .selectedDepartMentListData.value?.id);
                    },
                    hintText: selectDepartment,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Select Person',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(
                    () => Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: lightSecondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: DropdownMenu<ResponsiblePersonData>(
                          controller: menuController,
                          width: double.infinity,
                          trailingIcon: Image.asset(
                            'assets/images/png/Vector 3.png',
                            color: secondaryColor,
                            height: 8.h,
                          ),
                          selectedTrailingIcon: Image.asset(
                            'assets/images/png/Vector 3.png',
                            color: secondaryColor,
                            height: 8.h,
                          ),
                          menuHeight: 350.h,
                          hintText: "Select Person",
                          requestFocusOnTap: true,
                          enableSearch: true,
                          enableFilter: true,
                          inputDecorationTheme:
                              InputDecorationTheme(border: InputBorder.none),
                          menuStyle: MenuStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                lightSecondaryColor),
                          ),
                          onSelected: (ResponsiblePersonData? value) {
                            if (value != null) {
                              taskController
                                  .selectedResponsiblePersonData.value = value;
                              taskController.userLogActivity(taskController
                                  .selectedResponsiblePersonData.value?.id);
                            }
                          },
                          dropdownMenuEntries: taskController
                              .responsiblePersonList
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
                  ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Obx(
          () => taskController.isLogActivityLoading.value == true
              ? SizedBox(
                  height: 600.h,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < taskController.logActivityList.length;
                        i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: InkWell(
                          onTap: () {
                            if (!taskController.logActivityList[i]
                                    ['activity_type']
                                .toString()
                                .toLowerCase()
                                .contains('delete')) {
                              Get.to(
                                () => TaskListPage(
                                    taskType: "All Task",
                                    assignedType: "Assigned to me",
                                    '',
                                    taskController
                                        .selectedResponsiblePersonData.value?.id
                                        .toString()),
                              );
                            }
                          },
                          child: Container(
                            width: double.infinity,
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
                                  horizontal: 12.w, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 350,
                                    child: Text(
                                      '${taskController.logActivityList[i]['description']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${taskController.logActivityList[i]['task_date']} ${taskController.logActivityList[i]['task_time']} ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 110.h,
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget taskGroup(int? newTask, int? completedTask, int? progressTask) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Task Group',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 8.w,
            ),
            Container(
              height: 20.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: lightPrimaryColor2,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
              child: Center(
                child: Text(
                  "3",
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        InkWell(
          onTap: () {
            Get.to(TaskListPage(
                taskType: 'New Task',
                assignedType: "Assigned to me",
                '',
                taskController.selectedResponsiblePersonData.value?.id
                    .toString()));
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.1),
                  blurRadius: 24.0,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: lightSecondaryColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/images/png/checklist (1) 1.png',
                        height: 32.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "New Task",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: secondaryColor, width: 2.5.w),
                        borderRadius:
                            BorderRadius.all(Radius.circular(22.5.r))),
                    child: Center(
                      child: Text(
                        '$newTask',
                        style: TextStyle(
                            fontSize: 19.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        InkWell(
          onTap: () {
            Get.to(TaskListPage(
                taskType: 'Completed',
                assignedType: "Assigned to me",
                '',
                taskController.selectedResponsiblePersonData.value?.id
                    .toString()));
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.1),
                  blurRadius: 24.0,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: lightSecondaryColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/images/png/clipboard 1.png',
                        height: 32.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Closed Task",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: blueColor, width: 2.5.w),
                        borderRadius:
                            BorderRadius.all(Radius.circular(22.5.r))),
                    child: Center(
                      child: Text(
                        '$completedTask',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        InkWell(
          onTap: () {
            Get.to(TaskListPage(
                taskType: 'Progress',
                assignedType: "Assigned to me",
                '',
                taskController.selectedResponsiblePersonData.value?.id
                  ..toString()));
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: secondaryColor.withOpacity(0.1),
                  blurRadius: 24.0,
                  spreadRadius: 1,
                  blurStyle: BlurStyle.normal,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: lightSecondaryColor2,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/images/png/checklist (1) 1.png',
                        height: 32.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Progress Task",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Container(
                    height: 45.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: blueColor, width: 2.5.w),
                        borderRadius:
                            BorderRadius.all(Radius.circular(22.5.r))),
                    child: Center(
                      child: Text(
                        '$progressTask',
                        style: TextStyle(
                            fontSize: 19.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
