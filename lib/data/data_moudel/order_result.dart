class SubmitOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  SubmitOrderResult(this.orderId, this.bankGatewayUrl);
  SubmitOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGatewayUrl = json['bank_gateway_url'];
}

class SubmitOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  SubmitOrderParams(
      {required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.postalCode,
      required this.address,
      required this.paymentMethod});
}

enum PaymentMethod {
  online,
  cashOnDelivery;
}
