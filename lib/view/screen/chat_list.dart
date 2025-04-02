import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/controller/profile_controller.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/view/screen/select_contact.dart';
import 'package:task_management/view/widgets/discussion_list.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatController chatController = Get.find();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    chatController.selectedChatId.clear();
    chatController.chatListApi();
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
    RxList<ChatListData> filteredList =
        RxList<ChatListData>(chatController.chatList);
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      body: Obx(
        () => Container(
          width: double.infinity,
          color: backgroundColor,
          child: chatController.chatList.isEmpty
              ? Center(
                  child: Text(""),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextFormField(
                        controller: searchAssignController,
                        onChanged: (value) {
                          filteredList.value = chatController.chatList
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: DiscussionList(filteredList),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkBlue,
        child: Icon(
          Icons.add,
          color: whiteColor,
          size: 30.h,
        ),
        onPressed: () {
          Get.to(() => SelectContact());
        },
      ),
    );
  }

  Widget floatingActionButton() {
    return InkWell(
      onTap: () {
        Get.to(() => SelectContact());
      },
      child: Container(
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(27.r),
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
        child: Center(
          child: Icon(
            Icons.add,
            color: whiteColor,
            size: 30.sp,
          ),
        ),
      ),
    );
  }
}
