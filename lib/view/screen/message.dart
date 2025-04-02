// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/style_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/controller/chat_controller.dart';
import 'package:task_management/helper/date_helper.dart';
import 'package:task_management/helper/pusher_config.dart';
import 'package:task_management/helper/storage_helper.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/view/screen/group_member.dart';
import 'package:task_management/view/screen/splash_screen.dart';
import 'package:task_management/view/widgets/image_screen.dart';

class MessageScreen extends StatefulWidget {
  final String? name;
  final String? chatId;
  final String? userId;
  final String? fromPage;
  final String? type;
  final List<Members>? members;
  final String image;
  final String groupIcon;
  final String? navigationType;
  const MessageScreen(this.name, this.chatId, this.userId, this.fromPage,
      this.members, this.type, this.image, this.groupIcon, this.navigationType,
      {super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController messageTextEditingController = TextEditingController();
  final ChatController chatController = Get.put(ChatController());
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatController.pageCountValue.value = 1;
    chatController.chatIdvalue.value = widget.chatId.toString();

    _scrollController.addListener(_scrollListener);
    chatController.chatHistoryListApi(
        widget.chatId, chatController.pageCountValue.value, 'initstate');
    if (chatController.chatIdvalue.value.isNotEmpty) {
      PusherConfig().initPusher(chatController.onPusherEvent,
          channelName: "chat", roomId: chatController.chatIdvalue.value);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    chatController.chatHistoryList.clear();
    PusherConfig().disconnect();
    chatController.pageCountValue.value = 1;
    chatController.chatIdvalue.value = '';
    super.dispose();
  }

  String previousCreateddate = "";

  bool _isBackButtonPressed = false;
  Future<bool> _onWillPop() async {
    if (!_isBackButtonPressed) {
      if (widget.navigationType == "notification") {
        Get.offAll(() => SplashScreen());
      } else {
        Get.back();
        await chatController.chatListApi();
      }
      return true;
    } else {
      return true;
    }
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      chatController.pageCountValue.value += 1;
      chatController.chatHistoryListApi(
          widget.chatId, chatController.pageCountValue.value, '');
      print('scroll controller listining');
    } else if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      chatController.pageCountValue.value -= 1;
      chatController.chatHistoryListApi(
          widget.chatId, chatController.pageCountValue.value, '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int loggedInUserId = StorageHelper.getId();
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 85.w,
          leading: Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (widget.navigationType == "notification") {
                    Get.offAll(() => SplashScreen());
                  } else {
                    Navigator.of(context).pop(true);
                    Get.back();
                    await chatController.chatListApi();
                  }
                },
                icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
              ),
              SizedBox(
                width: 45,
                height: 45,
                child: widget.type.toString().toLowerCase() == "group"
                    ? Obx(
                        () => InkWell(
                          onTap: () {
                            chatController.pickedFile.value = File('');
                            chatController.messagePicPath.value = '';
                            showAlertDialog(context, 'group');
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Color(0xffF4E2FF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(22.5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: chatController
                                      .messagePicPath.value.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        openFile(chatController
                                            .messagePicPath.value);
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(22.5),
                                        child: Image.file(
                                          File(chatController
                                              .messagePicPath.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : widget.image.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(22.5),
                                          child: Image.network(
                                            widget.image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.network(
                                                '${widget.groupIcon}',
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/png/group_icon.png',
                                                    fit: BoxFit.cover,
                                                    color: whiteColor,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/png/group_icon.png',
                                          fit: BoxFit.cover,
                                          color: whiteColor,
                                        ),
                            ),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(22.5),
                        child: InkWell(
                          onTap: () {
                            openFile(widget.image);
                          },
                          child: Image.network(
                            widget.image,
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/png/profile-image-removebg-preview.png',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          title: InkWell(
            onTap: () {
              if (widget.type.toString().toLowerCase() == "group") {
                Get.to(GroupMemberlist(widget.chatId));
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.name}", style: rubikBlack),
                Text("Active", style: rubikSmall),
              ],
            ),
          ),
        ),
        body: Obx(
          () => chatController.isChatHistoryLoading.value == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Column(
                  children: [
                    chatController.chatHistoryList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                noMessage,
                                style: changeTextColor(
                                    robotoBlack, lightGreyColor),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                reverse: true,
                                child: Obx(
                                  () => Column(
                                    children: chatController.chatHistoryList
                                        .map((chat) {
                                      final isCurrentUser =
                                          chat.senderId == loggedInUserId;
                                      final isCreatedDateShow = chat.createdDate
                                              .toString()
                                              .toLowerCase() ==
                                          previousCreateddate
                                              .toString()
                                              .toLowerCase();
                                      previousCreateddate =
                                          chat.createdDate.toString();
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12.h),
                                        child: Column(
                                          children: [
                                            isCreatedDateShow == false
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isCreatedDateShow ==
                                                                  false
                                                              ? backgroundColor
                                                              : lightSecondaryColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                5.r),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          child: Text(
                                                            "${chat.createdDate ?? ''}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            maxLines: 100000,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            Row(
                                              mainAxisAlignment: isCurrentUser
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    isCurrentUser
                                                        ? SizedBox()
                                                        : Text(
                                                            "${chat.senderName ?? ''}",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            maxLines: 100000,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: isCurrentUser
                                                            ? lightSecondaryColor
                                                            : secondaryColor,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15.r),
                                                          topRight:
                                                              Radius.circular(
                                                                  15.r),
                                                          bottomLeft:
                                                              isCurrentUser
                                                                  ? Radius
                                                                      .circular(
                                                                          15.r)
                                                                  : Radius.zero,
                                                          bottomRight:
                                                              isCurrentUser
                                                                  ? Radius.zero
                                                                  : Radius
                                                                      .circular(
                                                                          15.r),
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.w,
                                                                    right: 10.h,
                                                                    top: 10.h,
                                                                    bottom:
                                                                        18.h),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                chat.attachment !=
                                                                        null
                                                                    ? Container(
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxHeight:
                                                                              MediaQuery.of(context).size.width * 0.7,
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            openFile(chat.attachment ??
                                                                                "");
                                                                          },
                                                                          child:
                                                                              Image.network(
                                                                            "${chat.attachment ?? ""}",
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              return SizedBox();
                                                                            },
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                Text(
                                                                  "${chat.message ?? ''}                ",
                                                                  style:
                                                                      changeTextColor(
                                                                    robotoRegular,
                                                                    Colors
                                                                        .black,
                                                                  ),
                                                                  maxLines:
                                                                      100000,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 3.h,
                                                            right: 7.w,
                                                            child: Text(
                                                              DateConverter
                                                                  .convertTo12HourFormat(
                                                                      chat.createdAt ??
                                                                          ""),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        children: [
                          Obx(() => chatController
                                  .messagePicPath.value.isNotEmpty
                              ? Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8.h),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: FileImage(File(chatController
                                              .messagePicPath.value)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          chatController.messagePicPath.value =
                                              '';
                                          chatController.pickedFile.value =
                                              File('');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.close,
                                              color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox()),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: messageTextEditingController,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        showAlertDialog(context, 'chat');
                                      },
                                      child: Icon(Icons.attachment),
                                    ),
                                    hintText: writeYourMessage,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: borderColor),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: borderColor),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 15.w),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () {
                                  if (messageTextEditingController
                                          .text.isNotEmpty ||
                                      chatController
                                          .messagePicPath.value.isNotEmpty) {
                                    chatController.sendMessageApi(
                                      widget.userId ?? "",
                                      messageTextEditingController.text,
                                      widget.chatId ?? "",
                                      widget.fromPage,
                                    );
                                    messageTextEditingController.clear();
                                    chatController.messagePicPath.value = '';
                                    chatController.pickedFile.value = File('');
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(23.r),
                                  ),
                                  child: Icon(Icons.send,
                                      color: whiteColor, size: 20.h),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
        ),
      ),
    );
  }

  void openFile(String file) {
    String fileExtension = file.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      Get.to(NetworkImageScreen(file: file));
    } else {}
  }

  Future<void> showAlertDialog(
    BuildContext context,
    String from,
  ) async {
    return showDialog(
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
                            takeAttachment(ImageSource.gallery, from);
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
                            takeAttachment(ImageSource.camera, from);
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
  Future<void> takeAttachment(ImageSource source, String from) async {
    try {
      final pickedImage =
          await imagePicker.pickImage(source: source, imageQuality: 30);
      if (pickedImage == null) {
        return;
      }
      Get.back();
      chatController.isMessagePicUploading.value = true;
      chatController.pickedFile.value = File(pickedImage.path);
      chatController.messagePicPath.value = pickedImage.path.toString();
      chatController.isMessagePicUploading.value = false;
      if (from == 'group') {
        await chatController.updateGroupIconApi(widget.chatId);
      }
    } catch (e) {
      chatController.isMessagePicUploading.value = false;
      print('Error picking image: $e');
    } finally {
      chatController.isMessagePicUploading.value = false;
    }
  }
}
