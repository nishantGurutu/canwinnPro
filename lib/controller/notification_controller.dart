import 'package:get/get.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/service/notification_service.dart';

class NotificationController extends GetxController {
  var isNotificationLoading = false.obs;
  var isAllSelect = false.obs;
  var isCheckBoxSelect = false.obs;
  var isScrolling = false.obs;
  var notificationList = [].obs;
  RxList<bool> notificationSelectList = <bool>[].obs;
  RxList<String> notificationSelectidList = <String>[].obs;
  RxList<String> notificationSelectTypeList = <String>[].obs;
  var notificationCounter = 0.obs;
  RxInt pageValue = 1.obs;
  RxInt prePageCount = 1.obs;
  Future<void> notificationListApi(String type) async {
    if (type.toString() != 'scrolling') {
      isNotificationLoading.value = true;
    } else {
      isScrolling.value = true;
    }

    final result =
        await NotificationService().notificationListApi(pageValue.value);

    if (result != null) {
      if (type.toString() == '') {
        isAllSelect.value = false;
        notificationList.clear();
        notificationSelectList.clear();
      }

      if ((result['data'].length ?? 0) >= 50) {
        prePageCount.value = pageValue.value;
        notificationList.addAll(result['data']);
      } else {
        pageValue.value = prePageCount.value;
        notificationList.addAll(result['data']);
      }

      while (notificationSelectList.length < notificationList.length) {
        notificationSelectList.add(isAllSelect.value);
      }

      isNotificationLoading.value = false;
      isScrolling.value = false;
      notificationCounter.value = result['totalnotification'];
      refresh();
    } else {
      if (type.toString() != 'scrolling') {
        isNotificationLoading.value = false;
      } else {
        isScrolling.value = false;
      }
    }

    if (type.toString() != 'scrolling') {
      isNotificationLoading.value = false;
    } else {
      isScrolling.value = false;
    }
  }

  var isNotificationDeleting = false.obs;
  Future<void> deleteNotificationListApi(
      RxList<String> notificationSelectidList,
      RxList<String> notificationSelectTypeList) async {
    isNotificationDeleting.value = true;
    final result = await NotificationService().deleteNotificationListApi(
        notificationSelectidList, notificationSelectTypeList);
    if (result != null) {
      CustomToast().showCustomToast(result['message']);
      await notificationListApi('');

      isNotificationDeleting.value = false;
    } else {
      isNotificationDeleting.value = false;
    }
    isNotificationDeleting.value = false;
  }
}
