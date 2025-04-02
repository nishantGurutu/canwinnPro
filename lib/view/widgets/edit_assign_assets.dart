import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/custom_widget/button_widget.dart';
import 'package:task_management/custom_widget/task_text_field.dart';

class EditAssignAssets extends StatelessWidget {
  final int? id;
  final TextEditingController? nameTextEditingController;
  final TextEditingController? qtyTextEditingController;
  final TextEditingController? serialNoTextEditingController;
  final ValueNotifier<int?> focusedIndexNotifier;
  final String? name;
  final ProfileController profileController;
  const EditAssignAssets(
      this.id,
      this.nameTextEditingController,
      this.qtyTextEditingController,
      this.serialNoTextEditingController,
      this.focusedIndexNotifier,
      this.name,
      this.profileController,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
      ),
      width: double.infinity,
      height: 610.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Edit Assign Assets',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: nameTextEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    data: assets,
                    hintText: assets,
                    labelText: assets,
                    index: 0,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
                SizedBox(
                  width: 160.w,
                  child: TaskCustomTextField(
                    controller: qtyTextEditingController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    data: qty,
                    hintText: qty,
                    labelText: qty,
                    index: 1,
                    focusedIndexNotifier: focusedIndexNotifier,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            SizedBox(
              child: TaskCustomTextField(
                controller: serialNoTextEditingController,
                textCapitalization: TextCapitalization.sentences,
                data: srNo,
                hintText: srNo,
                labelText: srNo,
                index: 3,
                focusedIndexNotifier: focusedIndexNotifier,
              ),
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                border: Border.all(color: lightSecondaryColor),
                color: lightSecondaryColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Text(
                  '$name',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Spacer(),
            CustomButton(
              onPressed: () {
                profileController.editAssignAssets(
                  id,
                  nameTextEditingController,
                  qtyTextEditingController,
                  serialNoTextEditingController,
                );
              },
              text: Text(
                submit,
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
          ],
        ),
      ),
    );
  }
}
