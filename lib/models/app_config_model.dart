class AppConfig {
  bool? success;
  Message? message;

  AppConfig({this.success, this.message});

  AppConfig.fromJson(Map<String, dynamic> json) {
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
  String? paymentBaseUrl;
  String? paymentApiKey;

  Message({this.paymentBaseUrl, this.paymentApiKey});

  Message.fromJson(Map<String, dynamic> json) {
    paymentBaseUrl = json['payment_base_url'];
    paymentApiKey = json['payment_api_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_base_url'] = paymentBaseUrl;
    data['payment_api_key'] = paymentApiKey;
    return data;
  }
}
