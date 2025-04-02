class AttendenceListModel {
  bool? status;
  AttendenceData? data;

  AttendenceListModel({this.status, this.data});

  AttendenceListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? new AttendenceData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AttendenceData {
  int? presentDays;
  List<AttendenceListData>? list;
  int? approvalPendingCount;
  int? absentCount;
  int? leaveCount;
  int? halfdayCount;
  String? fine;
  String? overtime;

  AttendenceData(
      {this.presentDays,
      this.list,
      this.approvalPendingCount,
      this.absentCount,
      this.leaveCount,
      this.halfdayCount,
      this.fine,
      this.overtime});

  AttendenceData.fromJson(Map<String, dynamic> json) {
    presentDays = json['present_days'];
    if (json['list'] != null) {
      list = <AttendenceListData>[];
      json['list'].forEach((v) {
        list!.add(new AttendenceListData.fromJson(v));
      });
    }
    approvalPendingCount = json['approval_pending_count'];
    absentCount = json['absent_count'];
    leaveCount = json['leave_count'];
    halfdayCount = json['halfday_count'];
    fine = json['fine'];
    overtime = json['overtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['present_days'] = this.presentDays;
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['approval_pending_count'] = this.approvalPendingCount;
    data['absent_count'] = this.absentCount;
    data['leave_count'] = this.leaveCount;
    data['halfday_count'] = this.halfdayCount;
    data['fine'] = this.fine;
    data['overtime'] = this.overtime;
    return data;
  }
}

class AttendenceListData {
  int? id;
  int? userId;
  int? deptId;
  int? shiftId;
  String? checkIn;
  String? checkOut;
  String? checkInLatitude;
  String? checkInLongitude;
  String? checkInAddress;
  String? checkInImage;
  String? checkOutLatitude;
  String? checkOutLongitude;
  String? checkOutAddress;
  String? checkOutImage;
  dynamic approvedBy;
  int? status;
  String? checkindate;
  String? checkinday;
  String? checkintime;
  String? checkoutdate;
  String? checkoutday;
  String? checkouttime;
  String? approvalStatus;

  AttendenceListData(
      {this.id,
      this.userId,
      this.deptId,
      this.shiftId,
      this.checkIn,
      this.checkOut,
      this.checkInLatitude,
      this.checkInLongitude,
      this.checkInAddress,
      this.checkInImage,
      this.checkOutLatitude,
      this.checkOutLongitude,
      this.checkOutAddress,
      this.checkOutImage,
      this.approvedBy,
      this.status,
      this.checkindate,
      this.checkinday,
      this.checkintime,
      this.checkoutdate,
      this.checkoutday,
      this.checkouttime,
      this.approvalStatus});

  AttendenceListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deptId = json['dept_id'];
    shiftId = json['shift_id'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    checkInLatitude = json['check_in_latitude'];
    checkInLongitude = json['check_in_longitude'];
    checkInAddress = json['check_in_address'];
    checkInImage = json['check_in_image'];
    checkOutLatitude = json['check_out_latitude'];
    checkOutLongitude = json['check_out_longitude'];
    checkOutAddress = json['check_out_address'];
    checkOutImage = json['check_out_image'];
    approvedBy = json['approved_by'];
    status = json['status'];
    checkindate = json['checkindate'];
    checkinday = json['checkinday'];
    checkintime = json['checkintime'];
    checkoutdate = json['checkoutdate'];
    checkoutday = json['checkoutday'];
    checkouttime = json['checkouttime'];
    approvalStatus = json['approval_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['dept_id'] = this.deptId;
    data['shift_id'] = this.shiftId;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['check_in_latitude'] = this.checkInLatitude;
    data['check_in_longitude'] = this.checkInLongitude;
    data['check_in_address'] = this.checkInAddress;
    data['check_in_image'] = this.checkInImage;
    data['check_out_latitude'] = this.checkOutLatitude;
    data['check_out_longitude'] = this.checkOutLongitude;
    data['check_out_address'] = this.checkOutAddress;
    data['check_out_image'] = this.checkOutImage;
    data['approved_by'] = this.approvedBy;
    data['status'] = this.status;
    data['checkindate'] = this.checkindate;
    data['checkinday'] = this.checkinday;
    data['checkintime'] = this.checkintime;
    data['checkoutdate'] = this.checkoutdate;
    data['checkoutday'] = this.checkoutday;
    data['checkouttime'] = this.checkouttime;
    data['approval_status'] = this.approvalStatus;
    return data;
  }
}
