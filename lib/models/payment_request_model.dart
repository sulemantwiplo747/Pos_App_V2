class PaymentRequestModel {
  String? amount;
  Billing? billing;
  String? checkoutPageUrl;
  String? checkoutUrl;
  String? currencyCode;
  String? customerBirthdate;
  String? customerEmail;
  String? customerFirstName;
  String? customerId;
  String? customerLastName;
  String? customerPhone;
  String? customerPhone2;
  String? dueDatetime;
  List<String>? emailRecipients;
  String? expirationTime;
  Extra? extra;
  int? initiatorId;
  String? language;
  Notifications? notifications;
  String? operation;
  String? orderNo;
  List<PaymentMethods>? paymentMethods;
  String? paymentType;
  List<String>? pgCodes;
  String? productType;
  String? redirectUrl;
  String? sessionId;
  String? state;
  String? type;
  String? vendorName;
  String? webhookUrl;

  PaymentRequestModel({
    this.amount,
    this.billing,
    this.checkoutPageUrl,
    this.checkoutUrl,
    this.currencyCode,
    this.customerBirthdate,
    this.customerEmail,
    this.customerFirstName,
    this.customerId,
    this.customerLastName,
    this.customerPhone,
    this.customerPhone2,
    this.dueDatetime,
    this.emailRecipients,
    this.expirationTime,
    this.extra,
    this.initiatorId,
    this.language,
    this.notifications,
    this.operation,
    this.orderNo,
    this.paymentMethods,
    this.paymentType,
    this.pgCodes,
    this.productType,
    this.redirectUrl,
    this.sessionId,
    this.state,
    this.type,
    this.vendorName,
    this.webhookUrl,
  });

  PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    billing = json['billing'] != null
        ? Billing.fromJson(json['billing'])
        : null;
    checkoutPageUrl = json['checkout_page_url'];
    checkoutUrl = json['checkout_url'];
    currencyCode = json['currency_code'];
    customerBirthdate = json['customer_birthdate'];
    customerEmail = json['customer_email'];
    customerFirstName = json['customer_first_name'];
    customerId = json['customer_id'];
    customerLastName = json['customer_last_name'];
    customerPhone = json['customer_phone'];
    customerPhone2 = json['customer_phone_2'];
    dueDatetime = json['due_datetime'];
    emailRecipients = json['email_recipients'].cast<String>();
    expirationTime = json['expiration_time'];
    extra = json['extra'] != null ? Extra.fromJson(json['extra']) : null;
    initiatorId = json['initiator_id'];
    language = json['language'];
    notifications = json['notifications'] != null
        ? Notifications.fromJson(json['notifications'])
        : null;
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
    productType = json['product_type'];
    redirectUrl = json['redirect_url'];
    sessionId = json['session_id'];
    state = json['state'];
    type = json['type'];
    vendorName = json['vendor_name'];
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
    data['customer_birthdate'] = customerBirthdate;
    data['customer_email'] = customerEmail;
    data['customer_first_name'] = customerFirstName;
    data['customer_id'] = customerId;
    data['customer_last_name'] = customerLastName;
    data['customer_phone'] = customerPhone;
    data['customer_phone_2'] = customerPhone2;
    data['due_datetime'] = dueDatetime;
    data['email_recipients'] = emailRecipients;
    data['expiration_time'] = expirationTime;
    if (extra != null) {
      data['extra'] = extra!.toJson();
    }
    data['initiator_id'] = initiatorId;
    data['language'] = language;
    if (notifications != null) {
      data['notifications'] = notifications!.toJson();
    }
    data['operation'] = operation;
    data['order_no'] = orderNo;
    if (paymentMethods != null) {
      data['payment_methods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = paymentType;
    data['pg_codes'] = pgCodes;
    data['product_type'] = productType;
    data['redirect_url'] = redirectUrl;
    data['session_id'] = sessionId;
    data['state'] = state;
    data['type'] = type;
    data['vendor_name'] = vendorName;
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

class Extra {
  String? paymentCategoryName;
  String? paymentCategoryAmount;
  String? month;
  String? remarks;
  String? invoiceNo;
  String? bookingReference;

  Extra({
    this.paymentCategoryName,
    this.paymentCategoryAmount,
    this.month,
    this.remarks,
    this.invoiceNo,
    this.bookingReference,
  });

  Extra.fromJson(Map<String, dynamic> json) {
    paymentCategoryName = json['payment_category_name'];
    paymentCategoryAmount = json['payment_category_amount'];
    month = json['month'];
    remarks = json['remarks'];
    invoiceNo = json['invoice_no'];
    bookingReference = json['booking_reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_category_name'] = paymentCategoryName;
    data['payment_category_amount'] = paymentCategoryAmount;
    data['month'] = month;
    data['remarks'] = remarks;
    data['invoice_no'] = invoiceNo;
    data['booking_reference'] = bookingReference;
    return data;
  }
}

class Notifications {
  List<String>? email;
  List<String>? sms;
  List<String>? whatsapp;

  Notifications({this.email, this.sms, this.whatsapp});

  Notifications.fromJson(Map<String, dynamic> json) {
    email = json['email'].cast<String>();
    sms = json['sms'].cast<String>();
    whatsapp = json['whatsapp'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['sms'] = sms;
    data['whatsapp'] = whatsapp;
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
