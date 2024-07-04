import 'package:dio/dio.dart';
import 'package:nike_flutter_application/data/data_moudel/add_to_cart_response_data.dart';
import 'package:nike_flutter_application/data/data_moudel/cart_response_data.dart';

abstract class ICartDataSource {
  Future<AddToCartResponseData> add(int productId);
  Future<AddToCartResponseData> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);
  @override
  Future<AddToCartResponseData> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {"product_id": productId});

    return AddToCartResponseData.fromJson(response.data);
  }

  @override
  Future<AddToCartResponseData> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post('cart/changeCount',
        data: {'cart_item_id': cartItemId, 'count': count});

    return AddToCartResponseData.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    await httpClient.post('cart/remove', data: {'cart_item_id': cartItemId});
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');

    return CartResponse.fromJson(response.data);
  }
}
