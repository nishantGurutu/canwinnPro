import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/chat_history_model.dart';
import 'package:task_management/model/chat_list_model.dart';

class ChatService {
  final Dio _dio = Dio();
  Future<ChatListModel?> chatServiceApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.chatList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<bool?> updateGroupIconApi(String? chatId, Rx<File> pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'chat_id': chatId,
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['group_icon'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.update_group_icon,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<ChatHistoryModel?> chatHistoryServiceApi(String? id, int page) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl}${ApiConstant.chatHistory}?chat_id=$id&page=$page",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatHistoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load chat history data');
      }
    } catch (e) {
      print('Error in chat history: $e');
      return null;
    }
  }

  Future<ChatHistoryModel?> deleteChat(RxList<int> selectedChatId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio
          .post("${ApiConstant.baseUrl}${ApiConstant.deleteChat}", data: {
        "chat_ids": selectedChatId,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return ChatHistoryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load chat history data');
      }
    } catch (e) {
      print('Error in chat history: $e');
      return null;
    }
  }

  Future<dynamic> sendMessageApi(String? id, String text, String? chatId,
      String? fromPage, Rx<File> pickedFile) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      debugPrint('send message id $id');
      debugPrint('send message id 2 $chatId');
      debugPrint('send message id 3 $pickedFile');

      final Map<String, dynamic> formDataMap = {};
      if (text != null && text.isNotEmpty) {
        formDataMap['message'] = text;
      }
      if (id != "" && id != "null" && id != null) {
        formDataMap['receiver_id'] = id;
      }
      if (chatId != "" && chatId != "null" && chatId != null) {
        formDataMap['chat_id'] = chatId;
      }
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.sendMessage,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> addGroupUser(
      String? chatId, RxList<int> selectedChatId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('add member value $chatId');
      print('add member value 2 $selectedChatId');
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.group_chat_add_users,
        data: {"chat_id": chatId, "user_ids": selectedChatId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return response.data;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> groupCreate(String text, List<int> selectedPersonList) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.createGroup,
        data: {
          'group_name': text,
          'user_ids': selectedPersonList,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "Group created successfully! Time to share ideas and make plans!");
        return response.data;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> memberListApi(String? chatId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.chat_members}/$chatId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return null;
    }
  }
}
