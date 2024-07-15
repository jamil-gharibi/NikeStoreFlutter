import 'package:dio/dio.dart';
import 'package:nike_flutter_application/data/data_moudel/order_result.dart';
import 'package:nike_flutter_application/data/data_moudel/payment_receipt.dart';

abstract class IOrderDtatSource {
  Future<SubmitOrderResult> submitOrder(SubmitOrderParams params);
  Future<PaymentReceiptData> getPaymentReceipt(int orederId);
  Future<List<OrderEntity>> getOrder();
}

class OrderRemoteDataSource implements IOrderDtatSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);
  @override
  Future<SubmitOrderResult> submitOrder(SubmitOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      'first_name': params.firstName,
      'last_name': params.lastName,
      'mobile': params.phoneNumber,
      'postal_code': params.postalCode,
      'address': params.address,
      'payment_method': params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery',
    });

    return SubmitOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orederId) async {
    final response = await httpClient.get('order/checkout?order_id=$orederId');
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrder() async {
    final response = await httpClient.get('order/list');
    return (response.data as List)
        .map((item) => OrderEntity.fromJsom(item))
        .toList();
  }
}
