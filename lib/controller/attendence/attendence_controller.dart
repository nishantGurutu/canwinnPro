import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/model/attendence_user_details.dart';
import 'package:task_management/service/attendence/attendence_service.dart';

class AttendenceController extends GetxController {
  var isPunchin = false.obs;
  var attendenceStatusList =
      ["Present", "Absent", "Half Day", "Leave", "Fine", "Overtime"].obs;
  var attendenceStatusValueList = ["14(+6)", "0", "0", "5", "0:00", "0:00"].obs;
  var isAttendencePunching = false.obs;
  Future<void> attendencePunching(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    isAttendencePunching.value = true;
    final result = await AttendenceService().attendencePunching(
        pickedFile, address, latitude, longitude, attendenceTime, searchText);
    if (result != null) {
      isPunchin.value = true;
      if (StorageHelper.getType() != 3) {
        DateTime dateTime = DateTime.now();
        String formattedDate =
            "checkin ${DateFormat('yyyy-MM-dd').format(dateTime)}";
        StorageHelper.setIsPunchinDate(formattedDate);
        StorageHelper.setIsPunchin('punchin');
      } else {
        searchTextEditingController.clear();
        attendenceUserDetails.value = null;
      }
    } else {}
    isAttendencePunching.value = false;
  }

  var isAttendencePunchout = false.obs;
  Future<void> attendencePunchout(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    isAttendencePunchout.value = true;
    final result = await AttendenceService().attendencePunchout(
        pickedFile, address, latitude, longitude, attendenceTime, searchText);
    if (result != null) {
      isPunchin.value = false;
      if (StorageHelper.getType() != 3) {
        DateTime dateTime = DateTime.now();
        String formattedDate =
            "checkout ${DateFormat('yyyy-MM-dd').format(dateTime)}";
        StorageHelper.setIsPunchinDate(formattedDate);
        StorageHelper.setIsPunchin('punchout');
      }
    } else {}
    isAttendencePunchout.value = false;
  }

  var attendenceListModel = Rxn<AttendenceListModel>();

  var isAttendenceListLoading = false.obs;
  Future<void> attendenceList() async {
    isAttendenceListLoading.value = true;
    final result = await AttendenceService().attendenceList();
    if (result != null) {
      attendenceListModel.value = result;
      attendenceListModel.refresh();
      isAttendenceListLoading.value = false;
    } else {}
    isAttendenceListLoading.value = false;
  }

  final TextEditingController searchTextEditingController =
      TextEditingController();
  var attendenceUserDetails = Rxn<AttendenceUserDetails>();

  var isuserDetailsAttendenceListLoading = false.obs;
  Future<void> attendenceUserDetailsApi(String value) async {
    isuserDetailsAttendenceListLoading.value = true;
    final result = await AttendenceService().attendenceUserDetailsApi(value);
    if (result != null) {
      isuserDetailsAttendenceListLoading.value = false;
      attendenceUserDetails.value = result;
    } else {}
    isuserDetailsAttendenceListLoading.value = false;
  }
}
