import 'package:dio/dio.dart';
import 'package:nike_flutter_application/common/constant.dart';
import 'package:nike_flutter_application/data/common/http_reponse_validator.dart';
import 'package:nike_flutter_application/data/data_moudel/auth_data.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String userName, String password);
  Future<AuthInfo> signUp(String userName, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpReponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);
  @override
  Future<AuthInfo> login(String userName, String password) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "password",
      "client_id": 2,
      "client_secret": Constant.clientSecret,
      "username": userName,
      "password": password
    });

    validateResponse(response);
    return AuthInfo(response.data['access_token'],
        response.data['refresh_token'], userName);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post('auth/token', data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": 2,
      "client_secret": Constant.clientSecret
    });

    validateResponse(response);

    return AuthInfo(
        response.data["access_token"], response.data["refresh_token"], '');
  }

  @override
  Future<AuthInfo> signUp(String userName, String password) async {
    final response = await httpClient
        .post('user/register', data: {"email": userName, "password": password});

    validateResponse(response);
    return login(userName, password);
  }
}
