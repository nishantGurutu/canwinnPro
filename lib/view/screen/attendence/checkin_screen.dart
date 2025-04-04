import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/component/location_handler.dart';
import 'package:task_management/component/location_service.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/attendence/attendence_controller.dart';
import 'package:task_management/controller/attendence/checkin_user_details.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/attendence/apply_leave.dart';
import 'package:task_management/view/screen/attendence/attendence_screen.dart';
import 'package:task_management/view/screen/attendence/widget/camera_view.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final AttendenceController attendenceController =
      Get.put(AttendenceController());
  final RegisterController registerController = Get.put(RegisterController());
  @override
  void initState() {
    LocationHandler.determinePosition(context);
    super.initState();
    if (StorageHelper.getType() != 3) {
      attendenceController
          .attendenceUserDetailsApi(StorageHelper.getId().toString());
    }
    checkAndResetAttendanceData();
    fetchAddress();
  }

  Future<void> logoutApp() async {
    registerController.userLogout();
  }

  void checkAndResetAttendanceData() {
    String? storedPunchData = StorageHelper.getIsPunchinDate();
    if (storedPunchData != null && storedPunchData.isNotEmpty) {
      List<String> dateParts = storedPunchData.split(' ');
      if (dateParts.length >= 2) {
        String storedDate = dateParts.last;
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        if (storedDate != currentDate) {
          StorageHelper.setIsPunchinDate('');
          StorageHelper.setIsPunchin('');
        }
      }
    }
  }

  RxBool isAddressLoading = false.obs;
  String? locaitonAddress;
  void fetchAddress() async {
    isAddressLoading.value = true;
    latitude = (LocationService.locationData.latitude ?? 0.0).toString();
    longitude = (LocationService.locationData.longitude ?? 0.0).toString();
    attendenceTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    String? address =
        "${LocationHandler.place?.locality}, ${LocationHandler.place?.country}";
    StorageHelper.setUserLocationName(address ?? '');
    locaitonAddress = address ?? "Could not fetch address";
    isAddressLoading.value = false;
    print('location lat long data 2 ${latitude}, ${longitude}, ${address}');
  }

  String latitude = '';
  String longitude = '';
  String address = '';
  String attendenceTime = '';

  bool isWithinRange(
      double lat1, double lon1, double lat2, double lon2, double range) {
    const double earthRadius = 6371000;
    double dLat = (lat2 - lat1) * (3.14159265359 / 180);
    double dLon = (lon2 - lon1) * (3.14159265359 / 180);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1 * (3.14159265359 / 180)) *
            cos(lat2 * (3.14159265359 / 180)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance <= range;
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
          checkin,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (StorageHelper.getType() == 3)
            InkWell(
              onTap: () {
                logoutApp();
              },
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(Icons.logout),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: lightBlueColor,
        child: Obx(
          () => isAddressLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: lightButtonColor,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Hello,',
                                    style: TextStyle(
                                      color: lightGreyColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${StorageHelper.getName()}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => AttendenceScreen());
                                  },
                                  child: Container(
                                    height: 85.h,
                                    width: 110.w,
                                    decoration: BoxDecoration(
                                      color: lightBlueColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/png/attendence_icon.png',
                                          height: 35.h,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'Attendance',
                                          style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Container(
                                  height: 85.h,
                                  width: 110.w,
                                  decoration: BoxDecoration(
                                    color: lightBlueColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/png/expense_icon-removebg-preview.png',
                                        height: 35.h,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        'Expense Claims',
                                        style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 25.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "More Actions",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => ApplyLeave());
                                    },
                                    child: Container(
                                      height: 55.h,
                                      width: 55.w,
                                      decoration: BoxDecoration(
                                        color: lightGreenColor,
                                        border:
                                            Border.all(color: lightGreenColor2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/png/umbrela-icon-removebg-preview.png',
                                          height: 35.h,
                                          color: greenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    'Apply\nLeaves',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30.w,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 55.h,
                                    width: 55.w,
                                    decoration: BoxDecoration(
                                      color: lightGreenColor,
                                      border:
                                          Border.all(color: lightGreenColor2),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.r),
                                      ),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/png/expanse-image-removebg-preview.png',
                                        height: 65.h,
                                        fit: BoxFit.cover,
                                        color: greenColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    'Add Expense\n',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Spacer(),
                    if (StorageHelper.getType() != 3)
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.r),
                            topLeft: Radius.circular(20.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: Obx(
                            () {
                              DateTime dateTime = DateTime.now();
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(dateTime);

                              String? storedPunchData =
                                  StorageHelper.getIsPunchinDate();
                              List<String> date = (storedPunchData != null &&
                                      storedPunchData.isNotEmpty)
                                  ? storedPunchData.split(' ')
                                  : [];

                              bool isPunchOutToday = (date.length >= 2 &&
                                  date.first == 'checkout' &&
                                  date.last == formattedDate);
                              return InkWell(
                                onTap: () async {
                                  print(
                                      'location lat long data ${latitude}, ${longitude}, ${locaitonAddress}');
                                  if (!attendenceController
                                      .isAttendencePunching.value) {
                                    // if (isWithinRange(
                                    //     double.parse(latitude),
                                    //     double.parse(longitude),
                                    //     28.4973874,
                                    //     77.0210997,
                                    //     500)) {
                                    await availableCameras().then(
                                      (value) => Get.to(
                                        () => CameraView(
                                          cameras: value,
                                          type: "checkin",
                                          latitude: latitude,
                                          longitude: longitude,
                                          attendenceTime: attendenceTime,
                                          address: locaitonAddress ?? "",
                                        ),
                                      ),
                                    );
                                    // } else {
                                    //   CustomToast().showCustomToast(
                                    //       'You are out of office area.');
                                    // }
                                  }
                                },
                                child: Container(
                                  height: 40.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:
                                        // isPunchOutToday
                                        //     ? Color(0xFFFFCDD2)
                                        //     :
                                        Color.fromARGB(255, 244, 54, 54),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.r),
                                    ),
                                  ),
                                  child: Center(
                                    child:
                                        (attendenceController
                                                    .isAttendencePunching
                                                    .value ||
                                                attendenceController
                                                    .isAttendencePunchout
                                                    .value ||
                                                attendenceController
                                                        .isuserDetailsAttendenceListLoading
                                                        .value ==
                                                    true)
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                      color: whiteColor),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text(
                                                // attendenceController.isPunchin.value ||
                                                //         StorageHelper.getIsPunchin() ==
                                                //             "punchin"
                                                attendenceController
                                                            .attendenceUserDetails
                                                            .value
                                                            ?.data
                                                            ?.punchin ==
                                                        1
                                                    ? "Punch Out"
                                                    : "Punch In",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                              ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (StorageHelper.getType() == 3)
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20.r),
                            topLeft: Radius.circular(20.r),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => CheckinUserDetails());
                            },
                            child: Container(
                              height: 40.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 244, 54, 54),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Check User",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
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
}
