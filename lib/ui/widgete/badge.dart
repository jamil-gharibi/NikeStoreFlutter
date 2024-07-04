import 'package:flutter/material.dart';

class BadgeCart extends StatelessWidget {
  final int count;

  const BadgeCart({super.key, required this.count});
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: count > 0,
        child: Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Text(
            count.toString(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.surface, fontSize: 12),
          ),
        ));
  }
}
