import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:task_management/api/api_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/controller/attendence/checkin_user_details.dart';
import 'package:task_management/controller/register_controller.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/login_model.dart';
import 'package:task_management/model/logout_model.dart';
import 'package:task_management/model/register_model.dart';
import 'package:task_management/view/screen/bootom_bar.dart';

class RegisterService {
  final Dio _dio = Dio();
  final RegisterController registerController = Get.find();
  Future<RegisterModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String conPassword,
    required String key,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": conPassword,
          'fcm_token': key,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        registerController.isLoginSelected.value = true;
        registerController.isRegisterSelected.value = false;
        CustomToast().showCustomToast(response.data['message']);
        return RegisterModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error in RegisterService: $e');
      return null;
    }
  }

  Future<LoginModel?> loginUser({
    required String email,
    required String password,
    required key,
  }) async {
    try {
      print('device key val $key');
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.login,
        data: {
          "email": email,
          "password": password,
          "fcm_token": key,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(
            "You're in! Ready to unlock new experiences? Let's go!");
        LoginModel loginModel = LoginModel.fromJson(response.data);
        if (response.data['status'] == true) {
          StorageHelper.setId(loginModel.data?.id ?? 0);
          StorageHelper.setName(loginModel.data?.name ?? "");
          StorageHelper.setEmail(loginModel.data?.email ?? "");
          StorageHelper.setPhone(loginModel.data?.phone ?? "");
          StorageHelper.setRole(loginModel.data?.role ?? 0);
          StorageHelper.setDepartmentId(loginModel.data?.departmentId ?? 0);
          StorageHelper.setGender(loginModel.data?.gender ?? '');
          StorageHelper.setImage(loginModel.data?.image ?? '');
          StorageHelper.setDob(loginModel.data?.dob ?? '');
          StorageHelper.setType(loginModel.data?.type ?? 0);
          StorageHelper.setRecoveryPassword(
              loginModel.data?.recoveryPassword ?? "");
          StorageHelper.setToken(loginModel.data?.token ?? "");
          StorageHelper.setTokenType(loginModel.data?.tokenType ?? "");
          if (StorageHelper.getType() == 3) {
            Get.offAll(() => const CheckinUserDetails());
          } else {
            Get.offAll(BottomNavigationBarExample());
          }
        }
        return LoginModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
        // throw Exception('Failed to register user');
      }
    } catch (e) {
      CustomToast().showCustomToast('Something went wrong.');
      return null;
    }
  }

  Future<LogoutModel?> logoutUser() async {
    try {
      var token = StorageHelper.getToken();
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.post(
        ApiConstant.baseUrl + ApiConstant.logout,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast().showCustomToast(response.data['message']);
        return LogoutModel.fromJson(response.data);
      } else {
        CustomToast().showCustomToast(response.data['message']);
      }
    } catch (e) {
      return null;
    }
  }
}
