import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/out_screen_controller.dart';
import 'package:task_management/model/in_screen_chalan_list.dart';
import 'package:task_management/view/screen/inscreen/inChalanDetails.dart';

class InChalanlist extends StatelessWidget {
  final RxList<InScreenData> inScreenChalanList;
  final OutScreenController outScreenController;
  const InChalanlist(this.inScreenChalanList, this.outScreenController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: inScreenChalanList.isEmpty
            ? Center(
                child: Text(
                  'No chalan created',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.separated(
                itemCount: outScreenController.inScreenChalanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Get.to(InChalanDetails(
                          inScreenChalanList[index],
                        ));
                      },
                      child: Container(
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
                                          inScreenChalanList[index]
                                                  .uploadImage ??
                                              "");
                                    },
                                    child: SizedBox(
                                      height: 60.h,
                                      width: 100.w,
                                      child: Image.network(
                                        inScreenChalanList[index].uploadImage ??
                                            "",
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(),
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
                                'Chalan Number :- ${inScreenChalanList[index].challanNumber ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Date :- ${inScreenChalanList[index].date ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Department Name :- ${inScreenChalanList[index].entryToDepartment ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Address :- ${inScreenChalanList[index].address ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Contact :- ${inScreenChalanList[index].contact ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 0.h,
                  );
                },
              ),
      ),
    );
  }
}
