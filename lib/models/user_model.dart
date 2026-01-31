import 'package:pos_v2/models/user_signup_model.dart';

class UserModel {
  bool? success;
  UserData? userData;

  UserModel({this.success, this.userData});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    userData = json['message'] != null
        ? UserData.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (userData != null) {
      data['message'] = userData!.toJson();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? tenantId;
  String? name;
  String? email;
  String? username;
  String? phone;
  String? dob;
  String? country;
  String? city;
  String? address;
  String? govId;
  dynamic parentId;
  int? status;
  int? deleted;
  String? createdAt;
  String? updatedAt;
  ImageUrl? imageUrl;

  double remainingBalance = 0.0;

  UserData({
    this.id,
    this.tenantId,
    this.name,
    this.email,
    this.username,
    this.phone,
    this.dob,
    this.country,
    this.city,
    this.address,
    this.govId,
    this.parentId,
    this.status,
    this.deleted,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.remainingBalance = 0.0,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenant_id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    dob = json['dob'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    govId = json['gov_id'];
    parentId = json['parent_id'];
    status = json['status'];
    deleted = json['deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    imageUrl =
        (json['image_url'] != null &&
            json['image_url'] is Map &&
            (json['image_url'] as Map).isNotEmpty)
        ? ImageUrl.fromJson(json['image_url'])
        : null;

    /// SAFE parse
    remainingBalance = _safeDouble(json['remaining_balance']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenant_id'] = tenantId;
    data['name'] = name;
    data['email'] = email;
    data['username'] = username;
    data['phone'] = phone;
    data['dob'] = dob;
    data['country'] = country;
    data['city'] = city;
    data['address'] = address;
    data['gov_id'] = govId;
    data['parent_id'] = parentId;
    data['status'] = status;
    data['deleted'] = deleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (imageUrl != null) {
      data['image_url'] = imageUrl!.toJson();
    }
    data['remaining_balance'] = remainingBalance;
    return data;
  }

  /// SAFE Double parser
  static double _safeDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is int) return value.toDouble();
    if (value is double) return value;

    if (value is String) {
      return double.tryParse(value.trim()) ?? 0.0;
    }

    return 0.0;
  }
}
