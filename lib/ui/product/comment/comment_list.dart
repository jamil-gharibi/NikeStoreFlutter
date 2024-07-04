import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_flutter_application/ui/product/comment/comment_item.dart';
import 'package:nike_flutter_application/ui/widgete/error_try_again.dart';
import 'package:nike_flutter_application/data/repo/comment_repository.dart';
import 'package:nike_flutter_application/ui/product/comment/bloc/comment_list_bloc.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key, required this.productId});
  final int productId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CommentListBloc(
            commentRepository: commentRepository, productId: productId);
        bloc.add(CommentListStarted());

        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state is CommentListSuccess) {
            return SliverList(
                delegate: SliverChildBuilderDelegate(
              childCount: state.comment.length,
              (context, index) {
                return CommentItem(
                  comment: state.comment[index],
                );
              },
            ));
          } else if (state is CommentListLoading) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CommentListError) {
            return AppErrorWidgete(
                exception: state.exception,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(context)
                      .add(CommentListStarted());
                });
          } else {
            throw Exception('state is not suported');
          }
        },
      ),
    );
  }
}
