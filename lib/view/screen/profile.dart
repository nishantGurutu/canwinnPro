import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/controller/user_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/role_list_model.dart';
import 'package:task_management/view/widgets/department_list_widget.dart';
import 'package:task_management/view/widgets/edit_assign_assets.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import 'package:task_management/view/widgets/my_dalily_task_list.dart';
import 'package:task_management/view/widgets/pdf_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.find();
  final UserPageControlelr userPageControlelr = Get.find();
  final TextEditingController anniversaryDateController =
      TextEditingController();
  @override
  void initState() {
    profileController.userDetails();
    profileController.departmentList(0);
    profileController.dailyTaskList(context, '');
    super.initState();
  }

  final ImagePicker imagePicker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      profileController.isProfilePicUploading.value = true;
      profileController.dataFromImagePicker.value = true;
      profileController.pickedFile.value = File(pickedImage.path);
      profileController.profilePicPath.value = pickedImage.path.toString();
      profileController.isProfilePicUploading.value = false;
      Get.back();
    } catch (e) {
      profileController.isProfilePicUploading.value = false;
    } finally {
      profileController.isProfilePicUploading.value = false;
    }
  }

  @override
  void dispose() {
    profileController.dataFromImagePicker.value = false;
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkImageScreen(file: file),
        ),
      );
    } else if (fileExtension == 'pdf') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(file: File(file)),
        ),
      );
    } else if (['xls', 'xlsx'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file viewing not supported yet.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file type.')),
      );
    }
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10.sp),
          child: Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.gallery);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/png/gallery-icon-removebg-preview.png',
                                height: 20.h,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          takePhoto(ImageSource.camera);
                        },
                        child: Container(
                          height: 40.h,
                          width: 130.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final TextEditingController assetsNameTextController =
      TextEditingController();
  final TextEditingController qtytextEditingControlelr =
      TextEditingController();
  final TextEditingController srNoTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Obx(
          () => profileController.isUserDetailsLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: SvgPicture.asset(
                                    'assets/images/svg/back_arrow.svg'),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: Stack(
                                    children: [
                                      Obx(
                                        () => profileController
                                                .profilePicPath.value.isEmpty
                                            ? Container(
                                                height: 90.h,
                                                width: 90.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(45.r),
                                                    ),
                                                    border: Border.all(
                                                        color: borderColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              45.r)),
                                                  child: Image.asset(
                                                      'assets/images/png/profile-image-removebg-preview.png'),
                                                ),
                                              )
                                            : profileController
                                                            .dataFromImagePicker
                                                            .value ==
                                                        false &&
                                                    profileController
                                                        .profilePicPath
                                                        .value
                                                        .isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      openFile(
                                                        profileController
                                                                .profilePicPath
                                                                .value ??
                                                            '',
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 90.h,
                                                      width: 90.w,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      45.r))),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    45.r)),
                                                        child: Image.network(
                                                          "${profileController.profilePicPath.value}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 90.h,
                                                    width: 90.w,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    45.r))),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45.r)),
                                                      child: Image.file(
                                                        File(
                                                          profileController
                                                              .profilePicPath
                                                              .value,
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                      ),
                                      Positioned(
                                        bottom: 5.h,
                                        right: 1.w,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: textColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: whiteColor,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  completeYourProfile,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: MyDailyTask(
                                              profileController
                                                  .dailyTaskDataList,
                                              onTaskAdded: () =>
                                                  profileController
                                                      .dailyTaskList(
                                                          context, ""),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.r)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Daily task',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: whiteColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .nameTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  data: name,
                                  hintText: name,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .emailTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.emailAddress,
                                  data: email,
                                  hintText: email,
                                ),
                                SizedBox(height: 15.h),
                                CustomTextField(
                                  controller: profileController
                                      .mobileTextEditingController.value,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  data: mobileNumber,
                                  hintText: mobileNumber,
                                ),
                                SizedBox(height: 15.h),
                                DepartmentList(),
                                SizedBox(height: 15.h),
                                DropdownButtonHideUnderline(
                                  child: Obx(
                                    () => DropdownButton2<RoleListData>(
                                      isExpanded: true,
                                      hint: Text(
                                        "Select Role",
                                        style: changeTextColor(
                                            rubikRegular, darkGreyColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: userPageControlelr.roleList
                                          .map(
                                            (RoleListData item) =>
                                                DropdownMenuItem<RoleListData>(
                                              value: item,
                                              child: Text(
                                                item.name ?? '',
                                                style: changeTextColor(
                                                    rubikRegular, Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      value: userPageControlelr
                                          .selectedRoleListData.value,
                                      onChanged: (RoleListData? value) {
                                        userPageControlelr
                                            .selectedRoleListData.value = value;

                                        print(
                                            'user details name data ${userPageControlelr.selectedRoleListData.value?.id}');
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 45.h,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 10.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color: lightSecondaryColor),
                                          color: lightSecondaryColor,
                                        ),
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: Image.asset(
                                          'assets/images/png/Vector 3.png',
                                          color: secondaryColor,
                                          height: 8.h,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: lightGreyColor,
                                        iconDisabledColor: lightGreyColor,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200.h,
                                        width: 312.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: lightSecondaryColor,
                                            border: Border.all(
                                                color: lightSecondaryColor)),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items: profileController.genderList
                                          .map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto',
                                              color: darkGreyColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      value: profileController
                                              .selectedGender!.value.isEmpty
                                          ? null
                                          : profileController
                                              .selectedGender?.value,
                                      onChanged: (String? value) {
                                        profileController.selectedGender
                                            ?.value = value ?? '';
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 50,
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                          border: Border.all(
                                              color: lightSecondaryColor),
                                          color: lightSecondaryColor,
                                        ),
                                      ),
                                      hint: Text(
                                        'Select Gender'.tr,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontFamily: 'Roboto',
                                          color: darkGreyColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      iconStyleData: IconStyleData(
                                        icon: Image.asset(
                                          'assets/images/png/Vector 3.png',
                                          color: secondaryColor,
                                          height: 8.h,
                                        ),
                                        iconSize: 14,
                                        iconEnabledColor: lightGreyColor,
                                        iconDisabledColor: lightGreyColor,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 200,
                                        width: 330,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: lightSecondaryColor,
                                            border: Border.all(
                                                color: lightSecondaryColor)),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness:
                                              WidgetStateProperty.all<double>(
                                                  6),
                                          thumbVisibility:
                                              WidgetStateProperty.all<bool>(
                                                  true),
                                        ),
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 14, right: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => TextField(
                                    controller: profileController
                                        .dobTextEditingController.value,
                                    decoration: InputDecoration(
                                      fillColor: lightSecondaryColor,
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Image.asset(
                                          'assets/images/png/callender.png',
                                          color: secondaryColor,
                                          height: 10.h,
                                        ),
                                      ),
                                      hintText: dob,
                                      hintStyle: rubikRegular,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        profileController
                                            .dobTextEditingController
                                            .value
                                            .text = formattedDate;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Anniversary Date',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Obx(
                                  () => TextField(
                                    controller: profileController
                                        .anniversaryDateController.value,
                                    decoration: InputDecoration(
                                      fillColor: lightSecondaryColor,
                                      filled: true,
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Image.asset(
                                          'assets/images/png/anniversary_logo.png',
                                          height: 10.h,
                                        ),
                                      ),
                                      hintText: dateFormate,
                                      hintStyle: rubikRegular,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: lightSecondaryColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.r)),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            DateFormat('dd-MM-yyyy')
                                                .format(pickedDate);
                                        profileController
                                            .anniversaryDateController
                                            .value
                                            .text = formattedDate;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Obx(
                                  () => CustomButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (profileController
                                                .isProfileUpdating.value !=
                                            true) {
                                          profileController.updateProfile(
                                              profileController
                                                  .nameTextEditingController
                                                  .value
                                                  .value
                                                  .text,
                                              profileController
                                                  .emailTextEditingController
                                                  .value
                                                  .text,
                                              profileController
                                                  .mobileTextEditingController
                                                  .value
                                                  .text,
                                              profileController
                                                  .selectedDepartMentListData
                                                  .value
                                                  ?.id,
                                              userPageControlelr
                                                  .selectedRoleListData
                                                  .value
                                                  ?.id,
                                              profileController
                                                  .selectedGender?.value,
                                              profileController
                                                  .dobTextEditingController
                                                  .value
                                                  .text,
                                              profileController
                                                      .selectedAnniversary
                                                      ?.value ??
                                                  "",
                                              profileController
                                                  .anniversaryDateController
                                                  .value
                                                  .text,
                                              context);
                                        }
                                      }
                                    },
                                    text: profileController
                                                .isProfileUpdating.value ==
                                            true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 30.h,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: whiteColor,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                loading,
                                                style: changeTextColor(
                                                    rubikBlack, whiteColor),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            updateProfile,
                                            style: changeTextColor(
                                                rubikBlack, whiteColor),
                                          ),
                                    color: primaryColor,
                                    height: 45.h,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                profileController.assetsList.isNotEmpty
                                    ? Column(
                                        children: [
                                          Text(
                                            'Your assigned Assets',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150.w,
                                      child: Center(
                                        child: Text(
                                          'Sr no.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120.w,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                      child: Center(
                                        child: Text(
                                          'Qty',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30.w,
                                      child: Center(
                                        child: Text(
                                          '',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                for (int i = 0;
                                    i < profileController.assetsList.length;
                                    i++)
                                  Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.r),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: lightGreyColor
                                                  .withOpacity(0.2),
                                              blurRadius: 13.0,
                                              spreadRadius: 2,
                                              blurStyle: BlurStyle.normal,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.h),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 140.w,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      child: Text(
                                                        '${profileController.assetsList[i].serialNo ?? ''}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120.w,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 3.w),
                                                      child: Text(
                                                        '${profileController.assetsList[i].name ?? ''}',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40.w,
                                                    child: Center(
                                                      child: Text(
                                                        '${profileController.assetsList[i].qty ?? ''}',
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.h,
                                                    width: 25.w,
                                                    child:
                                                        PopupMenuButton<String>(
                                                      color: whiteColor,
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: 200.w,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.r)),
                                                      shadowColor:
                                                          lightGreyColor,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: const Icon(
                                                          Icons.more_vert),
                                                      onSelected:
                                                          (String result) {
                                                        switch (result) {
                                                          case 'edit':
                                                            assetsNameTextController
                                                                    .text =
                                                                profileController
                                                                    .assetsList[
                                                                        i]
                                                                    .name
                                                                    .toString();
                                                            qtytextEditingControlelr
                                                                    .text =
                                                                profileController
                                                                    .assetsList[
                                                                        i]
                                                                    .qty
                                                                    .toString();
                                                            srNoTextController
                                                                    .text =
                                                                profileController
                                                                    .assetsList[
                                                                        i]
                                                                    .serialNo
                                                                    .toString();

                                                            profileController
                                                                .assetsList[i]
                                                                .userId;

                                                            showModalBottomSheet(
                                                              context: context,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (context) =>
                                                                      Padding(
                                                                padding: EdgeInsets.only(
                                                                    bottom: MediaQuery.of(
                                                                            context)
                                                                        .viewInsets
                                                                        .bottom),
                                                                child:
                                                                    EditAssignAssets(
                                                                  profileController
                                                                      .assetsList[
                                                                          i]
                                                                      .id,
                                                                  assetsNameTextController,
                                                                  qtytextEditingControlelr,
                                                                  srNoTextController,
                                                                  focusedIndexNotifier,
                                                                  StorageHelper
                                                                      .getName(),
                                                                  profileController,
                                                                ),
                                                              ),
                                                            );

                                                            break;
                                                          case 'delete':
                                                            if (profileController
                                                                    .isAssestAssignDeleting
                                                                    .value ==
                                                                false) {
                                                              profileController
                                                                  .deleteAssignAssets(
                                                                      profileController
                                                                          .assetsList[
                                                                              i]
                                                                          .id);
                                                            }
                                                            break;
                                                        }
                                                      },
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry<
                                                              String>>[
                                                        PopupMenuItem<String>(
                                                          value: 'edit',
                                                          child: ListTile(
                                                            leading:
                                                                Image.asset(
                                                              "assets/images/png/edit-icon.png",
                                                              height: 20.h,
                                                            ),
                                                            title: Text(
                                                              'Edit',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: ListTile(
                                                            leading:
                                                                Image.asset(
                                                              'assets/images/png/delete-icon.png',
                                                              height: 20.h,
                                                            ),
                                                            title: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
}
