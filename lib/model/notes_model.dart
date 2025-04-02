class NotesListModel {
  bool? status;
  String? message;
  List<NoteData>? data;

  NotesListModel({this.status, this.message, this.data});

  NotesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NoteData>[];
      json['data'].forEach((v) {
        data!.add(new NoteData.fromJson(v));
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

class NoteData {
  int? id;
  int? userId;
  String? title;
  String? description;
  int? tags;
  int? priority;
  int? isImportant;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;

  NoteData(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.tags,
        this.priority,
        this.isImportant,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  NoteData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    tags = json['tags'];
    priority = json['priority'];
    isImportant = json['is_important'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['tags'] = this.tags;
    data['priority'] = this.priority;
    data['is_important'] = this.isImportant;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
