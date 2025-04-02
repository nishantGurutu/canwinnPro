import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/task_category_list_model.dart';
import 'package:task_management/model/task_details_model.dart';

class TaskService {
  final Dio _dio = Dio();
  Future<dynamic> taskListApi(
    String? selectedTaskValue,
    String assignValue,
    int value,
    String date,
    String userId,
  ) async {
    String filterVal = '';
    String taskCompleted = '';
    if (selectedTaskValue == "All Task") {
      filterVal = 'all';
    } else if (selectedTaskValue == "Important") {
      filterVal = 'important';
    } else if (selectedTaskValue == "New Task") {
      filterVal = "pending";
    } else if (selectedTaskValue == "Progress") {
      filterVal = "progress";
    } else if (selectedTaskValue == "Past Due") {
      filterVal = "past_due";
    } else if (selectedTaskValue == "Due Today") {
      filterVal = "past_due_today";
    } else {
      filterVal = 'completed';
    }

    if (assignValue == 'Task created by me') {
      taskCompleted = 'byme';
    } else if (assignValue == 'Task review by me') {
      taskCompleted = 'reviewbyme';
    } else {
      taskCompleted = 'tome';
    }
    print('user id selectde in task from home $userId');
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'filter': filterVal,
        'order': "desc",
        'task_for': taskCompleted,
        'page': value,
      };
      if (date.isNotEmpty) {
        formDataMap['date'] = date;
      }
      if (userId.isNotEmpty) {
        formDataMap['user_id'] = userId;
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.taskList,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<TaskCategoryListModel?> taskCategoryListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.taskCategoryList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskCategoryListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResponsiblePersonListModel?> responsiblePersonListApi(
      dynamic id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.responsiblePersonList}?dept_id=${id == null ? '' : id}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponsiblePersonListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> userLogActivity(dynamic id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'user_id': id,
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.get_user_log_activities,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  Future<TaskDetailsModel?> taskDetails(int? taskId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.taskDetails}/$taskId",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskDetailsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      return null;
    }
  }

  String assignedId = '';
  String reviewerId = '';
  Future<bool> addTaskApi(
      String taskName,
      String remark,
      int selectedProjectId,
      int? departmentId,
      Rx<File> pickedFile,
      RxList<String> assignedUserId,
      RxList<String> reviewerUserId,
      String startDate,
      String dueDate,
      String dueTime,
      int? priorityId) async {
    try {
      assignedId = '';
      for (int i = 0; i < assignedUserId.length; i++) {
        if (assignedUserId[i].isNotEmpty) {
          if (assignedId.isEmpty) {
            assignedId = assignedUserId[i].toString();
          } else {
            assignedId += ",${assignedUserId[i].toString()}";
          }
        }
      }
      reviewerId = '';
      for (int i = 0; i < reviewerUserId.length; i++) {
        if (reviewerUserId[i].isNotEmpty) {
          if (reviewerId.isEmpty) {
            reviewerId = reviewerUserId[i].toString();
          } else {
            reviewerId += ",${reviewerUserId[i].toString()}";
          }
        }
      }

      var token = StorageHelper.getToken();
      var userId = StorageHelper.getId();

      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        "user_id": userId.toString(),
        'title': taskName.toString(),
        'assigned_to': assignedId.toString(),
        'department_id': departmentId.toString(),
        'start_date': startDate.toString(),
        'due_date': dueDate.toString(),
        'due_time': dueTime.toString(),
        'priority': priorityId.toString(),
        'reviewer': reviewerId.toString(),
        'description': remark.toString(),
        'project_id': selectedProjectId.toString(),
        'status': 1
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addTask,
        data: formData,
        options: Options(
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast()
            .showCustomToast("Task added Successfully! Let's get to work!");
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addSubTaskApi(String taskName, String startDate, String dueDate,
      String dueTime, int? priorityId, id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'title': taskName,
        'start_date': startDate,
        'due_date': dueDate,
        'due_time': dueTime,
        'priority': priorityId,
        "task_id": id
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addTask,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editSubTaskApi(String taskName, String startDate, String dueDate,
      String dueTime, int? priorityId, int id) async {
    try {
      var token = await StorageHelper.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Authorization token is missing.");
      }

      _dio.options.headers["Authorization"] = "Bearer $token";

      final Map<String, dynamic> formDataMap = {
        'title': taskName,
        'start_date': startDate,
        'due_date': dueDate,
        'due_time': dueTime,
        'priority': priorityId,
        'task_id': id
      };

      final response = await _dio.post(
        "${ApiConstant.baseUrl}${ApiConstant.editTask}",
        data: FormData.fromMap(formDataMap),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(
            response.data['message'] ?? "Failed to update task.");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editTaskApi(
      String taskName,
      String remark,
      int? projectId,
      int? deptId,
      RxList<String> assignedUserId,
      RxList<String> reviewerUserId,
      String startDate,
      String dueDate,
      String dueTime,
      int? priorityId,
      newTaskListId,
      Rx<File> pickedFile) async {
    try {
      assignedId = '';
      for (var assign in assignedUserId) {
        if (assignedId.isEmpty) {
          assignedId = assign;
        } else {
          assignedId = assign + ", " + assign;
        }
      }
      reviewerId = '';
      for (var review in reviewerUserId) {
        if (reviewerId.isEmpty) {
          reviewerId = review;
        } else {
          reviewerId = review + ", " + review;
        }
      }

      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final Map<String, dynamic> formDataMap = {
        'title': taskName,
        'assigned_to': assignedId,
        'department_id': deptId,
        'start_date': startDate,
        'due_date': dueDate,
        'due_time': dueTime,
        'priority': priorityId,
        'reviewer': reviewerId,
        'description': remark,
        'project_id': projectId,
        'status': 1,
        'id': newTaskListId,
      };
      if (pickedFile.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile.value.path,
          filename: pickedFile.value.path.split('/').last,
        );
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editTask,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTask(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('task delete response is $id');
      print('task delete response is $token');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteTask}/$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to delete source');
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProgressTask(
      int? id, String statusRemark, int i, Rx<File> pickedFile2) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      print('change status value $id');
      print('change status value 2 $i');
      print('change status value 3 $statusRemark');
      print('change status value 4 $pickedFile2');
      final Map<String, dynamic> formDataMap = {
        'task_id': id,
        'status': i,
        'remarks': statusRemark,
      };

      if (pickedFile2.value.path.isNotEmpty) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          pickedFile2.value.path,
          filename: pickedFile2.value.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.updateTaskProgress,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to add source');
      }
    } catch (e) {
      return false;
    }
  }
}
