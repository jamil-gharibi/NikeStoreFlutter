import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int count;
  bool deleteButtonLoading = false;
  bool changedCountLoading = false;

  CartItemEntity.fromJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArry) {
    final List<CartItemEntity> cartItem = [];

    for (var element in jsonArry) {
      cartItem.add(CartItemEntity.fromJson(element));
    }
    // jsonArry.forEach((element) {
    // cartItem.add(CartItemEntity.fromJson(element));
    // });

    return cartItem;
  }
}
