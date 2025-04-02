import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class DiscussionList extends StatelessWidget {
  final RxList<ChatListData> filteredList;
  DiscussionList(this.filteredList, {super.key});

  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: filteredList.length + 1,
        itemBuilder: (context, index) {
          if (index >= filteredList.length) {
            return SizedBox(height: 60.h);
          }

          return InkWell(
            onLongPress: () {
              chatController.isLongPressed[index] =
                  !chatController.isLongPressed[index];
              if (chatController.selectedChatId
                  .contains(filteredList[index].chatId)) {
                chatController.selectedChatId
                    .remove(filteredList[index].chatId ?? 0);
              } else {
                chatController.selectedChatId
                    .add(filteredList[index].chatId ?? 0);
              }
            },
            onTap: () {
              Get.to(() => MessageScreen(
                    filteredList[index].name,
                    filteredList[index].chatId.toString(),
                    filteredList[index].userId.toString(),
                    'chat_list',
                    filteredList[index].members,
                    filteredList[index].type.toString(),
                    filteredList[index].image.toString(),
                    filteredList[index].groupIcon.toString(),
                    "",
                  ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF4E2FF).withOpacity(0.50),
                  borderRadius: BorderRadius.all(Radius.circular(8.r)),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                        () => Container(
                          height: 45.h,
                          width: 45.h,
                          decoration: BoxDecoration(
                            color: Color(0xffF4E2FF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(22.5.h)),
                          ),
                          child: filteredList[index]
                                      .type
                                      .toString()
                                      .toLowerCase() ==
                                  'group'
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.5.h)),
                                  child: Image.network(
                                    '${filteredList[index].groupIcon}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/png/group_icon.png',
                                        height: 40.h,
                                        color: whiteColor,
                                      );
                                    },
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    openFile(filteredList[index].image ?? "");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(22.5.h)),
                                    child: Image.network(
                                      '${filteredList[index].image}',
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
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${filteredList[index].name ?? ""}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${filteredList[index].lastMessageTime ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color(0xff262626).withOpacity(0.38)),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                '${filteredList[index].lastMessage ?? ""}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff262626).withOpacity(0.38)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(() => NetworkImageScreen(file: file));
    }
  }
}
