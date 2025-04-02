import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/helper/pusher_config.dart';
import 'package:task_management/model/chat_history_model.dart';
import 'package:task_management/model/chat_list_model.dart';
import 'package:task_management/model/responsible_person_list_model.dart';
import 'package:task_management/model/send_message_model.dart';
import 'package:task_management/service/chat_service.dart';

class ChatController extends GetxController {
  var chatModel = ChatListModel().obs;
  var isChatLoading = false.obs;

  var messagePicPath = "".obs;
  var isPicUpdated = false.obs;
  var isMessagePicUploading = false.obs;
  Rx<File> pickedFile = File('').obs;

  RxList<bool> isLongPressed = <bool>[].obs;
  StreamController<ChatHistoryModel> streamController = StreamController();
  RxInt totalUnsenMessage = 0.obs;
  RxList<ChatListData> chatList = <ChatListData>[].obs;

  Future<void> chatListApi() async {
    isChatLoading.value = true;
    final result = await ChatService().chatServiceApi();
    if (result != null) {
      chatModel.value = result;
      isLongPressed.clear();
      totalUnsenMessage.value = 0;
      chatList.clear();
      chatList.assignAll(chatModel.value.data!);
      isLongPressed.addAll(List<bool>.filled(chatList.length, false));
      for (var chat in chatList) {
        totalUnsenMessage.value += chat.unseenMessages!;
      }
    } else {}
    isChatLoading.value = false;
  }

  Future<void> updateGroupIconApi(String? chatId) async {
    isChatLoading.value = true;
    final result = await ChatService().updateGroupIconApi(chatId, pickedFile);
    if (result != null) {
      await chatListApi();
    } else {}
    isChatLoading.value = false;
  }

  var isChatHistoryLoading = false.obs;
  var chatHistoryModel = ChatHistoryModel().obs;
  RxList<ChatHistoryData> chatHistoryList = <ChatHistoryData>[].obs;

  RxBool hasMoreMessages = true.obs;
  RxInt pageCountValue = 1.obs;
  RxInt prePageCount = 1.obs;
  Future<void> chatHistoryListApi(
    String? chatId,
    int pageCount,
    String fromRoute,
  ) async {
    if (fromRoute == 'initstate') {
      isChatHistoryLoading.value = true;
    }

    final result = await ChatService().chatHistoryServiceApi(chatId, pageCount);

    if (result != null && result.data!.isNotEmpty) {
      if ((result.data?.length ?? 0) >= 20) {
        prePageCount.value = pageCount;
        chatHistoryList.assignAll(result.data!.reversed.toList());
      } else {
        pageCountValue.value = prePageCount.value;
        chatHistoryList.addAll(result.data!.reversed.toList());
      }
    } else {
      if (fromRoute == 'initstate') {
        hasMoreMessages.value = false;
      }
    }
    if (fromRoute == 'initstate') {
      isChatHistoryLoading.value = false;
    }
  }

  RxList<int> selectedChatId = <int>[].obs;
  Future<dynamic> deleteChat() async {
    isChatHistoryLoading.value = true;
    final result = await ChatService().deleteChat(selectedChatId);
    if (result != null) {
      selectedChatId.clear();
      await chatListApi();
      return result;
    } else {
      isChatHistoryLoading.value = false;
    }
  }

  RxString chatIdvalue = ''.obs;
  var sendMessageModel = SendMessageModel().obs;
  var isMessageSending = false.obs;

  void onPusherEvent(PusherEvent event) {
    final eventData = jsonDecode(event.data);
    final newMessage = ChatHistoryModel.fromJson(eventData);
    chatHistoryList.add(newMessage.data as ChatHistoryData);
    refresh();
  }

  Future<void> sendMessageApi(
      String? userId, String text, String? chatId, String? fromPage) async {
    isMessageSending.value = true;
    final result = await ChatService()
        .sendMessageApi(userId, text, chatId, fromPage, pickedFile);
    if (result != null) {
      sendMessageModel.value = SendMessageModel.fromJson(result);

      if (chatIdvalue.value.isEmpty) {
        chatIdvalue.value = sendMessageModel.value.chatId.toString();
        PusherConfig().initPusher(onPusherEvent,
            channelName: "chat", roomId: chatIdvalue.value);
        await chatHistoryListApi(
            chatIdvalue.value.toString(), pageCountValue.value, '');
      }
      pickedFile.value = File('');
    } else {
      isMessageSending.value = false;
    }
    isMessageSending.value = false;
  }

  RxList<int> selectedMemberId = <int>[].obs;
  final TaskController taskController = Get.put(TaskController());

  var isGroupUserAdding = false.obs;
  Future<void> addGroupUser(String? chatId, RxList<int> selectedChatId) async {
    isGroupUserAdding.value = true;
    final result = await ChatService().addGroupUser(chatId, selectedChatId);
    if (result != null) {
      selectedMemberId.clear();
      taskController.selectedLongPress.addAll(List<bool>.filled(
          taskController.responsiblePersonList.length, false));
      await memberListApi(chatId);
    } else {
      isGroupUserAdding.value = false;
    }
    isGroupUserAdding.value = false;
  }

  var isGroupCreating = false.obs;
  List<int> selectedPersonList = <int>[];
  Future<void> groupCreateApi(
      String text, RxList<ResponsiblePersonData> selectedList) async {
    isGroupCreating.value = true;
    selectedPersonList.clear();
    for (var data in selectedList) {
      selectedPersonList.add(data.id);
    }

    final result = await ChatService().groupCreate(text, selectedPersonList);
    if (result != null) {
      await chatListApi();
      Get.back();
      Get.back();
      Get.back();
    } else {
      isGroupCreating.value = false;
    }
    isGroupCreating.value = false;
  }

  var isMemberLoading = false.obs;
  var membersList = [].obs;
  Future<void> memberListApi(String? chatId) async {
    isMemberLoading.value = true;

    final result = await ChatService().memberListApi(chatId);
    if (result != null) {
      isMemberLoading.value = false;
      membersList.clear();
      membersList.assignAll(result['data']);
    } else {
      isMemberLoading.value = false;
    }
    isMemberLoading.value = false;
  }
}
