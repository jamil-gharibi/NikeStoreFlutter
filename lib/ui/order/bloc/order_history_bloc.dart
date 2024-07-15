import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/order_result.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';

part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  IOrderRepository orderRepository;
  OrderHistoryBloc(this.orderRepository) : super(OrderHistoryLoading()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          final response = await orderRepository.getOrder();
          emit(OrderHistorySuccess(response));
        } catch (e) {
          emit(OrderHistoryError(AppException(message: e.toString())));
        }
      }
    });
  }
}
