import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/login_model.dart';
import 'package:task_management/model/register_model.dart';
import 'package:task_management/service/register_service.dart';
import 'package:task_management/view/screen/unauthorised/login.dart';

class RegisterController extends GetxController {
  final TextEditingController registerNameTextEditingController =
      TextEditingController();
  final TextEditingController registerEmailTextEditingController =
      TextEditingController();
  final TextEditingController registerPasswordTextEditingController =
      TextEditingController();
  final TextEditingController registerConPasswordTextEditingController =
      TextEditingController();

  var isLoading = false.obs;
  var isVisibility = true.obs;
  var isVisibility2 = true.obs;
  var isVisibility3 = true.obs;
  var registerModel = RegisterModel().obs;
  RxBool isLoginSelected = true.obs;
  RxBool isRegisterSelected = false.obs;

  // Registration function
  Future<void> registerUser(String name, String email, String password,
      String conPassword, String deviceTokenToSendPushNotification) async {
    isLoading.value = true;
    final result = await RegisterService().registerUser(
        name: name,
        email: email,
        password: password,
        conPassword: conPassword,
        key: deviceTokenToSendPushNotification);
    if (result != null) {
      registerModel.value = result;
    } else {}
    isLoading.value = false;
  }

  // Login function
  var isLoginLoading = false.obs;
  var loginModel = LoginModel().obs;
  Future<void> userLogin(
      String email, String password, deviceTokenToSendPushNotification) async {
    isLoginLoading.value = true;
    final result = await RegisterService().loginUser(
        email: email,
        password: password,
        key: deviceTokenToSendPushNotification);
    if (result != null) {
      loginModel.value = result;
    } else {}
    isLoginLoading.value = false;
  }

  Future<void> userLogout() async {
    isLoginLoading.value = true;
    final result = await RegisterService().logoutUser();
    if (result != null) {
      StorageHelper.clear();
      Get.offAll(() => const LoginScreen());
    } else {}
    isLoginLoading.value = false;
  }
}
