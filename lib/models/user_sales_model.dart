class UserSalesModel {
  bool? success;
  Message? message;

  UserSalesModel({this.success, this.message});

  UserSalesModel.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;
  Pagination? pagination;

  Message({this.data, this.pagination});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? referenceCode;
  String? date;
  String? total;
  String? paid;
  String? due;
  String? status;
  List<Items>? items;

  Data({
    this.id,
    this.referenceCode,
    this.date,
    this.total,
    this.paid,
    this.due,
    this.status,
    this.items,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referenceCode = json['reference_code'];
    date = json['date'];
    total = json['total'];
    paid = json['paid'];
    due = json['due'];
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference_code'] = referenceCode;
    data['date'] = date;
    data['total'] = total;
    data['paid'] = paid;
    data['due'] = due;
    data['status'] = status;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  int? quantity;
  String? unit;
  String? price;
  String? total;
  String? thumbnail;
  List<String>? images;

  Items({
    this.name,
    this.quantity,
    this.unit,
    this.price,
    this.total,
    this.thumbnail,
    this.images,
  });

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    unit = json['unit'];
    price = json['price'];
    total = json['total'];
    thumbnail = json['thumbnail'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['price'] = price;
    data['total'] = total;
    data['thumbnail'] = thumbnail;
    data['images'] = images;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    return data;
  }
}
