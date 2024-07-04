import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/order_result.dart';
import 'package:nike_flutter_application/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  IOrderRepository orderRepository;
  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreateOrder) {
        try {
          emit(ShippingLoading());
          final result = await orderRepository.submitOrder(event.params);
          emit(ShippingSucces(result));
        } catch (e) {
          emit(ShippingError(AppException()));
        }
      } else {}
    });
  }
}
