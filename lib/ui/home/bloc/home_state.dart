part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final AppException exception;

  const HomeError({required this.exception});
}

class HomeSuccess extends HomeState {
  final List<BannerEntity> banners;
  final List<ProductEntity> latestProduct;
  final List<ProductEntity> populareProduct;

  const HomeSuccess(
      {required this.banners,
      required this.latestProduct,
      required this.populareProduct});
}
