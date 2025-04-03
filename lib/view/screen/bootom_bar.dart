import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/bottom_bar_navigation_controller.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/document_controller.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/controller/notification_controller.dart';
import 'package:task_management/controller/priority_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/project_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/attendence/checkin_screen.dart';
import 'package:task_management/view/screen/chat_list.dart';
import 'package:task_management/view/screen/document.dart';
import 'package:task_management/view/screen/feed.dart';
import 'package:task_management/view/screen/home_screen.dart';
import 'package:task_management/view/screen/notification.dart';
import 'package:task_management/view/screen/profile.dart';
import 'package:task_management/view/screen/reports.dart';
import 'package:task_management/view/widgets/drawer.dart';

class BottomNavigationBarExample extends StatefulWidget {
  final String? from;
  const BottomNavigationBarExample({super.key, this.from});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ChatList(),
    const FeedPage(),
    const ReportScreen(),
    const DocumentFile(),
  ];

  void _onItemTapped(int index) {
    bottomBarController.currentPageIndex.value = index;
  }

  final BottomBarController bottomBarController =
      Get.put(BottomBarController());
  final DocumentController documentController = Get.put(DocumentController());
  final ChatController chatController = Get.put(ChatController());
  final TaskController taskController = Get.put(TaskController());
  final PriorityController priorityController = Get.put(PriorityController());
  final ProjectController projectController = Get.put(ProjectController());
  final ProfileController profileController = Get.put(ProfileController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  final UserPageControlelr userPageControlelr = Get.put(UserPageControlelr());
  var profilePicPath = ''.obs;
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    homeController.isButtonVisible.value = true;
    getNameChar();
    homeController.homeDataApi('');
    profilePicPath.value = StorageHelper.getImage();
    priorityController.priorityApi();
    taskController.allProjectListApi();
    chatController.chatListApi();
    taskController.responsiblePersonListApi(StorageHelper.getDepartmentId());
    notificationController.notificationListApi('');
    super.initState();

    userPageControlelr.roleListApi(StorageHelper.getDepartmentId());
    LocationHandler.determinePosition(context);
  }

  String nameStr = "";

  void getNameChar() {
    var name = StorageHelper.getName();
    List<String> words = name.split(' ');

    for (String word in words) {
      if (word.isNotEmpty) {
        nameStr += word[0].toUpperCase();
      }
    }
  }

  String? selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];

  final List<Widget> _pages = [
    const HomeScreen(),
    const ChatList(),
    const FeedPage(),
    const ReportScreen(),
    const DocumentFile(),
  ];
  bool _isBackButtonPressed = false;
  @override
  void dispose() {
    profileController.selectedDepartMentListData.value = null;
    projectController.selectedAllProjectListData.value = null;
    taskController.reviewerCheckBox.clear();
    taskController.reviewerUserId.clear();
    taskController.responsiblePersonSelectedCheckBox.clear();
    taskController.assignedUserId.clear();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true;
    }
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => bottomBarController.isUpdating.value == true &&
              profileController.isdepartmentListLoading.value == true &&
              priorityController.isPriorityLoading.value == true &&
              projectController.isAllProjectCalling.value == true &&
              notificationController.isNotificationLoading.value == true &&
              chatController.isChatLoading.value == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                key: _key,
                drawer: Obx(
                  () =>
                      SideDrawer(userPageControlelr.selectedRoleListData.value),
                ),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: whiteColor,
                  leadingWidth: 50.w,
                  leading: InkWell(
                    onTap: () => _key.currentState?.openDrawer(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 9, right: 15),
                      child: SvgPicture.asset(
                        'assets/images/svg/menu.svg',
                        height: 20.h,
                        color: textColor,
                      ),
                    ),
                  ),
                  title: Text(
                    _getTitle(bottomBarController.currentPageIndex.value),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        chatController.deleteChat();
                      },
                      child: Obx(
                        () => chatController.isLongPressed.contains(true)
                            ? Icon(Icons.delete)
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    InkWell(
                      onTap: () {
                        Get.to(() => NotificationPage());
                      },
                      child: Obx(
                        () => Badge(
                          isLabelVisible:
                              notificationController.notificationCounter.value >
                                  0,
                          label: Text(
                              '${notificationController.notificationCounter.value}'),
                          child: SvgPicture.asset(
                            'assets/images/svg/icon.svg',
                            height: 20.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18.w),
                    InkWell(
                      onTap: () {
                        Get.to(() => ProfilePage());
                      },
                      child: Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: BoxDecoration(
                          color: darkBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.r),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$nameStr',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                ),
                body: Stack(
                  children: [
                    Center(
                      child: _widgetOptions.elementAt(
                          bottomBarController.currentPageIndex.value),
                    ),
                    if (bottomBarController.currentPageIndex.value == 0)
                      if (homeController.isButtonVisible.value == true)
                        Positioned(
                          bottom: 15.h,
                          left: 12.w,
                          child: InkWell(
                            onTap: () async {
                              Get.to(() => CheckinScreen());
                            },
                            child: Container(
                              height: 40.h,
                              width: 260.w,
                              decoration: BoxDecoration(
                                color: darkBlue,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Attendence',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: darkBlue,
                  unselectedItemColor: textColor,
                  backgroundColor: whiteColor,
                  items: [
                    _buildBottomNavItem('assets/images/png/home-logo.png',
                        'assets/images/png/white_home.png', 'Home'),
                    _buildBottomNavItem('assets/images/png/Message square.png',
                        'assets/images/png/WHITE_CHAT.png', 'Discussion'),
                    _buildBottomNavItem('assets/images/png/Component.png',
                        'assets/images/png/Component (1).png', 'Event'),
                    _buildBottomNavItem(
                        'assets/images/png/line-chart-up-01.png',
                        'assets/images/png/line-chart-up-01 (1).png',
                        'Report'),
                    _buildBottomNavItem('assets/images/png/grid-01.png',
                        'assets/images/png/grid-01 (1).png', 'Files'),
                  ],
                  currentIndex: bottomBarController.currentPageIndex.value,
                  onTap: _onItemTapped,
                ),
              ),
            ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return "Discussion";
      case 2:
        return "Event";
      case 3:
        return "Report";
      case 4:
        return "Document";
      default:
        return "";
    }
  }

  BottomNavigationBarItem _buildBottomNavItem(
      String iconPath, String activeIconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        iconPath,
        color: textColor,
        height: 20.h,
      ),
      activeIcon: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.all(
            Radius.circular(17.5.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            activeIconPath,
            color: whiteColor,
            height: 20.h,
          ),
        ),
      ),
      label: label,
      backgroundColor: Colors.white,
    );
  }
}
