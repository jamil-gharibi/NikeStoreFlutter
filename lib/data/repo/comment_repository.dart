import 'package:nike_flutter_application/common/http_client.dart';
import 'package:nike_flutter_application/data/data_moudel/comment_data.dart';
import 'package:nike_flutter_application/data/data_source/comment_data_source.dart';

final commentRepository =
    CommentRepository(CommentRemoteDataSource(gttpClient: httpClient));

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource commentDataSource;

  CommentRepository(this.commentDataSource);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      commentDataSource.getAll(productId: productId);
}
