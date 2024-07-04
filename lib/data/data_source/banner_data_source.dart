import 'package:dio/dio.dart';
import 'package:nike_flutter_application/data/data_moudel/banner_data.dart';
import 'package:nike_flutter_application/data/common/http_reponse_validator.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpReponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');

    validateResponse(response);

    final List<BannerEntity> banners = [];
    (response.data as List).forEach((jsonObject) {
      banners.add(BannerEntity.fromJsom(jsonObject));
    });

    return banners;
  }
}
