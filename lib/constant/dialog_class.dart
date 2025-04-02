import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/constant/color_constant.dart';

class ShowDialogFunction {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> sosMsg(BuildContext context, eventData, DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await _audioPlayer.play(AssetSource('mp3/emergency_alarm_69780.mp3'));
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
                      Image.asset(
                        "assets/images/png/sos_image.png",
                        height: 80.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$eventData',
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
                  onTap: () async {
                    prefs.setString('Elite Staffing Solutions', '');
                    Get.back();
                    await _audioPlayer.stop();
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

  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource('mp3/emergency_alarm_69780.mp3'));
  }

  Future<void> _restartAudio() async {
    await _audioPlayer.seek(Duration.zero);
    await _playAudio();
  }

  Future<void> sosMsg2(BuildContext context, eventData, DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await _audioPlayer.play(AssetSource('mp3/emergency_alarm_69780.mp3'));
    await _audioPlayer.onPlayerComplete.listen((event) {
      _restartAudio();
    });
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
                      Image.asset(
                        "assets/images/png/sos_image.png",
                        height: 80.h,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '$eventData',
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
                  onTap: () async {
                    prefs.setString('Elite Staffing Solutions', '');
                    Get.back();
                    await _audioPlayer.stop();
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
}
