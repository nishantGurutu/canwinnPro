class AllProjectListModel {
  bool? status;
  String? message;
  List<AllProjectListData>? data;

  AllProjectListModel({this.status, this.message, this.data});

  AllProjectListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <AllProjectListData>[];
      json['data'].forEach((v) {
        data!.add(new AllProjectListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllProjectListData {
  int? id;
  int? userId;
  String? departmentId;
  String? name;
  int? type;
  int? client;
  int? category;
  String? projectTiming;
  String? price;
  String? amount;
  String? total;
  String? responsiblePerson;
  int? teamLeader;
  String? startDate;
  String? dueDate;
  int? priority;
  int? status;
  String? description;
  dynamic pipelineStage;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? priorityName;
  String? statusName;
  String? responsiblePersonName;
  String? teamLeaderName;
  String? projectTypeName;
  String? timingName;
  String? clientName;

  AllProjectListData(
      {this.id,
      this.userId,
      this.departmentId,
      this.name,
      this.type,
      this.client,
      this.category,
      this.projectTiming,
      this.price,
      this.amount,
      this.total,
      this.responsiblePerson,
      this.teamLeader,
      this.startDate,
      this.dueDate,
      this.priority,
      this.status,
      this.description,
      this.pipelineStage,
      this.createdAt,
      this.updatedAt,
      this.categoryName,
      this.priorityName,
      this.statusName,
      this.responsiblePersonName,
      this.teamLeaderName,
      this.projectTypeName,
      this.timingName,
      this.clientName});

  AllProjectListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    departmentId = json['department_id'];
    name = json['name'];
    type = json['type'];
    client = json['client'];
    category = json['category'];
    projectTiming = json['project_timing'];
    price = json['price'];
    amount = json['amount'];
    total = json['total'];
    responsiblePerson = json['responsible_person'];
    teamLeader = json['team_leader'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    priority = json['priority'];
    status = json['status'];
    description = json['description'];
    pipelineStage = json['pipeline_stage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    priorityName = json['priority_name'];
    statusName = json['status_name'];
    responsiblePersonName = json['responsible_person_name'];
    teamLeaderName = json['team_leader_name'];
    projectTypeName = json['project_type_name'];
    timingName = json['timing_name'];
    clientName = json['client_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['department_id'] = this.departmentId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['client'] = this.client;
    data['category'] = this.category;
    data['project_timing'] = this.projectTiming;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['total'] = this.total;
    data['responsible_person'] = this.responsiblePerson;
    data['team_leader'] = this.teamLeader;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['description'] = this.description;
    data['pipeline_stage'] = this.pipelineStage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    data['priority_name'] = this.priorityName;
    data['status_name'] = this.statusName;
    data['responsible_person_name'] = this.responsiblePersonName;
    data['team_leader_name'] = this.teamLeaderName;
    data['project_type_name'] = this.projectTypeName;
    data['timing_name'] = this.timingName;
    data['client_name'] = this.clientName;
    return data;
  }
}
