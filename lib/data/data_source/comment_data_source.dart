import 'package:dio/dio.dart';
import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_moudel/comment_data.dart';
import 'package:nike_flutter_application/data/common/http_reponse_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDataSource
    with HttpReponseValidator
    implements ICommentDataSource {
  final Dio gttpClient;

  CommentRemoteDataSource({required this.gttpClient});
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');

    validateResponse(response);

    final List<CommentEntity> comment = [];
    (response.data as List).forEach((element) {
      comment.add(CommentEntity.from(element));
    });

    return comment;
  }
}
