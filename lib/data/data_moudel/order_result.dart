import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';

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

class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.payablePrice, this.items);
  OrderEntity.fromJsom(Map<String, dynamic> json)
      : id = json['id'],
        payablePrice = json['payable'],
        items = getProduct(json['order_items'] as List);
}

List<ProductEntity> getProduct(List listProduct) {
  final products = <ProductEntity>[];
  for (var product in listProduct) {
    products.add(ProductEntity.fromJson(product['product']));
  }

  return products;
}
