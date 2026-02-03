class getOrderDetails {
  bool? success;
  Message? message;

  getOrderDetails({this.success, this.message});

  getOrderDetails.fromJson(Map<String, dynamic> json) {
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
  int? id;
  int? userId;
  String? orderNo;
  String? amount;
  String? currency;
  String? email;
  String? status;
  String? ottuSession;
  OttuResponse? ottuResponse;
  String? paidAt;
  String? createdAt;
  String? updatedAt;

  Message({
    this.id,
    this.userId,
    this.orderNo,
    this.amount,
    this.currency,
    this.email,
    this.status,
    this.ottuSession,
    this.ottuResponse,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderNo = json['order_no'];
    amount = json['amount'];
    currency = json['currency'];
    email = json['email'];
    status = json['status'];
    ottuSession = json['ottu_session'];
    ottuResponse = json['ottu_response'] != null
        ? OttuResponse.fromJson(json['ottu_response'])
        : null;
    paidAt = json['paid_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_no'] = orderNo;
    data['amount'] = amount;
    data['currency'] = currency;
    data['email'] = email;
    data['status'] = status;
    data['ottu_session'] = ottuSession;
    if (ottuResponse != null) {
      data['ottu_response'] = ottuResponse!.toJson();
    }
    data['paid_at'] = paidAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OttuResponse {
  String? amount;
  Billing? billing;
  String? checkoutPageUrl;
  String? checkoutUrl;
  String? currencyCode;
  String? customerEmail;
  String? customerFirstName;
  String? customerPhone;
  String? dueDatetime;
  String? expirationTime;
  String? language;
  String? operation;
  String? orderNo;
  List<PaymentMethods>? paymentMethods;
  String? paymentType;
  List<String>? pgCodes;
  String? redirectUrl;
  String? sessionId;
  String? state;
  String? type;
  String? webhookUrl;

  OttuResponse({
    this.amount,
    this.billing,
    this.checkoutPageUrl,
    this.checkoutUrl,
    this.currencyCode,
    this.customerEmail,
    this.customerFirstName,
    this.customerPhone,
    this.dueDatetime,
    this.expirationTime,
    this.language,
    this.operation,
    this.orderNo,
    this.paymentMethods,
    this.paymentType,
    this.pgCodes,
    this.redirectUrl,
    this.sessionId,
    this.state,
    this.type,
    this.webhookUrl,
  });

  OttuResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    billing = json['billing'] != null
        ? Billing.fromJson(json['billing'])
        : null;
    checkoutPageUrl = json['checkout_page_url'];
    checkoutUrl = json['checkout_url'];
    currencyCode = json['currency_code'];
    customerEmail = json['customer_email'];
    customerFirstName = json['customer_first_name'];
    customerPhone = json['customer_phone'];
    dueDatetime = json['due_datetime'];
    expirationTime = json['expiration_time'];
    language = json['language'];
    operation = json['operation'];
    orderNo = json['order_no'];
    if (json['payment_methods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['payment_methods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
    paymentType = json['payment_type'];
    pgCodes = json['pg_codes'].cast<String>();
    redirectUrl = json['redirect_url'];
    sessionId = json['session_id'];
    state = json['state'];
    type = json['type'];
    webhookUrl = json['webhook_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    if (billing != null) {
      data['billing'] = billing!.toJson();
    }
    data['checkout_page_url'] = checkoutPageUrl;
    data['checkout_url'] = checkoutUrl;
    data['currency_code'] = currencyCode;
    data['customer_email'] = customerEmail;
    data['customer_first_name'] = customerFirstName;
    data['customer_phone'] = customerPhone;
    data['due_datetime'] = dueDatetime;
    data['expiration_time'] = expirationTime;
    data['language'] = language;
    data['operation'] = operation;
    data['order_no'] = orderNo;
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = paymentType;
    data['pg_codes'] = pgCodes;
    data['redirect_url'] = redirectUrl;
    data['session_id'] = sessionId;
    data['state'] = state;
    data['type'] = type;
    data['webhook_url'] = webhookUrl;
    return data;
  }
}

class Billing {
  Amount? amount;
  Amount? subTotal;
  Amount? fee;

  Billing({this.amount, this.subTotal, this.fee});

  Billing.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    subTotal = json['sub_total'] != null
        ? Amount.fromJson(json['sub_total'])
        : null;
    fee = json['fee'] != null ? Amount.fromJson(json['fee']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (amount != null) {
      data['amount'] = amount!.toJson();
    }
    if (subTotal != null) {
      data['sub_total'] = subTotal!.toJson();
    }
    if (fee != null) {
      data['fee'] = fee!.toJson();
    }
    return data;
  }
}

class Amount {
  String? display;
  String? value;
  String? currencyCode;
  String? label;

  Amount({this.display, this.value, this.currencyCode, this.label});

  Amount.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    value = json['value'];
    currencyCode = json['currency_code'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    data['value'] = value;
    data['currency_code'] = currencyCode;
    data['label'] = label;
    return data;
  }
}

class PaymentMethods {
  String? code;
  String? name;
  String? pg;
  String? type;
  String? amount;
  String? currencyCode;
  String? fee;
  String? feeDescription;
  String? icon;
  Icons? icons;
  String? flow;
  String? redirectUrl;

  PaymentMethods({
    this.code,
    this.name,
    this.pg,
    this.type,
    this.amount,
    this.currencyCode,
    this.fee,
    this.feeDescription,
    this.icon,
    this.icons,
    this.flow,
    this.redirectUrl,
  });

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    pg = json['pg'];
    type = json['type'];
    amount = json['amount'];
    currencyCode = json['currency_code'];
    fee = json['fee'];
    feeDescription = json['fee_description'];
    icon = json['icon'];
    icons = json['icons'] != null ? Icons.fromJson(json['icons']) : null;
    flow = json['flow'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['pg'] = pg;
    data['type'] = type;
    data['amount'] = amount;
    data['currency_code'] = currencyCode;
    data['fee'] = fee;
    data['fee_description'] = feeDescription;
    data['icon'] = icon;
    if (icons != null) {
      data['icons'] = icons!.toJson();
    }
    data['flow'] = flow;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}

class Icons {
  String? svg;
  String? webp;

  Icons({this.svg, this.webp});

  Icons.fromJson(Map<String, dynamic> json) {
    svg = json['svg'];
    webp = json['webp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['svg'] = svg;
    data['webp'] = webp;
    return data;
  }
}
