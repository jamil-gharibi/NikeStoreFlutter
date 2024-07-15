import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_moudel/order_result.dart';
import 'package:nike_flutter_application/data/data_moudel/payment_receipt.dart';
import 'package:nike_flutter_application/data/data_source/order_data_source.dart';

final orederRepository = OrderRespository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDtatSource {}

class OrderRespository implements IOrderRepository {
  final IOrderDtatSource orderDtatSource;

  OrderRespository(this.orderDtatSource);
  @override
  Future<SubmitOrderResult> submitOrder(SubmitOrderParams params) =>
      orderDtatSource.submitOrder(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orederId) {
    return orderDtatSource.getPaymentReceipt(orederId);
  }

  @override
  Future<List<OrderEntity>> getOrder() {
    return orderDtatSource.getOrder();
  }
}
