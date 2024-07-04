import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/payment_receipt.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;
  PaymentReceiptBloc(this.orderRepository) : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceiptLoading());
          final result = await orderRepository.getPaymentReceipt(event.orderId);
          emit(PaymentReceiptSuccess(result));
        } catch (e) {
          emit(PaymentReceiptError(AppException()));
        }
      } else {}
    });
  }
}
