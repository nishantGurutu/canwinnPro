import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/firebase_messaging/notification_service.dart';
import 'package:task_management/model/callender_eventList_model.dart';
import 'package:task_management/service/calender_service.dart';

class CalenderController extends GetxController {
  RxList<String> timeList = <String>[
    "Minutes",
    "Hours",
  ].obs;
  RxString? selectedTime = "".obs;

  RxList<String> categoryColorName = <String>[].obs;
  RxString selectedCategoryColorName = ''.obs;
  var isCalenderLoading = false.obs;
  RxList<CallenderEventData> eventsList = <CallenderEventData>[].obs;
  int hour = 0;
  int minute = 0;
  Future<void> eventListApi() async {
    isCalenderLoading.value = true;
    final result = await CalenderService().eventList();
    if (result != null) {
      eventsList.clear();
      eventsList.assignAll(result.data!);
      isCalenderLoading.value = false;

      for (var dt in eventsList) {
        if (dt.eventDate != null) {
          String dateInput = "${dt.eventDate} ${dt.eventTime}";

          DateFormat inputFormat = DateFormat("dd-MM-yyyy h:mm a");
          DateFormat outputFormat = DateFormat("dd-MM-yyyy HH:mm");
          DateTime dateTime = inputFormat.parse(dateInput.toUpperCase());

          String dateOutput = outputFormat.format(dateTime);
          List<String> splitDt = dateOutput.split(" ");
          List<String> splitDt2 = splitDt.first.split('-');
          List<String> splitDt3 = splitDt[1].split(':');

          String strReminder = "${dt.reminder}";
          print('set reminder value split $strReminder');

          List<String> splitReminder = strReminder.split(" ");
          if (splitReminder.first != "null") {
            int reminderTime = int.parse(splitReminder.first);
            String reminderTimeType = splitReminder.last;
            if (reminderTimeType.toLowerCase() == 'minutes') {
              minute = int.parse(splitDt3.last) - reminderTime;
              hour = int.parse(splitDt3.first);
            } else {
              minute = int.parse(splitDt3.last);
              hour = int.parse(splitDt3.first) - reminderTime;
            }
          }
          DateTime dtNow = DateTime.now();
          DateTime targetDate = DateTime(
            int.parse(splitDt2.last),
            int.parse(splitDt2[1]),
            int.parse(splitDt2.first),
            hour,
            minute,
            0,
          );

          if (dt.reminder != null && dt.reminder is int) {
            targetDate = targetDate
                .subtract(Duration(minutes: int.parse(dt.reminder.toString())));
          }

          print('Adjusted target date: 2 $targetDate');

          final randomId = Random().nextInt(1000);
          if (targetDate.isAfter(dtNow)) {
            LocalNotificationService().scheduleNotification(
                targetDate, randomId, dt.eventName ?? "", 'calender');
          }
        }
      }
    } else {}
    isCalenderLoading.value = false;
  }

  final TextEditingController eventControllerEditingController =
      TextEditingController();
  final TextEditingController eventDateControllerEditingController =
      TextEditingController();
  final TextEditingController eventTimeControllerEditingController =
      TextEditingController();

  var isEventAdding = false.obs;
  Future<void> addEventApi(String text, String date, String time,
      String reminder, String? reminderType) async {
    isEventAdding.value = true;
    final result = await CalenderService()
        .addEventApi(text, date, time, reminder, reminderType);
    if (result != null) {
      isEventAdding.value = false;
      eventControllerEditingController.clear();
      eventDateControllerEditingController.clear();
      eventTimeControllerEditingController.clear();
      Get.back();
      await eventListApi();
    }
    isEventAdding.value = false;
  }

  var isTaskDeleting = false.obs;
  Future<void> deleteEvent(int? id) async {
    isTaskDeleting.value = true;
    final result = await CalenderService().deleteEvent(id);
    if (result) {
      await eventListApi();
    } else {}
    isTaskDeleting.value = false;
  }
}
