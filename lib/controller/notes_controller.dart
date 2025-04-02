import 'package:get/get.dart';
import 'package:task_management/controller/home_controller.dart';
import 'package:task_management/service/noter_service.dart';
import '../model/notes_model.dart';

class NotesController {
  var isNotesLoading = false.obs;
  var notesListModel = NotesListModel().obs;
  RxList<NoteData> notesList = <NoteData>[].obs;
  Future<void> notesListApi() async {
    isNotesLoading.value = true;
    final result = await NotesService().notesListApi();
    if (result != null) {
      notesListModel.value = result;
      notesList.clear();
      notesList.assignAll(notesListModel.value.data!);
    } else {}
    isNotesLoading.value = false;
  }

  var isNotesAdding = false.obs;
  Future<void> addNote(
      String title, String description, int tag, int? priorityId) async {
    isNotesAdding.value = true;
    final result =
        await NotesService().addNotesApi(title, description, tag, priorityId);
    if (result) {
      await notesListApi();
      Get.back();
    } else {}
    isNotesAdding.value = false;
  }

  final HomeController homeController = Get.put(HomeController());
  var isNotesPinnAdding = false.obs;
  Future<void> pinNote(int? id) async {
    isNotesPinnAdding.value = true;
    final result = await NotesService().pinNotesApi(id);
    if (result) {
      await notesListApi();
      await homeController.homeDataApi('');
      Get.back();
    } else {}
    isNotesPinnAdding.value = false;
  }

  var isNotesEditing = false.obs;
  Future<void> editNote(String title, String description, int tag,
      int? priorityId, int? id) async {
    isNotesEditing.value = true;
    final result = await NotesService()
        .editNotesApi(title, description, tag, priorityId, id);
    if (result) {
      await notesListApi();
      Get.back();
    } else {}
    isNotesEditing.value = false;
  }

  var isNotesDeleting = false.obs;
  Future<void> deleteNote(int? id) async {
    isNotesDeleting.value = true;
    final result = await NotesService().deleteNotes(id);
    if (result != null) {
      await notesListApi();
    } else {}
    isNotesDeleting.value = false;
  }
}
