import 'dart:io';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';
import 'package:task_management/model/department_list_model.dart';
import 'package:task_management/view/widgets/custom_dropdawn.dart';

class OutScreen extends StatefulWidget {
  const OutScreen({super.key});

  @override
  State<OutScreen> createState() => _OutScreenState();
}

class _OutScreenState extends State<OutScreen> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final ProfileController profileController = Get.put(ProfileController());

  ValueNotifier<int?> focusedIndexNotifier = ValueNotifier<int?>(null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController chalanNumberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController departmentNameController =
      TextEditingController();
  final TextEditingController dispatchToController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController preparedByController = TextEditingController();
  final TextEditingController receivedByController = TextEditingController();
  @override
  void initState() {
    profileController.departmentList(0);
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
      outScreenController.isChalanPicUploading.value = true;
      outScreenController.pickedFile.value = File(pickedImage.path);
      outScreenController.chalanPicPath.value = pickedImage.path.toString();
      outScreenController.isChalanPicUploading.value = false;
    } catch (e) {
      outScreenController.isChalanPicUploading.value = false;
    } finally {
      outScreenController.isChalanPicUploading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          outScreen,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 15.h,
                children: [
                  InkWell(
                    onTap: () {
                      takePhoto(ImageSource.camera);
                    },
                    child: Obx(
                      () => outScreenController.chalanPicPath.value.isEmpty
                          ? Container(
                              height: 90.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                              ),
                              child: Center(
                                child: Text('Upload Image'),
                              ),
                            )
                          : Container(
                              height: 90.h,
                              width: 90.w,
                              child: Image.file(
                                File(
                                  outScreenController.chalanPicPath.value,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                  ),
                  TextField(
                    controller: dateController,
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
                      hintText: date,
                      hintStyle: rubikRegular,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: lightSecondaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightSecondaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightSecondaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightSecondaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd-MM-yyyy').format(pickedDate);
                        dateController.text = formattedDate;
                      }
                    },
                  ),
                  CustomDropdown<DepartmentListData>(
                    items: profileController.departmentDataList,
                    itemLabel: (item) => item.name ?? '',
                    onChanged: (value) {
                      profileController.selectedDepartMentListData.value =
                          value!;
                    },
                    hintText: selectDepartment,
                  ),
                  TaskCustomTextField(
                    controller: dispatchToController,
                    textCapitalization: TextCapitalization.sentences,
                    data: dispatch,
                    hintText: dispatch,
                    labelText: dispatch,
                    index: 4,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  TaskCustomTextField(
                    controller: contactController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    data: contact,
                    hintText: contact,
                    labelText: contact,
                    index: 5,
                    maxLength: 10,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context2) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context2)
                                      .viewInsets
                                      .bottom),
                              child: addDataTableBottomSheet(
                                context2,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 30.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Add Data',
                              style: TextStyle(
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200.0,
                    child: Obx(
                      () => DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 600,
                        decoration: BoxDecoration(color: lightSecondaryColor),
                        columns: [
                          DataColumn2(
                              label: Text('S. No.'),
                              size: ColumnSize.S,
                              fixedWidth: 50.0),
                          DataColumn2(label: Text('Items'), size: ColumnSize.S),
                          DataColumn2(
                              label: Text('RETURNABLE/NON-RETURNABLE'),
                              size: ColumnSize.L),
                          DataColumn2(
                              label: Text('QTY'),
                              size: ColumnSize.S,
                              fixedWidth: 40.0),
                          DataColumn2(
                              label: Text('REMARKS'),
                              size: ColumnSize.S,
                              numeric: true,
                              fixedWidth: 70.0),
                        ],
                        rows: List<DataRow>.generate(
                          outScreenController.tableData.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                    '${outScreenController.tableData[index].srno}'),
                              ),
                              DataCell(
                                Text(
                                    '${outScreenController.tableData[index].itemName}'),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                      '${outScreenController.tableData[index].isReturnable.toString() == "0" ? "RETURNABLE" : "NON-RETURNABLE"}'),
                                ),
                              ),
                              DataCell(
                                Text(
                                    '${outScreenController.tableData[index].quantity}'),
                              ),
                              DataCell(
                                Text(
                                    '${outScreenController.tableData[index].remarks}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  TaskCustomTextField(
                    controller: preparedByController,
                    textCapitalization: TextCapitalization.sentences,
                    data: preparedBy,
                    hintText: preparedBy,
                    labelText: preparedBy,
                    index: 6,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  TaskCustomTextField(
                    controller: receivedByController,
                    textCapitalization: TextCapitalization.sentences,
                    data: receivedBy,
                    hintText: receivedBy,
                    labelText: receivedBy,
                    index: 7,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                  Obx(
                    () => CustomButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (outScreenController
                                  .isOutScreenChalanAdding.value !=
                              true) {
                            outScreenController.addOutScreenChalanApi(
                              dateController.text,
                              profileController
                                  .selectedDepartMentListData.value?.id,
                              dispatchToController.text,
                              contactController.text,
                              preparedByController.text,
                              outScreenController.tableData,
                              receivedByController.text,
                            );
                          }
                        }
                      },
                      text: outScreenController.isOutScreenChalanAdding.value ==
                              true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  loading,
                                  style:
                                      changeTextColor(rubikBlack, whiteColor),
                                ),
                              ],
                            )
                          : Text(
                              save,
                              style: changeTextColor(rubikBlack, whiteColor),
                            ),
                      color: primaryColor,
                      height: 45.h,
                      width: double.infinity,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  Widget addDataTableBottomSheet(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 410.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15.h,
              children: [
                SizedBox(height: 5.h),
                Text(
                  'Add Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TaskCustomTextField(
                  controller: outScreenController.itemController,
                  textCapitalization: TextCapitalization.none,
                  data: item,
                  hintText: item,
                  labelText: item,
                  index: 7,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                CustomDropdown<String>(
                  items: outScreenController.returnableValue,
                  itemLabel: (item) => item,
                  onChanged: (value) {
                    outScreenController.selectedReturnableValue.value = value!;
                    print(
                        'returnable and non-returnable data vlaue ${outScreenController.selectedReturnableValue?.value}');
                  },
                  hintText: selectReturnable,
                ),
                TaskCustomTextField(
                  controller: outScreenController.quantityController,
                  textCapitalization: TextCapitalization.none,
                  data: qty,
                  hintText: qty,
                  labelText: qty,
                  keyboardType: TextInputType.number,
                  index: 9,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                TaskCustomTextField(
                  controller: outScreenController.remarkController,
                  textCapitalization: TextCapitalization.none,
                  data: remark,
                  hintText: remark,
                  labelText: remark,
                  index: 10,
                  focusedIndexNotifier: focusedIndexNotifier,
                ),
                Obx(
                  () => CustomButton(
                    onPressed: () {
                      int returnType = 0;
                      if (outScreenController.selectedReturnableValue?.value ==
                          'false') {
                        returnType = 1;
                      } else {
                        returnType = 0;
                      }
                      if (_formKey2.currentState!.validate()) {
                        outScreenController.tableDataAdding(
                          outScreenController.itemController.text,
                          returnType,
                          outScreenController.quantityController.text,
                          outScreenController.remarkController.text,
                        );
                      }
                    },
                    text: outScreenController.isDataAdding.value == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: whiteColor,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                loading,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor),
                              ),
                            ],
                          )
                        : Text(
                            add,
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    width: double.infinity,
                    color: primaryColor,
                    height: 45.h,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
