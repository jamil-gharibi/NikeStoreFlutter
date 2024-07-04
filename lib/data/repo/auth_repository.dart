import 'package:flutter/material.dart';
import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_moudel/auth_data.dart';
import 'package:nike_flutter_application/data/data_source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String userName, String password);
  Future<void> sigUp(String userName, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository extends IAuthRepository {
  static final ValueNotifier<AuthInfo?> valueNotifierAutInfo =
      ValueNotifier(null);
  final IAuthDataSource authDataSource;
  AuthRepository(this.authDataSource);

  @override
  Future<void> login(String userName, String password) async {
    final AuthInfo authInfo = await authDataSource.login(userName, password);
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> sigUp(String userName, String password) async {
    final AuthInfo authInfo = await authDataSource.signUp(userName, password);
    debugPrint('acces token is :${authInfo.accessToken}');
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (valueNotifierAutInfo.value != null) {
      final AuthInfo authInfo = await authDataSource
          .refreshToken(valueNotifierAutInfo.value!.refreshToken);

      debugPrint('refersh token is : ${authInfo.refreshToken}');
      _persistAuthToken(authInfo);
    }
  }

  Future<void> _persistAuthToken(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);

    loadAutInfo();
  }

  Future<void> loadAutInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';

    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';

    final String email = sharedPreferences.getString('email') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      valueNotifierAutInfo.value = AuthInfo(accessToken, refreshToken, email);
    }
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    valueNotifierAutInfo.value = null;
  }
}
