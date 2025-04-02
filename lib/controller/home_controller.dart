import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/service/home_service.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  RxBool isButtonVisible = true.obs;
  var isHomeDataLoading = false.obs;
  RxDouble taskProgressDetail = 0.0.obs;
  RxInt totalTaskAssigned = 0.obs;
  RxInt taskCreatedByMe = 0.obs;
  RxInt dueTodayTask = 0.obs;
  RxInt totalTasksPastDue = 0.obs;
  RxInt progressTask = 0.obs;
  RxInt avgTaskCreated = 0.obs;
  RxInt avgTaskAssigned = 0.obs;
  RxInt avgTaskDue = 0.obs;
  RxInt avgPastTaskDue = 0.obs;
  RxInt newTask = 0.obs;
  RxInt completedTask = 0.obs;
  RxInt totalTaskAssignedHigh = 0.obs;
  RxInt totalTaskAssignedMedium = 0.obs;
  RxInt totalTaskAssignedLow = 0.obs;
  RxInt totalTask = 0.obs;
  var homeChatList = [].obs;
  var homeTaskList = [].obs;
  var homeTaskCommentsList = [].obs;
  var homePinnedNotes = [].obs;
  Future<void> homeDataApi(id) async {
    isHomeDataLoading.value = true;
    final result = await HomeService().homeDataApi(id);
    if (result != null) {
      totalTask.value = (result['data']['total_task'] ?? 0).toInt();
      taskCreatedByMe.value =
          (result['data']['task_created_by_me'] ?? 0).toInt();
      totalTaskAssigned.value =
          (result['data']['total_task_assigned'] ?? 0).toInt();
      dueTodayTask.value = (result['data']['due_today_task'] ?? 0).toInt();
      totalTasksPastDue.value =
          (result['data']['total_tasks_past_due'] ?? 0).toInt();
      progressTask.value = (result['data']['progress_task'] ?? 0).toInt();
      avgTaskCreated.value = (result['data']['avg_task_created'] ?? 0).toInt();
      avgTaskAssigned.value =
          (result['data']['avg_task_assigned'] ?? 0).toInt();
      avgTaskDue.value = (result['data']['avg_task_due'] ?? 0).toInt();
      taskProgressDetail.value =
          (result['data']['avg_completed_task'] ?? 0.0).toDouble();
      newTask.value = (result['data']['new_task'] ?? 0).toInt();
      completedTask.value = (result['data']['completed_task'] ?? 0).toInt();
      avgPastTaskDue.value = (result['data']['avg_task_past_due'] ?? 0).toInt();
      totalTaskAssignedHigh.value =
          (result['data']['total_task_assigned_high'] ?? 0).toInt();
      totalTaskAssignedMedium.value =
          (result['data']['total_task_assigned_high'] ?? 0).toInt();
      homeChatList.assignAll(result['data']['chatlist']);
      homeTaskList.assignAll(result['data']['tasklist']);
      homeTaskCommentsList.assignAll(result['data']['taskscomments']);
      homePinnedNotes.assignAll(result['data']['pinnedNotes']);
    } else {}
    isHomeDataLoading.value = false;
  }

  RxString onTimemsg = ''.obs;
  RxString onTimemsgUrl = ''.obs;
  var isOneTimeMsgLoading = false.obs;
  Future<void> onetimeMsglist() async {
    isOneTimeMsgLoading.value = true;
    final result = await HomeService().onetimeMsglist();
    if (result != null) {
      if (result['data'] != null) {
        onTimemsg.value = result['data']['message'];
        onTimemsgUrl.value = result['data']['link'];
      }

      if (StorageHelper.getOnetimeMsg().toString().toLowerCase() !=
          onTimemsg.value.toString().toLowerCase()) {
        StorageHelper.setOnetimeMsg(onTimemsg.value);
        StorageHelper.setIsSnackbarShown(true);
      }
    } else {}
    isOneTimeMsgLoading.value = false;
  }

  var isAnniversaryLoading = false.obs;
  var anniversaryListData = [].obs;
  Future<void> anniversarylist(BuildContext context) async {
    isAnniversaryLoading.value = true;
    final result = await HomeService().anniversarylist();
    if (result != null) {
      anniversaryListData.clear();
      anniversaryListData.assignAll(result['data']);
      if (anniversaryListData.isNotEmpty) {
        if (StorageHelper.getAnniversaryVisible() == false) {}
      }
    } else {}
    isAnniversaryLoading.value = false;
  }
}
