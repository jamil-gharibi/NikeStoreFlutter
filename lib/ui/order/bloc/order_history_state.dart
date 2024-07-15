part of 'order_history_bloc.dart';

sealed class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

final class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistorySuccess extends OrderHistoryState {
  final List<OrderEntity> orderEntitys;

  const OrderHistorySuccess(this.orderEntitys);
  @override
  List<Object> get props => [orderEntitys];
}

class OrderHistoryError extends OrderHistoryState {
  final AppException exception;

  const OrderHistoryError(this.exception);

  @override
  List<Object> get props => [exception];
}
