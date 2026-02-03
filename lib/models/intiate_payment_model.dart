class InitiatePaymentModel {
  bool? success;
  Message? message;

  InitiatePaymentModel({this.success, this.message});

  InitiatePaymentModel.fromJson(Map<String, dynamic> json) {
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
  String? orderNo;
  double? amount;
  String? sessionId;
  String? expiresIn;

  Message({this.orderNo, this.amount, this.sessionId, this.expiresIn});

  Message.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    amount = (json['amount'] as num?)?.toDouble();

    sessionId = json['session_id'];
    expiresIn = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_no'] = orderNo;
    data['amount'] = amount;
    data['session_id'] = sessionId;
    data['expires_in'] = expiresIn;
    return data;
  }
}
