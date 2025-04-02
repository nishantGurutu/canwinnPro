class DailyTaskListModel {
  bool? status;
  String? message;
  List<Tasks>? tasks;

  DailyTaskListModel({this.status, this.message, this.tasks});

  DailyTaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['tasks'] != null) {
      tasks = <Tasks>[];
      json['tasks'].forEach((v) {
        tasks!.add(new Tasks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tasks {
  int? id;
  int? userId;
  String? taskName;
  int? status;
  String? createdAt;
  String? updatedAt;

  Tasks(
      {this.id,
      this.userId,
      this.taskName,
      this.status,
      this.createdAt,
      this.updatedAt});

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    taskName = json['task_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['task_name'] = this.taskName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
