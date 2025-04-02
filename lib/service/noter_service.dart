import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/notes_model.dart';
import 'package:dio/dio.dart';
import '../api/api_constant.dart';
import '../constant/custom_toast.dart';

class NotesService {
  final Dio _dio = Dio();
  Future<NotesListModel?> notesListApi() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.notesList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotesListModel.fromJson(response.data);
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<bool> addNotesApi(
      String title, String description, int tag, int? priorityId) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'tags': tag,
        'priority': priorityId,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.addNotes,
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

  Future<bool> pinNotesApi(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";

      final formData = FormData.fromMap(
        {
          'notes_id': id,
        },
      );

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.notes_important,
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

  Future<bool> editNotesApi(String title, String description, int tag,
      int? priorityId, int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'tags': tag,
        'priority': priorityId,
        'id': id,
      });

      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.editNotes,
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

  Future<bool> deleteNotes(int? id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      print('task delete response is $id');
      print('task delete response is $token');
      final response = await _dio.delete(
        "${ApiConstant.baseUrl}${ApiConstant.deleteNotes}/$id",
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
}
