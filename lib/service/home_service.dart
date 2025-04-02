import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/helper/storage_helper.dart';

class HomeService {
  final Dio _dio = Dio();
  Future<dynamic> homeDataApi(id) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }
  // Future<dynamic> homeDataApi(id) async {
  //   try {
  //     var token = StorageHelper.getToken();
  //     _dio.options.headers["Authorization"] = "Bearer $token";
  //     final response = await _dio.get(
  //       "${ApiConstant.baseUrl + ApiConstant.homeData}?user_id=$id",
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return response.data;
  //     } else {
  //       throw Exception('Failed notes list');
  //     }
  //   } catch (e) {
  //     print('Error in NotesService: $e');
  //     return null;
  //   }
  // }

  Future<dynamic> onetimeMsglist() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.onetime_msglist,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }

  Future<dynamic> anniversarylist() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.get(
        ApiConstant.baseUrl + ApiConstant.get_anniversary_list,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in NotesService: $e');
      return null;
    }
  }
}
