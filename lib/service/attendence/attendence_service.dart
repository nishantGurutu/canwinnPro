import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/attendence_list_model.dart';
import 'package:task_management/model/attendence_user_details.dart';

class AttendenceService {
  final Dio _dio = Dio();
  Future<bool?> attendencePunching(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      print('attendence data 1 $pickedFile');
      print('attendence data 2 $address');
      print('attendence data 3 $latitude');
      print('attendence data 4 $longitude');
      print('attendence data 5 $attendenceTime');
      final Map<String, dynamic> formDataMap = {
        'check_in': attendenceTime.toString(),
        'check_in_latitude': latitude.toString(),
        'check_in_longitude': longitude.toString(),
        'check_in_address': address.toString(),
      };
      if (pickedFile.path.isNotEmpty) {
        formDataMap['check_in_image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.path.split('/').last,
        );
      }
      if (StorageHelper.getType() == 3) {
        formDataMap['user_id'] = searchText.toString();
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        'https://taskmaster.electionmaster.in/public/api/add-user-checkin',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<bool?> attendencePunchout(
      File pickedFile,
      String address,
      String latitude,
      String longitude,
      String attendenceTime,
      String searchText) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        'check_out': attendenceTime.toString(),
        'check_out_latitude': latitude.toString(),
        'check_out_longitude': longitude.toString(),
        'check_out_address': address.toString(),
      };
      if (pickedFile.path.isNotEmpty) {
        formDataMap['check_out_image'] = await MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.path.split('/').last,
        );
      }
      if (StorageHelper.getType() == 3) {
        formDataMap['user_id'] = searchText.toString();
      }
      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        'https://taskmaster.electionmaster.in/public/api/add-user-checkout',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return true;
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<AttendenceListModel?> attendenceList() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      // final Map<String, dynamic> formDataMap = {
      //   'check_out': attendenceTime.toString(),
      //   'check_out_latitude': latitude.toString(),
      //   'check_out_longitude': longitude.toString(),
      //   'check_out_address': address.toString(),
      // };

      // final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.monthly_attendance_summary,
        // data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendenceListModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }

  Future<AttendenceUserDetails?> attendenceUserDetailsApi(String value) async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "multipart/form-data",
      };
      final Map<String, dynamic> formDataMap = {
        'user_id': value.toString(),
      };

      final formData = FormData.fromMap(formDataMap);
      final response = await _dio.post(
        "https://taskmaster.electionmaster.in/public/api/get-user-details",
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendenceUserDetails.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed notes list');
      }
    } catch (e) {
      print('Error in Attendence punch: $e');
      return null;
    }
  }
}
