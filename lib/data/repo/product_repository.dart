import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_source/product_data_source.dart';
import 'package:nike_flutter_application/data/data_moudel/product_entity_data.dart';

final productRepository =
    ProductRepository(ProductRemoteDataSource(httpClient));

abstract class IProductRepository {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(Stream searchTerm);
}

class ProductRepository implements IProductRepository {
  final IProductDataSource productDataSource;

  ProductRepository(this.productDataSource);
  @override
  Future<List<ProductEntity>> getAll(int sort) =>
      productDataSource.getAll(sort);

  @override
  Future<List<ProductEntity>> search(Stream searchTerm) =>
      productDataSource.search(searchTerm);
}
