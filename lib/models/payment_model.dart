class Order {
  String id;
  Links links;
  String type;
  Map<String, dynamic> merchantDefinedData;
  String action;
  Amount amount;
  String language;
  Map<String, dynamic> merchantAttributes;
  String reference;
  String outletId;
  DateTime createDateTime;
  PaymentMethods paymentMethods;
  String referrer;
  Map<String, dynamic> formattedOrderSummary;
  String formattedOriginalAmount;
  String formattedAmount;
  Embedded embedded;

  Order({
    required this.id,
    required this.links,
    required this.type,
    required this.merchantDefinedData,
    required this.action,
    required this.amount,
    required this.language,
    required this.merchantAttributes,
    required this.reference,
    required this.outletId,
    required this.createDateTime,
    required this.paymentMethods,
    required this.referrer,
    required this.formattedOrderSummary,
    required this.formattedOriginalAmount,
    required this.formattedAmount,
    required this.embedded,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      links: Links.fromJson(json['_links']),
      type: json['type'],
      merchantDefinedData: json['merchantDefinedData'],
      action: json['action'],
      amount: Amount.fromJson(json['amount']),
      language: json['language'],
      merchantAttributes: json['merchantAttributes'],
      reference: json['reference'],
      outletId: json['outletId'],
      createDateTime: DateTime.parse(json['createDateTime']),
      paymentMethods: PaymentMethods.fromJson(json['paymentMethods']),
      referrer: json['referrer'],
      formattedOrderSummary: json['formattedOrderSummary'],
      formattedOriginalAmount: json['formattedOriginalAmount'],
      formattedAmount: json['formattedAmount'],
      embedded: Embedded.fromJson(json['_embedded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      '_links': links.toJson(),
      'type': type,
      'merchantDefinedData': merchantDefinedData,
      'action': action,
      'amount': amount.toJson(),
      'language': language,
      'merchantAttributes': merchantAttributes,
      'reference': reference,
      'outletId': outletId,
      'createDateTime': createDateTime.toIso8601String(),
      'paymentMethods': paymentMethods.toJson(),
      'referrer': referrer,
      'formattedOrderSummary': formattedOrderSummary,
      'formattedOriginalAmount': formattedOriginalAmount,
      'formattedAmount': formattedAmount,
      '_embedded': embedded.toJson(),
    };
  }
}

class Links {
  Link payment;

  Links({
    required this.payment,
  });

  factory Links.fromJson(Map json) {
    return Links(
      payment: Link.fromJson(json['payment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment': payment.toJson(),
    };
  }
}

class Link {
  String href;

  Link({required this.href});

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(href: json['href']);
  }

  Map<String, dynamic> toJson() {
    return {'href': href};
  }
}

class Amount {
  String currencyCode;
  int value;

  Amount({required this.currencyCode, required this.value});

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      currencyCode: json['currencyCode'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencyCode': currencyCode,
      'value': value,
    };
  }
}

class PaymentMethods {
  List<String> card;
  List<String> wallet;

  PaymentMethods({required this.card, required this.wallet});

  factory PaymentMethods.fromJson(Map<String, dynamic> json) {
    return PaymentMethods(
      card: List<String>.from(json['card']),
      wallet: List<String>.from(json['wallet']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card': card,
      'wallet': wallet,
    };
  }
}

class Embedded {
  List<Payment> payment;

  Embedded({required this.payment});

  factory Embedded.fromJson(Map<String, dynamic> json) {
    return Embedded(
      payment:
          (json['payment'] as List).map((i) => Payment.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment': payment.map((i) => i.toJson()).toList(),
    };
  }
}

class Payment {
  String id;
  Links links;
  String reference;
  String state;
  Amount amount;
  DateTime updateDateTime;
  String outletId;
  String orderReference;

  Payment({
    required this.id,
    required this.links,
    required this.reference,
    required this.state,
    required this.amount,
    required this.updateDateTime,
    required this.outletId,
    required this.orderReference,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'],
      links: Links.fromJson(json['_links']),
      reference: json['reference'],
      state: json['state'],
      amount: Amount.fromJson(json['amount']),
      updateDateTime: DateTime.parse(json['updateDateTime']),
      outletId: json['outletId'],
      orderReference: json['orderReference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      '_links': links.toJson(),
      'reference': reference,
      'state': state,
      'amount': amount.toJson(),
      'updateDateTime': updateDateTime.toIso8601String(),
      'outletId': outletId,
      'orderReference': orderReference,
    };
  }
}
