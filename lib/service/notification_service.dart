import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';

class NotificationService {
  final Dio _dio = Dio();

  Future<dynamic> notificationListApi(int value) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.notification_list}?page=$value",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<dynamic> deleteNotificationListApi(
      RxList<String> notificationSelectidList,
      RxList<String> notificationSelectTypeList) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      String ids = notificationSelectidList.join(",");
      String types = notificationSelectTypeList.join(",");
      print('notification selected data in service class $ids and $types');

      final response = await _dio.delete(
        "${ApiConstant.baseUrl + ApiConstant.delete_notification}",
        data: {
          "id": ids,
          "type": types,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to delete notifications');
      }
    } catch (e) {
      return null;
    }
  }
}
