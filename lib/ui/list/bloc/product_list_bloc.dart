import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_flutter_application/common/exception.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';
import 'package:nike_flutter_application/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository productRepository;
  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
          final products = await productRepository.getAll(event.sort);
          emit(ProductListSuccess(products, event.sort, ProductSort.stateName));
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
