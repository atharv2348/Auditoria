import 'package:auditoria/models/user_model.dart';

class EventModel {
  String? title;
  String? description;
  String? organizer;
  String? startTime;
  String? endTime;
  String? status;
  String? requestedBy;
  int? expectedAttendees;
  String? contactEmail;
  String? contactPhoneNumber;
  String? id;
  String? createdAt;
  String? updatedAt;
  String? actionTakenBy;
  String? actionTakenAt;
  String? instructions;
  UserModel? userInfo;

  EventModel(
      {this.title,
      this.description,
      this.organizer,
      this.startTime,
      this.endTime,
      this.status,
      this.requestedBy,
      this.expectedAttendees,
      this.contactEmail,
      this.contactPhoneNumber,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.actionTakenBy,
      this.actionTakenAt,
      this.instructions,
      this.userInfo});

  EventModel.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["organizer"] is String) {
      organizer = json["organizer"];
    }
    if (json["startTime"] is String) {
      startTime = json["startTime"];
    }
    if (json["endTime"] is String) {
      endTime = json["endTime"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["requestedBy"] is String) {
      requestedBy = json["requestedBy"];
    }
    if (json["expectedAttendees"] is int) {
      expectedAttendees = json["expectedAttendees"];
    }
    if (json["contactEmail"] is String) {
      contactEmail = json["contactEmail"];
    }
    if (json["contactPhoneNumber"] is String) {
      contactPhoneNumber = json["contactPhoneNumber"];
    }
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
    if (json["actionTakenBy"] is String) {
      actionTakenBy = json["actionTakenBy"];
    }
    if (json["actionTakenAt"] is String) {
      actionTakenAt = json["actionTakenAt"];
    }
    if (json["instructions"] is String) {
      instructions = json["instructions"];
    }
    if (json["userInfo"] is Map<String, dynamic>) {
      userInfo = UserModel.fromJson(json["userInfo"]);
    }
  }

  static List<EventModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(EventModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["description"] = description;
    data["organizer"] = organizer;
    data["startTime"] = startTime;
    data["endTime"] = endTime;
    data["status"] = status;
    data["requestedBy"] = requestedBy;
    data["expectedAttendees"] = expectedAttendees;
    data["contactEmail"] = contactEmail;
    data["contactPhoneNumber"] = contactPhoneNumber;
    data["_id"] = id;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    data["actionTakenBy"] = actionTakenBy;
    data["actionTakenAt"] = actionTakenAt;
    data["instructions"] = instructions;
    data["userInfo"] = userInfo?.toJson();
    return data;
  }
}
