import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/component/location_service.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/image_constant.dart';
import 'package:task_management/controller/attendence/checkin_user_details.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/view/screen/bootom_bar.dart';
import 'package:task_management/view/screen/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    LocationService.initialize();
    Future.delayed(
      const Duration(seconds: 2),
    ).then(
      (value) => isUserLogin(),
    );
  }

  Future<void> isUserLogin() async {
    int? userId = StorageHelper.getId();

    if (userId != null) {
      if (StorageHelper.getType() == 3) {
        Get.offAll(() => const CheckinUserDetails());
      } else {
        Get.offAll(() => const BottomNavigationBarExample());
      }
      // Get.offAll(() => const BottomNavBar());
    } else {
      Get.offAll(() => const WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                splashLogo,
                height: 120.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
