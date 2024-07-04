import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/banner_data.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/repo/banner_repository.dart';
import 'package:nike_flutter_application/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;

  HomeBloc({required this.bannerRepository, required this.productRepository})
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAll();
          final latestProduct =
              await productRepository.getAll(ProductSort.latest);
          final populareProduct =
              await productRepository.getAll(ProductSort.populare);

          emit(HomeSuccess(
              banners: banners,
              latestProduct: latestProduct,
              populareProduct: populareProduct));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
