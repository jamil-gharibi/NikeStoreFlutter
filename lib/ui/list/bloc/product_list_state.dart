part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> stateNames;

  const ProductListSuccess(this.products, this.sort, this.stateNames);
  @override
  List<Object> get props => [products, sort, stateNames];
}

class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);
  @override
  List<Object> get props => [exception];
}
