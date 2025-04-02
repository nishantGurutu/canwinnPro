import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/screen/new_group.dart';
import 'package:task_management/view/widgets/image_screen.dart';
import '../../constant/text_constant.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  final TaskController taskController = Get.put(TaskController());
  final ChatController chatController = Get.find();
  @override
  void initState() {
    taskController.responsiblePersonListApi('');
    super.initState();
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NetworkImageScreen(file: file),
        ),
      );
    }
  }

  final TextEditingController searchAssignController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    RxList<ResponsiblePersonData> filteredList =
        RxList<ResponsiblePersonData>(taskController.responsiblePersonList);
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
          selectContact,
          style: TextStyle(
              color: textColor, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => taskController.isResponsiblePersonLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                color: backgroundColor,
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(NewGroup(taskController.responsiblePersonList));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.r),
                                ),
                              ),
                              child: Image.asset(
                                'assets/images/png/group_icon.png',
                                height: 40.h,
                                color: whiteColor,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              newGroup,
                              style:
                                  changeTextColor(robotoRegular, darkGreyColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextFormField(
                        controller: searchAssignController,
                        onChanged: (value) {
                          filteredList.value = taskController
                              .responsiblePersonList
                              .where((person) =>
                                  person.name
                                      ?.toLowerCase()
                                      .contains(value.toLowerCase()) ??
                                  false)
                              .toList();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          fillColor: Colors.white,
                          filled: true,
                          labelStyle: TextStyle(
                            color: secondaryColor,
                          ),
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: secondaryColor),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                MessageScreen(
                                    filteredList[index].name,
                                    '',
                                    filteredList[index].id.toString(),
                                    'contact',
                                    [],
                                    '',
                                    '',
                                    '',
                                    ''),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10.w, top: 10.h, right: 10.w),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xffF4E2FF).withOpacity(0.50),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 10.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          color: Color(0xffF4E2FF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(22.5),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            openFile(
                                              filteredList[index].image ?? "",
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(22.5),
                                            ),
                                            child: Image.network(
                                              filteredList[index].image ?? "",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/png/profile-image-removebg-preview.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${filteredList[index].name}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: textColor),
                                          ),
                                          Text(
                                            filteredList[index].phone == null
                                                ? ""
                                                : '${filteredList[index].phone}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff262626)
                                                    .withOpacity(0.38)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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
    );
  }
}
