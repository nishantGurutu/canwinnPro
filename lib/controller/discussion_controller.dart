import 'dart:io';
import 'package:get/get.dart';
import 'package:task_management/service/discussion_service.dart';

class DiscussionController extends GetxController {
  RxList<bool> isReplyOpen = <bool>[].obs;
  RxList<bool> isReplyOpen2 = <bool>[].obs;
  var profilePicPath = "".obs;

  var profilePicPath2 = "".obs;
  var isFileUpdated = false.obs;
  var isFilePicUploading = false.obs;
  Rx<File> pickedFile2 = File('').obs;
  var isPicUpdated = false.obs;
  var isProfilePicUploading = false.obs;

  RxList<bool> isReplyView = <bool>[].obs;
  var isDiscussionAdding = false.obs;
  Future<void> addDiscussion(
      String comment, int discussionId, int? taskId) async {
    isDiscussionAdding.value = true;
    final result = await DiscussionService()
        .addDiscussion(comment, discussionId, taskId, pickedFile2);
    if (result != null) {
      pickedFile2.value = File('');
      await discussionList(taskId);
    } else {
      isDiscussionAdding.value = false;
    }
    isDiscussionAdding.value = false;
  }

  var isLikeDislikeAdding = false.obs;
  Future<void> addLikeDislike(commentId, int i, int? taskId) async {
    isLikeDislikeAdding.value = true;
    final result = await DiscussionService().likeUnlike(commentId, i);
    if (result != null) {
      await discussionList(taskId);
    } else {
      isLikeDislikeAdding.value = false;
    }
    isLikeDislikeAdding.value = false;
  }

  var isDislikeAdding = false.obs;
  Future<void> addDislike(commentId, int i, int? taskId) async {
    isDislikeAdding.value = true;
    final result = await DiscussionService().addDislike(commentId, i);
    if (result != null) {
      await discussionList(taskId);
    } else {
      isDislikeAdding.value = false;
    }
    isDislikeAdding.value = false;
  }

  var isDiscussionListLoading = false.obs;
  var discussionListData = [].obs;
  RxList<List<bool>> subCommentsList = [
    [false]
  ].obs;
  Future<void> discussionList(int? taskId) async {
    isDiscussionListLoading.value = true;
    final result = await DiscussionService().discussionList(taskId);
    if (result != null) {
      discussionListData.clear();
      isReplyOpen.clear();
      subCommentsList.clear();
      discussionListData.assignAll(result['data']);

      isReplyView.addAll(List<bool>.filled(discussionListData.length, false));

      for (int i = 0; i < discussionListData.length; i++) {
        subCommentsList.add(
            List.filled(discussionListData[i]['sub_comments'].length, false));
      }
    } else {
      isDiscussionListLoading.value = false;
    }
    isDiscussionListLoading.value = false;
  }
}
