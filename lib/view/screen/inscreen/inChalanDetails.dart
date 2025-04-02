import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/custom_widget/text_field.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/in_screen_chalan_list.dart';
import 'package:pdf/widgets.dart' as pw;

class InChalanDetails extends StatefulWidget {
  final InScreenData chalanList;
  const InChalanDetails(this.chalanList, {super.key});

  @override
  State<InChalanDetails> createState() => _InChalanDetailsState();
}

class _InChalanDetailsState extends State<InChalanDetails> {
  final OutScreenController outScreenController =
      Get.put(OutScreenController());
  final TextEditingController rejectRemarkTextEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    outScreenController.chalanId = widget.chalanList.id ?? 0;
    outScreenController.inChalanDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          chalanDetails,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              generatePdf();
            },
            icon: Icon(
              Icons.download,
            ),
          )
        ],
      ),
      backgroundColor: whiteColor,
      body: Container(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Obx(
            () => outScreenController.outScreenChalanDetailsModel.value == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: lightGreyColor.withOpacity(0.2),
                                blurRadius: 13.0,
                                spreadRadius: 2,
                                blurStyle: BlurStyle.normal,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8.h,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        outScreenController.openFile(
                                            outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.uploadImage ??
                                                "");
                                      },
                                      child: SizedBox(
                                        height: 60.h,
                                        width: 100.w,
                                        child: Image.network(
                                          outScreenController
                                                  .inScreenChalanDetailsModel
                                                  .value
                                                  ?.data
                                                  ?.uploadImage ??
                                              "",
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50.w,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Chalan Number :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Date :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.date ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Address :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.address ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Purpose :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.purpose ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Contact :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Status :- ${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "Requested from department to approve." : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "4" ? "Reject" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "5" ? "IN" : ''}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        if (StorageHelper.getDepartmentId() == 12 &&
                            outScreenController.inScreenChalanDetailsModel.value
                                    ?.data?.status
                                    .toString() !=
                                '4')
                          if (outScreenController.inScreenChalanDetailsModel
                                  .value?.data?.status
                                  .toString() !=
                              "5")
                            InkWell(
                              onTap: () {
                                if (outScreenController
                                        .inScreenChalanDetailsModel
                                        .value
                                        ?.data
                                        ?.status
                                        .toString() !=
                                    "5") {
                                  showAlertDialog(
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                height: 40.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Add Attachment',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: whiteColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Icon(
                                      Icons.attachment,
                                      color: whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        SizedBox(height: 15.h),
                        Column(
                          children: [
                            StorageHelper.getDepartmentId() != 12
                                ? CustomTextField(
                                    enable: outScreenController
                                                .inScreenChalanDetailsModel
                                                .value
                                                ?.data
                                                ?.status
                                                .toString() ==
                                            "0"
                                        ? true
                                        : StorageHelper.getDepartmentId() ==
                                                    11 &&
                                                outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    '3'
                                            ? true
                                            : false,
                                    controller:
                                        rejectRemarkTextEditingController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    hintText: remark,
                                  )
                                : SizedBox(),
                            StorageHelper.getDepartmentId() != 12
                                ? SizedBox(height: 10.h)
                                : SizedBox(),
                            StorageHelper.getDepartmentId() != 12
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            if (outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0" ||
                                                StorageHelper
                                                            .getDepartmentId() ==
                                                        11 &&
                                                    outScreenController
                                                            .inScreenChalanDetailsModel
                                                            .value
                                                            ?.data
                                                            ?.status
                                                            .toString() ==
                                                        '3') {
                                              outScreenController
                                                  .inupdateStatus(
                                                outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.id,
                                                StorageHelper
                                                            .getDepartmentId() ==
                                                        11
                                                    ? 1
                                                    : 3,
                                                rejectRemarkTextEditingController
                                                    .text,
                                              );
                                              rejectRemarkTextEditingController
                                                  .clear();
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0"
                                                ? secondaryColor
                                                : StorageHelper.getDepartmentId() ==
                                                            11 &&
                                                        outScreenController
                                                                .inScreenChalanDetailsModel
                                                                .value
                                                                ?.data
                                                                ?.status
                                                                .toString() ==
                                                            '3'
                                                    ? secondaryColor
                                                    : lightSecondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              approve,
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (outScreenController
                                                  .isStatusUpdating.value ==
                                              false) {
                                            if (outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0" ||
                                                StorageHelper
                                                            .getDepartmentId() ==
                                                        11 &&
                                                    outScreenController
                                                            .inScreenChalanDetailsModel
                                                            .value
                                                            ?.data
                                                            ?.status
                                                            .toString() ==
                                                        '3') {
                                              outScreenController
                                                  .inupdateStatus(
                                                outScreenController
                                                    .inScreenChalanDetailsModel
                                                    .value
                                                    ?.data
                                                    ?.id,
                                                StorageHelper
                                                            .getDepartmentId() ==
                                                        11
                                                    ? 2
                                                    : 4,
                                                rejectRemarkTextEditingController
                                                    .text,
                                              );
                                              rejectRemarkTextEditingController
                                                  .clear();
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 100.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: outScreenController
                                                        .inScreenChalanDetailsModel
                                                        .value
                                                        ?.data
                                                        ?.status
                                                        .toString() ==
                                                    "0"
                                                ? secondaryColor
                                                : StorageHelper.getDepartmentId() ==
                                                            11 &&
                                                        outScreenController
                                                                .inScreenChalanDetailsModel
                                                                .value
                                                                ?.data
                                                                ?.status
                                                                .toString() ==
                                                            '3'
                                                    ? secondaryColor
                                                    : lightSecondaryColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.r),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              reject,
                                              style: changeTextColor(
                                                  rubikBlack, whiteColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                          ],
                        ),
                        StorageHelper.getDepartmentId() == 12 &&
                                outScreenController.inScreenChalanDetailsModel
                                        .value?.data?.status
                                        .toString() !=
                                    '4'
                            ? InkWell(
                                onTap: () {
                                  if (outScreenController
                                          .inScreenChalanDetailsModel
                                          .value
                                          ?.data
                                          ?.status
                                          .toString() !=
                                      "5") {
                                    outScreenController.inupdateStatus(
                                      outScreenController
                                          .inScreenChalanDetailsModel
                                          .value
                                          ?.data
                                          ?.id,
                                      5,
                                      rejectRemarkTextEditingController.text,
                                    );
                                    rejectRemarkTextEditingController.clear();
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: outScreenController
                                                .inScreenChalanDetailsModel
                                                .value
                                                ?.data
                                                ?.status
                                                .toString() ==
                                            "5"
                                        ? lightSecondaryColor
                                        : secondaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      inButton,
                                      style: changeTextColor(
                                          robotoBlack, whiteColor),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> showAlertDialog(
    BuildContext context,
  ) async {
    return showDialog(
        // barrierDismissible: false,
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
                            takeAttachment(ImageSource.gallery);
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
                            takeAttachment(ImageSource.camera);
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
        });
  }

  final ImagePicker imagePicker = ImagePicker();
  Future<void> takeAttachment(ImageSource source) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      Get.back();
      outScreenController.isChalanPicUploading.value = true;
      outScreenController.pickedFile.value = File(pickedImage.path);
      outScreenController.chalanPicPath.value = pickedImage.path.toString();
      outScreenController.isChalanPicUploading.value = false;
    } catch (e) {
      outScreenController.isChalanPicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      outScreenController.isChalanPicUploading.value = false;
    }
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    Future<pw.Font> loadFont() async {
      final fontData =
          await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
      return pw.Font.ttf(fontData);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey, width: 1),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                    'Chalan Number: ${outScreenController.inScreenChalanDetailsModel.value?.data?.challanNumber ?? ""}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    'Date: ${outScreenController.inScreenChalanDetailsModel.value?.data?.date ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Text(
                    'Address: ${outScreenController.inScreenChalanDetailsModel.value?.data?.address ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Purpose: ${outScreenController.inScreenChalanDetailsModel.value?.data?.purpose ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Contact: ${outScreenController.inScreenChalanDetailsModel.value?.data?.contact ?? ""}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.Text(
                    'Status: ${outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "1" ? "Approve" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "3" ? "Requested from department to approve." : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "2" ? "Reject" : outScreenController.outScreenChalanDetailsModel.value?.data?.status.toString() == "4" ? "Reject" : outScreenController.inScreenChalanDetailsModel.value?.data?.status.toString() == "5" ? "IN" : ''}',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final folderPath = directory.path;

    final now = DateTime.now();
    final formattedDate =
        '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
    final fileName = 'chalan_${formattedDate}.pdf';
    final filePath = '$folderPath/$fileName';
    print('afc agfgadg agfag $fileName');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (await file.exists()) {
      await downloadPDF(filePath);
    }
  }

  Future<void> downloadPDF(String filePath) async {
    try {
      final now = DateTime.now();
      final formattedDate =
          '${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}-${now.year}_${now.second}';
      final downloadPath =
          '/storage/emulated/0/Download/chalan$formattedDate.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        final downloadFile = File(downloadPath);

        if (await downloadFile.exists()) {
          await downloadFile.delete();
        }

        await file.copy(downloadPath);
        Fluttertoast.showToast(
          msg: 'Download in download folder',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      } else {}
    } catch (e) {}
  }
}
