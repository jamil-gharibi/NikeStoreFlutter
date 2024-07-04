import 'package:flutter/material.dart';
import 'package:nike_flutter_application/data/data_moudel/comment_data.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: themeData.dividerColor),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.title,
                    style: themeData.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    comment.email,
                    style:
                        themeData.textTheme.bodyMedium!.copyWith(fontSize: 12),
                  )
                ],
              ),
              Text(
                comment.date,
                style: themeData.textTheme.bodyMedium!.copyWith(fontSize: 12),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            comment.content,
            style: themeData.textTheme.bodyMedium!
                .copyWith(color: themeData.colorScheme.onSurface, height: 1.4),
          )
        ],
      ),
    );
  }
}
