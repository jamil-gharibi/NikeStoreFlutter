import 'package:nike_flutter_application/data/data_moudel/cart_item_data.dart';

class CartResponse {
  final List<CartItemEntity> cartItem;
  int payablePrice;
  int totalPrice;
  int shippingPrice;

  CartResponse.fromJson(Map<String, dynamic> json)
      : cartItem = CartItemEntity.parseJsonArray(json['cart_items']),
        payablePrice = json['payable_price'],
        totalPrice = json['total_price'],
        shippingPrice = json['shipping_cost'];
}
