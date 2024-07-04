import 'package:flutter/cupertino.dart';
import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_moudel/add_to_cart_response_data.dart';
import 'package:nike_flutter_application/data/data_moudel/cart_response_data.dart';
import 'package:nike_flutter_application/data/data_source/cart_data_source.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository {
  Future<AddToCartResponseData> add(int productId);
  Future<AddToCartResponseData> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRepository implements ICartRepository {
  final ICartDataSource cartDataSource;
  static ValueNotifier<int> cartItemCountNotifire = ValueNotifier(0);
  CartRepository(this.cartDataSource);
  @override
  Future<AddToCartResponseData> add(int productId) =>
      cartDataSource.add(productId);

  @override
  Future<AddToCartResponseData> changeCount(int cartItemId, int count) {
    return cartDataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await cartDataSource.count();
    cartItemCountNotifire.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return cartDataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() {
    return cartDataSource.getAll();
  }
}
