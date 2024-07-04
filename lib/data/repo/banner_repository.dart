import 'package:nike_flutter_application/data/data_moudel/banner_data.dart';
import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_source/banner_data_source.dart';

final bannerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource bannerDataSource;

  BannerRepository(this.bannerDataSource);

  @override
  Future<List<BannerEntity>> getAll() => bannerDataSource.getAll();
}
