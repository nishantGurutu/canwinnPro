import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Dio _dio = Dio();

  void updateHeader(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<dynamic> getData(String path) async {
    final String getUrl = '${ApiConstant.baseUrl}$path';
    try {
      final response = await _dio.get(getUrl);
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      return 'Exception';
    }
  }

  Future<Map<String, dynamic>?> postData(
      String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        print('Failed POST request to $url: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during POST request: $e');
      return null;
    }
  }

  Future<dynamic> patchData(String path, dynamic body) async {
    final String updateUrl = '${ApiConstant.baseUrl}$path';
    try {
      final response = await _dio.patch(updateUrl, data: body);
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      return 'Exception';
    }
  }

  Future<dynamic> deleteData(String path) async {
    final String deleteUrl = '${ApiConstant.baseUrl}$path';
    try {
      final response = await _dio.delete(deleteUrl);
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      return 'Exception';
    }
  }

  Future<dynamic> postMultipartData({
    required String path,
    Map<String, dynamic>? textFields,
    Map<String, dynamic>? fileFields,
  }) async {
    final String postUrl = '${ApiConstant.baseUrl}$path';
    final formData = FormData();

    if (textFields != null) {
      textFields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });
    }
    if (fileFields != null) {
      fileFields.forEach((key, value) async {
        formData.files.add(MapEntry(
          key,
          await MultipartFile.fromFile(value, filename: key),
        ));
      });
    }

    try {
      final response = await _dio.post(postUrl, data: formData);
      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.message}');
      return 'Exception';
    }
  }
}
