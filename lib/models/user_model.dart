class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? prnNumber;
  bool? subscribedToEmails;
  String? role;
  bool? hasBookingAccess;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.prnNumber,
      this.subscribedToEmails,
      this.role,
      this.hasBookingAccess,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    if (json["_id"] is String) {
      id = json["_id"];
    }
    if (json["firstName"] is String) {
      firstName = json["firstName"];
    }
    if (json["lastName"] is String) {
      lastName = json["lastName"];
    }
    if (json["email"] is String) {
      email = json["email"];
    }
    if (json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if (json["prnNumber"] is String) {
      prnNumber = json["prnNumber"];
    }
    if (json["subscribedToEmails"] is bool) {
      subscribedToEmails = json["subscribedToEmails"];
    }
    if (json["role"] is String) {
      role = json["role"];
    }
    if (json["hasBookingAccess"] is bool) {
      hasBookingAccess = json["hasBookingAccess"];
    }
    if (json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
    if (json["updatedAt"] is String) {
      updatedAt = json["updatedAt"];
    }
  }

  static List<UserModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["email"] = email;
    data["phoneNumber"] = phoneNumber;
    data["prnNumber"] = prnNumber;
    data["subscribedToEmails"] = subscribedToEmails;
    data["role"] = role;
    data["hasBookingAccess"] = hasBookingAccess;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}
