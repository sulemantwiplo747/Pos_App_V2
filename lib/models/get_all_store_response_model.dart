class GetAllStoreResponseModel {
  bool? success;
  Message? message;

  GetAllStoreResponseModel({this.success, this.message});

  GetAllStoreResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'] != null
        ? Message.fromJson(json['message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  List<Stores>? stores;

  Message({this.stores});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['stores'] != null) {
      stores = <Stores>[];
      json['stores'].forEach((v) {
        stores!.add(Stores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (stores != null) {
      data['stores'] = stores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stores {
  int? id;
  String? name;
  String? tenantId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  Stores({
    this.id,
    this.name,
    this.tenantId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  Stores.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tenantId = json['tenant_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tenant_id'] = tenantId;
    data['user_id'] = userId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  Null region;
  String? emailVerifiedAt;
  String? tenantId;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? language;
  String? imageUrl;
  List<Null>? media;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.region,
    this.emailVerifiedAt,
    this.tenantId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.language,
    this.imageUrl,
    this.media,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    region = json['region'];
    emailVerifiedAt = json['email_verified_at'];
    tenantId = json['tenant_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    language = json['language'];
    imageUrl = json['image_url'];
    // if (json['media'] != null) {
    //   media = <Null>[];
    //   json['media'].forEach((v) {
    //     media!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['region'] = region;
    data['email_verified_at'] = emailVerifiedAt;
    data['tenant_id'] = tenantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['language'] = language;
    data['image_url'] = imageUrl;
    // if (this.media != null) {
    //   data['media'] = this.media!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
