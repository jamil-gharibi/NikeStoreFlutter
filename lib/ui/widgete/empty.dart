import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget image;
  final String textMessage;
  final Widget? actionCall;

  const EmptyState(
      {super.key,
      required this.image,
      required this.textMessage,
      this.actionCall});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 130, child: image),
        const SizedBox(
          height: 12,
        ),
        Text(
          textMessage,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w800),
        ),
        if (actionCall != null) actionCall!,
      ],
    );
  }
}
