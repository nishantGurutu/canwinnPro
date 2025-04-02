import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/feed_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/assets_submit_model.dart';
import 'package:task_management/model/daily_task_submit_model.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/bottomnavigationbar.dart';
import 'package:task_management/view/screen/calender_screen.dart';
import 'package:task_management/view/screen/canwin_member.dart';
import 'package:task_management/view/screen/canwinn_brand.dart';
import 'package:task_management/view/screen/contact.dart';
import 'package:task_management/view/screen/inscreen/hr_screen.dart';
import 'package:task_management/view/screen/inscreen/in_screen_department.dart';
import 'package:task_management/view/screen/inscreen/in_screen_form.dart';
import 'package:task_management/view/screen/inscreen/in_screen_security.dart';
import 'package:task_management/view/screen/notes.dart';
import 'package:task_management/view/screen/outscreen/out_screen.dart';
import 'package:task_management/view/screen/outscreen/out_screen_chalan_list.dart';
import 'package:task_management/view/screen/page_screen.dart';
import 'package:task_management/view/screen/profile.dart';
import 'package:task_management/view/screen/project.dart';
import 'package:task_management/view/screen/setting.dart';
import 'package:task_management/view/screen/task_list.dart';
import 'package:task_management/view/screen/todo_list.dart';
import 'package:task_management/view/screen/user.dart';
import 'package:task_management/view/widgets/select_user.dart';
import '../screen/outscreen/hr_screen.dart';
import '../screen/outscreen/security.dart';

class SideDrawer extends StatefulWidget {
  final RoleListData? roleData;
  const SideDrawer(this.roleData, {super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final BottomBarController bottomBarController = Get.find();
  final RegisterController registerController = Get.put(RegisterController());
  RxString firstLetters = ''.obs;
  final FeedController feedController = Get.put(FeedController());
  final ProfileController profileController = Get.find();

  RxBool isGatePasOpen = false.obs;
  RxBool isOutScreenOpen = false.obs;
  RxBool isInScreenOpen = false.obs;
  RxList<AssetsSubmitModel> selectedAssetsList = <AssetsSubmitModel>[].obs;

  RxList<AssetsSubmitModel> assetsList = <AssetsSubmitModel>[].obs;
  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController assetsSrnoTextController =
      TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TaskController taskController = Get.find();
  // RxList<bool> assetsListCheckbox = <bool>[].obs;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Drawer(
        backgroundColor: whiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 115.h,
                  width: double.infinity,
                  color: whiteColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(ProfilePage());
                          },
                          child: Container(
                            height: 70.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35.r),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35.r),
                              ),
                              child: StorageHelper.getImage() != null &&
                                      StorageHelper.getImage().contains('.jpg')
                                  ? Image.network(
                                      StorageHelper.getImage(),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/png/profile-image-removebg-preview.png',
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 155.w,
                              child: Text(
                                '${StorageHelper.getName()}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: 155.w,
                              child: Text(
                                '${widget.roleData?.name ?? ''}',
                                style: changeTextColor(
                                    robotoRegular, secondaryTextColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: lightBorderColor,
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                          bottomBarController.currentPageIndex.value = 0;
                          Get.to(BottomNavigationBarExample(from: ' '));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: Row(
                            spacing: 10.w,
                            children: [
                              Image.asset(
                                dashboardIcon,
                                color: secondaryColor,
                                height: 18.h,
                              ),
                              Text(
                                dashboard,
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Image.asset(
                                rightArrowIcon,
                                color: secondaryColor,
                                height: 25.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(TaskListPage(
                              taskType: "All Task",
                              assignedType: "Assigned to me",
                              '',
                              ''));
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              taskIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              task,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(() => BrandingImage());
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              taskIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              iAmCanwinn,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const ContactPage());
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              contactIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              contacts,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const CalenderScreen(''));
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              calenderIcon,
                              color: secondaryColor,
                              height: 22.h,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              calender,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          feedController.fromPage.value = 'home';
                          bottomBarController.currentPageIndex.value = 2;
                          Get.to(BottomNavigationBarExample(from: 'home'));
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              calenderIcon,
                              color: secondaryColor,
                              height: 22.h,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Event",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: dailyTaskListWidget(context),
                            ),
                          );
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              calenderIcon,
                              color: secondaryColor,
                              height: 22.h,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Submit Daily Task",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      if (StorageHelper.getType() == 1) SizedBox(height: 20.h),
                      if (StorageHelper.getType() == 1)
                        InkWell(
                          onTap: () async {
                            Get.back();
                            selectedAssetsList.clear();
                            assetsList.clear();
                            assetsNameTextController.clear();
                            assetsSrnoTextController.clear();
                            quantityTextController.clear();
                            taskController.assignedUserId.clear();

                            taskController.responsiblePersonSelectedCheckBox
                                .clear();
                            taskController.responsiblePersonSelectedCheckBox
                                .addAll(List<bool>.filled(
                                    taskController.responsiblePersonList.length,
                                    false));
                            taskController.selectAll.value = false;
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: assignAssets(context),
                              ),
                            );
                          },
                          child: Row(
                            spacing: 10.w,
                            children: [
                              Image.asset(
                                calenderIcon,
                                color: secondaryColor,
                                height: 22.h,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "Assign assets",
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () async {
                          await profileController.dailyTaskList(
                              context, 'pastTask');
                          Get.back();
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              calenderIcon,
                              color: secondaryColor,
                              height: 22.h,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "View Past Task",
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(Project(''));
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              projectIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              project,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (StorageHelper.getType() == 1)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(const PageScreen());
                              },
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    taskIcon,
                                    color: secondaryColor,
                                    height: 20.h,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    page,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const NotesPages());
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              projectIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              notes,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (StorageHelper.getType() == 1)
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(const UserPage());
                              },
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  Image.asset(
                                    notesIcon,
                                    color: secondaryColor,
                                    height: 20.h,
                                  ),
                                  Text(
                                    user,
                                    style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const ToDoList(''));
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              todoIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              todo,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          isGatePasOpen.value = !isGatePasOpen.value;
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              getPassIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              gatePass,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => !isGatePasOpen.value
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(left: 25.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 20.h),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        Get.to(
                                            StorageHelper.getDepartmentId() ==
                                                    12
                                                ? const InScreenForm()
                                                : const OutScreen());
                                      },
                                      child: Row(
                                        spacing: 10.w,
                                        children: [
                                          Image.asset(
                                            notesIcon,
                                            color: secondaryColor,
                                            height: 20.h,
                                          ),
                                          Text(
                                            create,
                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () => !isOutScreenOpen.value
                                          ? SizedBox()
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30.w),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20.h),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      11)
                                                    SizedBox(height: 20.h),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      11)
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        Get.to(
                                                            const HrScreen());
                                                      },
                                                      child: Row(
                                                        spacing: 10.w,
                                                        children: [
                                                          Image.asset(
                                                            notesIcon,
                                                            color:
                                                                secondaryColor,
                                                            height: 20.h,
                                                          ),
                                                          Text(
                                                            hrScreen,
                                                            style: TextStyle(
                                                                color:
                                                                    secondaryColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      12)
                                                    SizedBox(height: 20.h),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      12)
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        Get.to(
                                                            const SecurityScreen());
                                                      },
                                                      child: Row(
                                                        spacing: 10.w,
                                                        children: [
                                                          Image.asset(
                                                            notesIcon,
                                                            color:
                                                                secondaryColor,
                                                            height: 20.h,
                                                          ),
                                                          Text(
                                                            sceurityScreen,
                                                            style: TextStyle(
                                                                color:
                                                                    secondaryColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 20.h),
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                        Get.to(const OutScreenChalanList());
                                      },
                                      child: Row(
                                        spacing: 10.w,
                                        children: [
                                          Image.asset(
                                            notesIcon,
                                            color: secondaryColor,
                                            height: 20.h,
                                          ),
                                          Text(
                                            approve,
                                            style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Obx(
                                      () => !isInScreenOpen.value
                                          ? SizedBox()
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(left: 30.w),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 20.h),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                      Get.to(
                                                          const InScreenDepartment());
                                                    },
                                                    child: Row(
                                                      spacing: 10.w,
                                                      children: [
                                                        Image.asset(
                                                          notesIcon,
                                                          color: secondaryColor,
                                                          height: 20.h,
                                                        ),
                                                        Text(
                                                          inScreenDepartment,
                                                          style: TextStyle(
                                                              color:
                                                                  secondaryColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      11)
                                                    SizedBox(height: 20.h),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      11)
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        Get.to(
                                                            const InHrScreen());
                                                      },
                                                      child: Row(
                                                        spacing: 10.w,
                                                        children: [
                                                          Image.asset(
                                                            notesIcon,
                                                            color:
                                                                secondaryColor,
                                                            height: 20.h,
                                                          ),
                                                          Text(
                                                            inScreenHr,
                                                            style: TextStyle(
                                                                color:
                                                                    secondaryColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      12)
                                                    SizedBox(height: 20.h),
                                                  if (StorageHelper
                                                          .getDepartmentId() ==
                                                      12)
                                                    InkWell(
                                                      onTap: () {
                                                        Get.back();
                                                        Get.to(
                                                            const InScreenSecurity());
                                                      },
                                                      child: Row(
                                                        spacing: 10.w,
                                                        children: [
                                                          Image.asset(
                                                            notesIcon,
                                                            color:
                                                                secondaryColor,
                                                            height: 20.h,
                                                          ),
                                                          Text(
                                                            inScreenSecurity,
                                                            style: TextStyle(
                                                                color:
                                                                    secondaryColor,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const CanwinMember());
                        },
                        child: Row(
                          spacing: 10.w,
                          children: [
                            Image.asset(
                              canwinMemberIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            Text(
                              canwinMember,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          Get.back();
                          Get.to(const SettingScreen());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              settingIcon,
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              setting,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      InkWell(
                        onTap: () {
                          logoutApp();
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/png/logout-04.png",
                              color: secondaryColor,
                              height: 20.h,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              logout,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initializeTimeControllers(int count) {
    timeControllers.clear();
    for (int i = 0; i < count; i++) {
      timeControllers.add(TextEditingController());
      remarkControllers.add(TextEditingController());
    }
  }

  final List<TextEditingController> timeControllers = [];
  final List<TextEditingController> remarkControllers = [];
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

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  RxList<bool> assetsListCheckbox = <bool>[].obs;
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
            UesrListWidget(),
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

  Future<void> logoutApp() async {
    registerController.userLogout();
  }
}
