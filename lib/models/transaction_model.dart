class TransactionMode {
  bool? success;
  Message? message;

  TransactionMode({this.success, this.message});

  TransactionMode.fromJson(Map<String, dynamic> json) {
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
  List<Transactions>? transactions;
  Pagination? pagination;

  Message({this.transactions, this.pagination});

  Message.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Transactions {
  int? id;
  String? transactionId;
  String? transactionType;
  int? amount;
  String? createdAt;

  Transactions({
    this.id,
    this.transactionId,
    this.transactionType,
    this.amount,
    this.createdAt,
  });

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['transaction_type'] = transactionType;
    data['amount'] = amount;
    data['created_at'] = createdAt;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  int? from;
  int? to;

  Pagination({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
    this.from,
    this.to,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
