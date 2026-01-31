import 'user_model.dart';

class UserSignupModel {
  bool? success;
  Message? message;

  UserSignupModel({this.success, this.message});

  UserSignupModel.fromJson(Map<String, dynamic> json) {
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
  UserData? user;
  String? accessToken;
  String? tokenType;

  Message({this.user, this.accessToken, this.tokenType});

  Message.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    return data;
  }
}

// class User {
//   int? id;
//   String? tenantId;
//   String? name;
//   String? email;
//   String? username;
//   String? phone;
//   String? dob;
//   String? currentCard;
//   String? country;
//   String? city;
//   String? address;
//   String? govId;
//   String? parentId;
//   int? status;
//   int? deleted;
//   String? createdAt;
//   String? updatedAt;
//   ImageUrl? imageUrl;

//   double remainingBalance; // ALWAYS double

//   User({
//     this.id,
//     this.tenantId,
//     this.name,
//     this.email,
//     this.username,
//     this.phone,
//     this.dob,
//     this.currentCard,
//     this.country,
//     this.city,
//     this.address,
//     this.govId,
//     this.parentId,
//     this.status,
//     this.deleted,
//     this.createdAt,
//     this.updatedAt,
//     this.imageUrl,
//     this.remainingBalance = 0.0,
//   });

//   User.fromJson(Map<String, dynamic> json)
//     : id = json['id'],
//       tenantId = json['tenant_id'],
//       name = json['name'],
//       email = json['email'],
//       username = json['username'],
//       phone = json['phone'],
//       dob = json['dob'],
//       currentCard = json['current_card'],
//       country = json['country'],
//       city = json['city'],
//       address = json['address'],
//       govId = json['gov_id'],
//       parentId = json['parent_id'],
//       status = json['status'],
//       deleted = json['deleted'],
//       createdAt = json['created_at'],
//       updatedAt = json['updated_at'],
//       imageUrl =
//           (json['image_url'] != null &&
//               json['image_url'] is Map &&
//               (json['image_url'] as Map).isNotEmpty)
//           ? ImageUrl.fromJson(json['image_url'])
//           : null,
//       remainingBalance = _safeDouble(json['remaining_balance']);

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['tenant_id'] = tenantId;
//     data['name'] = name;
//     data['email'] = email;
//     data['username'] = username;
//     data['phone'] = phone;
//     data['dob'] = dob;
//     data['current_card'] = currentCard;
//     data['country'] = country;
//     data['city'] = city;
//     data['address'] = address;
//     data['gov_id'] = govId;
//     data['parent_id'] = parentId;
//     data['status'] = status;
//     data['deleted'] = deleted;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (imageUrl != null) {
//       data['image_url'] = imageUrl!.toJson();
//     }
//     data['remaining_balance'] = remainingBalance;
//     return data;
//   }

//   /// SAFE Double parsing
//   static double _safeDouble(dynamic value) {
//     if (value == null) return 0.0;

//     if (value is int) return value.toDouble();
//     if (value is double) return value;

//     if (value is String) {
//       return double.tryParse(value.trim()) ?? 0.0;
//     }

//     return 0.0;
//   }
// }

class ImageUrl {
  List<String>? imageUrls;
  List<int>? id;

  ImageUrl({this.imageUrls, this.id});

  ImageUrl.fromJson(Map<String, dynamic> json) {
    imageUrls = json['imageUrls'].cast<String>();
    id = json['id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrls'] = imageUrls;
    data['id'] = id;
    return data;
  }
}
