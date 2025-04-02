class TaskDetailsModel {
  bool? status;
  String? message;
  Data? data;

  TaskDetailsModel({this.status, this.message, this.data});

  TaskDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  dynamic departmentId;
  String? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  String? attachment;
  String? dueDate;
  String? dueTime;
  dynamic repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  dynamic projectName;
  dynamic departmentName;
  String? taskDate;
  String? taskTime;
  String? effectiveStatus;
  String? completedusers;
  String? inProgressUsers;
  String? pendingUsers;
  String? assignedUsers;
  String? assignedDepartments;
  String? assignedReviewers;
  String? creatorName;
  List<Subtask>? subtask;
  List<ProgressData>? progress;
  int? isLateCompleted;

  Data(
      {this.id,
      this.parentId,
      this.userId,
      this.title,
      this.description,
      this.departmentId,
      this.projectId,
      this.assignedTo,
      this.reviewer,
      this.startDate,
      this.attachment,
      this.dueDate,
      this.dueTime,
      this.repeatTask,
      this.priority,
      this.status,
      this.isImportant,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.projectName,
      this.departmentName,
      this.taskDate,
      this.taskTime,
      this.effectiveStatus,
      this.completedusers,
      this.inProgressUsers,
      this.pendingUsers,
      this.assignedUsers,
      this.assignedDepartments,
      this.assignedReviewers,
      this.creatorName,
      this.subtask,
      this.progress,
      this.isLateCompleted});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    departmentId = json['department_id'];
    projectId = json['project_id'];
    assignedTo = json['assigned_to'];
    reviewer = json['reviewer'];
    startDate = json['start_date'];
    attachment = json['attachment'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    repeatTask = json['repeat_task'];
    priority = json['priority'];
    status = json['status'];
    isImportant = json['is_important'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    projectName = json['project_name'];
    departmentName = json['department_name'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    effectiveStatus = json['effective_status'];
    completedusers = json['completedusers'];
    inProgressUsers = json['in_progress_users'];
    pendingUsers = json['pending_users'];
    assignedUsers = json['assigned_users'];
    assignedDepartments = json['assigned_departments'];
    assignedReviewers = json['assigned_reviewers'];
    creatorName = json['creator_name'];
    if (json['subtask'] != null) {
      subtask = <Subtask>[];
      json['subtask'].forEach((v) {
        subtask!.add(new Subtask.fromJson(v));
      });
    }
    if (json['progress'] != null) {
      progress = <ProgressData>[];
      json['progress'].forEach((v) {
        progress!.add(new ProgressData.fromJson(v));
      });
    }
    isLateCompleted = json['is_late_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['department_id'] = this.departmentId;
    data['project_id'] = this.projectId;
    data['assigned_to'] = this.assignedTo;
    data['reviewer'] = this.reviewer;
    data['start_date'] = this.startDate;
    data['attachment'] = this.attachment;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['repeat_task'] = this.repeatTask;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['is_important'] = this.isImportant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['project_name'] = this.projectName;
    data['department_name'] = this.departmentName;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['effective_status'] = this.effectiveStatus;
    data['completedusers'] = this.completedusers;
    data['in_progress_users'] = this.inProgressUsers;
    data['pending_users'] = this.pendingUsers;
    data['assigned_users'] = this.assignedUsers;
    data['assigned_departments'] = this.assignedDepartments;
    data['assigned_reviewers'] = this.assignedReviewers;
    data['creator_name'] = this.creatorName;
    if (this.subtask != null) {
      data['subtask'] = this.subtask!.map((v) => v.toJson()).toList();
    }
    if (this.progress != null) {
      data['progress'] = this.progress!.map((v) => v.toJson()).toList();
    }
    data['is_late_completed'] = this.isLateCompleted;
    return data;
  }
}

class Subtask {
  int? id;
  int? parentId;
  int? userId;
  String? title;
  String? description;
  dynamic departmentId;
  String? projectId;
  String? assignedTo;
  String? reviewer;
  String? startDate;
  String? attachment;
  String? dueDate;
  String? dueTime;
  dynamic repeatTask;
  int? priority;
  int? status;
  int? isImportant;
  String? createdAt;
  String? updatedAt;
  String? priorityName;
  dynamic projectName;
  dynamic departmentName;
  String? taskDate;
  String? taskTime;
  String? effectiveStatus;

  Subtask(
      {this.id,
      this.parentId,
      this.userId,
      this.title,
      this.description,
      this.departmentId,
      this.projectId,
      this.assignedTo,
      this.reviewer,
      this.startDate,
      this.attachment,
      this.dueDate,
      this.dueTime,
      this.repeatTask,
      this.priority,
      this.status,
      this.isImportant,
      this.createdAt,
      this.updatedAt,
      this.priorityName,
      this.projectName,
      this.departmentName,
      this.taskDate,
      this.taskTime,
      this.effectiveStatus});

  Subtask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    departmentId = json['department_id'];
    projectId = json['project_id'];
    assignedTo = json['assigned_to'];
    reviewer = json['reviewer'];
    startDate = json['start_date'];
    attachment = json['attachment'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    repeatTask = json['repeat_task'];
    priority = json['priority'];
    status = json['status'];
    isImportant = json['is_important'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priorityName = json['priority_name'];
    projectName = json['project_name'];
    departmentName = json['department_name'];
    taskDate = json['task_date'];
    taskTime = json['task_time'];
    effectiveStatus = json['effective_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['department_id'] = this.departmentId;
    data['project_id'] = this.projectId;
    data['assigned_to'] = this.assignedTo;
    data['reviewer'] = this.reviewer;
    data['start_date'] = this.startDate;
    data['attachment'] = this.attachment;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['repeat_task'] = this.repeatTask;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['is_important'] = this.isImportant;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['priority_name'] = this.priorityName;
    data['project_name'] = this.projectName;
    data['department_name'] = this.departmentName;
    data['task_date'] = this.taskDate;
    data['task_time'] = this.taskTime;
    data['effective_status'] = this.effectiveStatus;
    return data;
  }
}

class ProgressData {
  int? id;
  int? parentId;
  int? taskId;
  int? userId;
  int? status;
  String? remarks;
  dynamic attachment;
  String? createdAt;
  String? updatedAt;
  String? userName;
  String? createddate;
  String? reviewers;

  ProgressData(
      {this.id,
      this.parentId,
      this.taskId,
      this.userId,
      this.status,
      this.remarks,
      this.attachment,
      this.createdAt,
      this.updatedAt,
      this.userName,
      this.createddate,
      this.reviewers});

  ProgressData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    status = json['status'];
    remarks = json['remarks'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    createddate = json['createddate'];
    reviewers = json['reviewers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    data['createddate'] = this.createddate;
    data['reviewers'] = this.reviewers;
    return data;
  }
}
