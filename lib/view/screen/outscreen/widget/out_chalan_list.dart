import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/model/outScreenChalanListModel.dart';
import 'package:task_management/view/screen/outscreen/user_chalan_details.dart';

class OutChalanlist extends StatelessWidget {
  final RxList<ChalanData> chalanList;
  const OutChalanlist(this.chalanList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: chalanList.isEmpty
            ? Center(
                child: Text(
                  'No chalan created',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            : ListView.separated(
                itemCount: chalanList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Get.to(UserChalanDetails(chalanList[index]));
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
                              Text(
                                'Chalan Number :- ${chalanList[index].challanNumber ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Date :- ${chalanList[index].date ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60.h,
                                    width: 100.w,
                                    child: Image.network(
                                      chalanList[index].uploadImagePath ?? "",
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
                                ],
                              ),
                              Text(
                                'Department Name :- ${chalanList[index].departmentFullName ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Dispatch To :- ${chalanList[index].dispatchTo ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Contact :- ${chalanList[index].contact ?? ""}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 200.0,
                                child: Obx(
                                  () => DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    decoration: BoxDecoration(
                                        color: lightSecondaryColor),
                                    columns: [
                                      DataColumn2(
                                          label: Text('S. No.'),
                                          size: ColumnSize.S,
                                          fixedWidth: 50.0),
                                      DataColumn2(
                                          label: Text('Items'),
                                          size: ColumnSize.S),
                                      DataColumn2(
                                          label:
                                              Text('RETURNABLE/NON-RETURNABLE'),
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
                                      chalanList[index].items?.length ?? 0,
                                      (index2) => DataRow(
                                        cells: [
                                          DataCell(
                                            Center(
                                              child: Text('${index2 + 1}'),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                                '${chalanList[index].items?[index2].itemName ?? ""}'),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  '${chalanList[index].items?[index2].isReturnable.toString() == "0" ? "RETURNABLE" : "NON-RETURNABLE"}'),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  '${chalanList[index].items?[index2].quantity ?? ""}'),
                                            ),
                                          ),
                                          DataCell(
                                            Center(
                                              child: Text(
                                                  '${chalanList[index].items?[index2].remarks ?? ""}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 90.h,
                                child: DataTable2(
                                  columnSpacing: 12,
                                  horizontalMargin: 12,
                                  minWidth: 600.w,
                                  decoration:
                                      BoxDecoration(color: lightSecondaryColor),
                                  columns: [
                                    DataColumn2(
                                        label: Text('PREPARED BY'),
                                        size: ColumnSize.S,
                                        fixedWidth: 120.0),
                                    DataColumn2(
                                        label: Text('APPROVED BY'),
                                        size: ColumnSize.S,
                                        fixedWidth: 120.0),
                                    DataColumn2(
                                        label: Text('RECEIVED BY'),
                                        size: ColumnSize.S,
                                        fixedWidth: 110.0),
                                  ],
                                  rows: List<DataRow>.generate(
                                    1,
                                    (index2) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                              '${chalanList[index].preparedBy ?? ""}'),
                                        ),
                                        DataCell(
                                          Text(
                                              '${chalanList[index].approvedBy ?? ""}'),
                                        ),
                                        DataCell(
                                          chalanList[index].status.toString() ==
                                                  "3"
                                              ? Text(
                                                  '${chalanList[index].receivedBy ?? ""}')
                                              : Text(''),
                                        ),
                                      ],
                                    ),
                                  ),
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
