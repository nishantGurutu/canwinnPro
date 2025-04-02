import 'package:get/get.dart';
import 'package:task_management/controller/task_controller.dart';
import 'package:task_management/model/all_project_list_model.dart';
import 'package:task_management/model/client_model.dart';
import 'package:task_management/model/project_category_model.dart';
import 'package:task_management/model/project_details_model.dart';
import 'package:task_management/model/project_list_model.dart';
import 'package:task_management/model/project_timing_model.dart';
import 'package:task_management/model/team_leader_model.dart';
import 'package:task_management/service/project_service.dart';

class ProjectController extends GetxController {
  var isProjectCalling = false.obs;
  var projectListModel = ProjectListModel().obs;
  AllProjectData? selectedAllProjectData;
  final TaskController taskController = Get.find();

  RxList<AllProjectData> projectDataList = <AllProjectData>[].obs;
  Future<void> projectListApi() async {
    isProjectCalling.value = true;
    final result = await ProjectService().projectListApi();
    if (result != null) {
      projectListModel.value = result;
      projectDataList.clear();
      projectDataList.assignAll(projectListModel.value.data!);
    } else {}
    isProjectCalling.value = false;
  }

  Rx<ProjectDetailsModel?> projectDetails = Rx<ProjectDetailsModel?>(null);
  var isProjectDetailsLoading = false.obs;
  Future<void> projectDetailsApi(int id) async {
    isProjectDetailsLoading.value = true;
    final result = await ProjectService().projectDetailsApi(id);
    if (result != null) {
      projectDetails.value = result;
    } else {}
    isProjectDetailsLoading.value = false;
  }

  var isProjectCategoryCalling = false.obs;
  var projectCategoryListModel = ProjectCategoryListModel().obs;
  ProjectCategoryData? selectedProjectCategory;
  RxList<ProjectCategoryData> projectCategoryDataList =
      <ProjectCategoryData>[].obs;
  Future<void> projectCategoryListApi() async {
    isProjectCategoryCalling.value = true;
    final result = await ProjectService().projectCategoryListApi();
    if (result != null) {
      projectCategoryListModel.value = result;
      projectCategoryDataList.clear();
      projectCategoryDataList.assignAll(projectCategoryListModel.value.data!);
    } else {}
    isProjectCategoryCalling.value = false;
  }

  var isAllProjectCalling = false.obs;
  var allProjectListModel = AllProjectListModel().obs;
  Rx<AllProjectListData?> selectedAllProjectListData =
      Rx<AllProjectListData?>(null);
  RxList<AllProjectListData> allProjectDataList = <AllProjectListData>[].obs;
  Future<void> allProjectListApi() async {
    isAllProjectCalling.value = true;
    final result = await ProjectService().allProjectListApi();
    if (result != null) {
      allProjectListModel.value = result;
      allProjectDataList.clear();
      allProjectDataList.assignAll(allProjectListModel.value.data!);
    } else {}
    isAllProjectCalling.value = false;
  }

  var isClientCalling = false.obs;
  var clientListModel = ClientModel().obs;
  ClientData? selectedClient;
  RxList<ClientData> clientDataList = <ClientData>[].obs;
  Future<void> clientListApi() async {
    isClientCalling.value = true;
    final result = await ProjectService().clientListApi();
    if (result != null) {
      clientListModel.value = result;
      clientDataList.clear();
      clientDataList.assignAll(clientListModel.value.data!);
    } else {}
    isClientCalling.value = false;
  }

  var isProjectTimingCalling = false.obs;
  var projectTimingModel = ProjectTimingModel().obs;
  ProjectTimingData? selectedProjectTiming;
  RxList<ProjectTimingData> projectTimingList = <ProjectTimingData>[].obs;
  Future<void> projectTimingApi() async {
    isProjectTimingCalling.value = true;
    final result = await ProjectService().projecttimingListApi();
    if (result != null) {
      projectTimingModel.value = result;
      projectTimingList.clear();
      projectTimingList.assignAll(projectTimingModel.value.data!);
    } else {}
    isProjectTimingCalling.value = false;
  }

  var isTeamleadCalling = false.obs;
  var teamLeaderData = TeamLeaderModel().obs;
  TeamLeaderData? selectedTeamLeader;
  RxList<TeamLeaderData> teamLeaderDataList = <TeamLeaderData>[].obs;
  Future<void> teamLeaderApi() async {
    isTeamleadCalling.value = true;
    final result = await ProjectService().teamLeaderListApi();
    if (result != null) {
      teamLeaderData.value = result;
      teamLeaderDataList.clear();
      teamLeaderDataList.assignAll(teamLeaderData.value.data!);
    } else {}
    isTeamleadCalling.value = false;
  }

  var isProjectAdding = false.obs;
  Future<void> addProjectApi({
    required String projectName,
    int? projectType,
    int? client,
    int? category,
    int? projectTiming,
    required String price,
    required String amount,
    required String total,
    int? selectPerson,
    int? selectedLeader,
    required String startDate,
    required String dueDate,
    int? selectedPriority,
    int? selectedStatus,
    required String description,
    required RxList<String> departmentId,
    required String dueTime,
  }) async {
    isProjectAdding.value = true;
    final result = await ProjectService().addProjectApi(
        projectName,
        projectType,
        client,
        category,
        projectTiming,
        price,
        amount,
        total,
        selectPerson,
        selectedLeader,
        startDate,
        dueDate,
        selectedPriority,
        selectedStatus,
        description,
        departmentId,
        dueTime);
    Get.back();
    await allProjectListApi();
    isProjectAdding.value = false;
  }

  var isProjectEditing = false.obs;
  Future<void> editProjectApi(
      {required String projectName,
      int? projectType,
      int? client,
      int? category,
      int? projectTiming,
      required String price,
      required String amount,
      required String total,
      int? selectPerson,
      int? selectedLeader,
      required String startDate,
      required String dueDate,
      int? selectedPriority,
      int? selectedStatus,
      required String description}) async {
    isProjectEditing.value = true;
    final result = await ProjectService().editProjectApi(
        projectName,
        projectType,
        client,
        category,
        projectTiming,
        price,
        amount,
        total,
        selectPerson,
        selectedLeader,
        startDate,
        dueDate,
        selectedPriority,
        selectedStatus,
        description);
    Get.back();
    await allProjectListApi();
    isProjectEditing.value = false;
  }

  var isProjectDeleting = false.obs;
  Future<void> deleteProject(int? id) async {
    isProjectDeleting.value = true;
    final result = await ProjectService().deleteProject(id);
    if (result) {
      await allProjectListApi();
    } else {}
    isProjectDeleting.value = false;
  }
}
