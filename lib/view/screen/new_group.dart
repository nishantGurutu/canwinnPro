import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/new_group_second.dart';
import '../../constant/text_constant.dart';

class NewGroup extends StatefulWidget {
  final RxList<ResponsiblePersonData> responsiblePersonList;
  const NewGroup(this.responsiblePersonList, {super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  RxList<ResponsiblePersonData> selectedList = <ResponsiblePersonData>[].obs;

  @override
  void initState() {
    selectedList.clear();
    super.initState();
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
          newGroup,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Container(
          width: double.infinity,
          color: backgroundColor,
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: widget.responsiblePersonList.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => InkWell(
                        onTap: () {
                          if (selectedList
                              .contains(widget.responsiblePersonList[index])) {
                            selectedList
                                .remove(widget.responsiblePersonList[index]);
                          } else {
                            selectedList
                                .add(widget.responsiblePersonList[index]);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, top: 10.h, right: 10.w),
                          child: Row(
                            children: [
                              Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: lightGreyColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22.5),
                                  ),
                                  child: Image.network(
                                    '${widget.responsiblePersonList[index].image}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/png/profile-image-removebg-preview.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Text(
                                "${widget.responsiblePersonList[index].name}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: textColor),
                              ),
                              Spacer(),
                              selectedList.contains(
                                      widget.responsiblePersonList[index])
                                  ? SvgPicture.asset(
                                      'assets/images/svg/done.svg',
                                      height: 16.h,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 8.h,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          if (selectedList.isNotEmpty) {
            Get.to(NewGroupSecond(selectedList));
          } else {
            CustomToast().showCustomToast('Please select person.');
          }
        },
        backgroundColor: primaryColor,
        child: Image.asset(
          'assets/images/png/next.png',
          color: whiteColor,
          height: 20.w,
        ),
      ),
    );
  }
}
