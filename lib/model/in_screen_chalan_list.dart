class InScreenChalanListModel {
  bool? status;
  String? message;
  List<InScreenData>? data;

  InScreenChalanListModel({this.status, this.message, this.data});

  InScreenChalanListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InScreenData>[];
      json['data'].forEach((v) {
        data!.add(new InScreenData.fromJson(v));
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

class InScreenData {
  int? id;
  int? userId;
  String? challanNumber;
  String? date;
  String? name;
  String? address;
  String? entryToDepartment;
  String? uploadImage;
  String? purpose;
  String? contact;
  int? status;
  String? remarks;
  String? createdAt;
  String? updatedAt;

  InScreenData(
      {this.id,
      this.userId,
      this.challanNumber,
      this.date,
      this.name,
      this.address,
      this.entryToDepartment,
      this.uploadImage,
      this.purpose,
      this.contact,
      this.status,
      this.remarks,
      this.createdAt,
      this.updatedAt});

  InScreenData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    challanNumber = json['challan_number'];
    date = json['date'];
    name = json['name'];
    address = json['address'];
    entryToDepartment = json['entry_to_department'];
    uploadImage = json['upload_image'];
    purpose = json['purpose'];
    contact = json['contact'];
    status = json['status'];
    remarks = json['remarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['challan_number'] = this.challanNumber;
    data['date'] = this.date;
    data['name'] = this.name;
    data['address'] = this.address;
    data['entry_to_department'] = this.entryToDepartment;
    data['upload_image'] = this.uploadImage;
    data['purpose'] = this.purpose;
    data['contact'] = this.contact;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
