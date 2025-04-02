import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';

class DiscussionService {
  final Dio _dio = Dio();
  Future<bool> addDiscussion(String comment, int? discussionId, int? taskId,
      Rx<File> pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'comment': comment,
      };

      if (discussionId != null && discussionId > 0) {
        formDataMap['comment_id'] = discussionId;
      }
      if (taskId != null && taskId > 0) {
        formDataMap['task_id'] = taskId;
      }

      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      print("Sending data: $comment");
      print("Sending data: 2 $taskId");
      print("Sending data: 3 $discussionId");
      print("Sending data: 4 ${pickedFile.value.path}");

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.store_task_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<bool> likeUnlike(commentId, int i) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'comment_id': commentId.toString(),
        'comment_type': i.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      print("Sending data: $formDataMap");

      final response = await _dio.post(
        // 'https://taskmaster.electionmaster.in/public/api/like-unlike-comment',
        ApiConstant.baseUrl + ApiConstant.like_unlike_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<bool> addDislike(commentId, int i) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'comment_id': commentId.toString(),
        'comment_type': i.toString(),
      };

      final formData = FormData.fromMap(formDataMap);

      print("Sending data: $formDataMap");

      final response = await _dio.post(
        // 'https://taskmaster.electionmaster.in/public/api/like-unlike-comment',
        ApiConstant.baseUrl + ApiConstant.dislike_undislike_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }

  Future<dynamic> discussionList(int? taskId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'task_id': taskId,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.list_task_comment,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data.toString());
        return false;
      }
    } catch (e) {
      print("Error in addDiscussion: $e");
      return false;
    }
  }
}
