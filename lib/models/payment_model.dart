class PaymentModel {
  final String token;
  final String profileToken;

  PaymentModel({this.token = "", this.profileToken = ""});

  Map<String, dynamic> toMap() {
    return {"token": token, "profile_token": profileToken};
  }

  static PaymentModel fromMap(Map map) {
    return PaymentModel(
        token: map["token"], profileToken: map["profile_token"]);
  }
}

class ClientInfo {
  final String email;
  final String fullName;
  final String phoneNumber;

  ClientInfo({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) {
    return ClientInfo(
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }
}

class PaymentLink {
  final int id;
  final dynamic currency;
  final ClientInfo clientInfo;
  final dynamic referenceId;
  final int amountCents;
  final dynamic paymentLinkImage;
  final dynamic description;
  final String createdAt;
  final dynamic expiresAt;
  final String clientUrl;
  final int origin;
  final dynamic merchantStaffTag;
  final String state;
  final dynamic paidAt;
  final dynamic redirectionUrl;
  final dynamic notificationUrl;
  final int order;

  PaymentLink({
    required this.id,
    this.currency,
    required this.clientInfo,
    this.referenceId,
    required this.amountCents,
    this.paymentLinkImage,
    this.description,
    required this.createdAt,
    this.expiresAt,
    required this.clientUrl,
    required this.origin,
    this.merchantStaffTag,
    required this.state,
    this.paidAt,
    this.redirectionUrl,
    this.notificationUrl,
    required this.order,
  });

  factory PaymentLink.fromJson(Map<String, dynamic> json) {
    return PaymentLink(
      id: json['id'],
      currency: json['currency'],
      clientInfo: ClientInfo.fromJson(json['client_info']),
      referenceId: json['reference_id'],
      amountCents: json['amount_cents'],
      paymentLinkImage: json['payment_link_image'],
      description: json['description'],
      createdAt: json['created_at'],
      expiresAt: json['expires_at'],
      clientUrl: json['client_url'],
      origin: json['origin'],
      merchantStaffTag: json['merchant_staff_tag'],
      state: json['state'],
      paidAt: json['paid_at'],
      redirectionUrl: json['redirection_url'],
      notificationUrl: json['notification_url'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currency': currency,
      'client_info': clientInfo.toJson(),
      'reference_id': referenceId,
      'amount_cents': amountCents,
      'payment_link_image': paymentLinkImage,
      'description': description,
      'created_at': createdAt,
      'expires_at': expiresAt,
      'client_url': clientUrl,
      'origin': origin,
      'merchant_staff_tag': merchantStaffTag,
      'state': state,
      'paid_at': paidAt,
      'redirection_url': redirectionUrl,
      'notification_url': notificationUrl,
      'order': order,
    };
  }
}
