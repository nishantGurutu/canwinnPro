import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/view/screen/message.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class HomeDiscussionList extends StatelessWidget {
  final RxList homeChatList;
  HomeDiscussionList(this.homeChatList, {super.key});
  final ChatController chatController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: homeChatList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () {
              chatController.isLongPressed[index] =
                  !chatController.isLongPressed[index];
              if (chatController.selectedChatId
                  .contains(homeChatList[index]['chat_id'])) {
                chatController.selectedChatId
                    .remove(homeChatList[index]['chat_id'] ?? 0);
              } else {
                chatController.selectedChatId
                    .add(homeChatList[index]['chat_id'] ?? 0);
              }
            },
            onTap: () {
              Get.to(() => MessageScreen(
                    homeChatList[index]['name'],
                    homeChatList[index]['chat_id'].toString(),
                    homeChatList[index]['user_id'].toString(),
                    'chat_list',
                    homeChatList[index]['members'],
                    homeChatList[index]['type'].toString(),
                    homeChatList[index]['image'].toString(),
                    homeChatList[index]['group_icon'].toString(),
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
                          child: homeChatList[index]['type']
                                      .toString()
                                      .toLowerCase() ==
                                  'group'
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22.5.h)),
                                  child: Image.network(
                                    '${homeChatList[index]['group_icon']}',
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
                                    openFile(
                                        homeChatList[index]['image'] ?? "");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(22.5.h)),
                                    child: Image.network(
                                      '${homeChatList[index]['image']}',
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
                                    '${homeChatList[index]['name'] ?? ""}',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  '${homeChatList[index]['last_message_time'] ?? ""}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
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
                                '${homeChatList[index]['last_message'] ?? ""}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.sp,
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
