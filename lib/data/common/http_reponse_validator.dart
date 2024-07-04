import 'package:dio/dio.dart';
import 'package:nike_flutter_application/common/exception.dart';

mixin HttpReponseValidator {
  void validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
