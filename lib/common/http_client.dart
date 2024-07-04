import 'package:dio/dio.dart';
import 'package:nike_flutter_application/data/repo/auth_repository.dart';

final httpClient =
    Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'))
      ..interceptors.add(InterceptorsWrapper(onRequest: (option, handler) {
        final authInfo = AuthRepository.valueNotifierAutInfo.value;
        if (authInfo != null && authInfo.accessToken.isNotEmpty) {
          option.headers['Authorization'] = 'Bearer ${authInfo.accessToken}';
        }
        handler.next(option);
      }));
