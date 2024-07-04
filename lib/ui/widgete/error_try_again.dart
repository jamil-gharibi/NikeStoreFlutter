import 'package:flutter/material.dart';
import 'package:nike_flutter_application/common/exception.dart';

class AppErrorWidgete extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onPressed;
  const AppErrorWidgete({
    super.key,
    required this.exception,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(exception.message),
          ElevatedButton(onPressed: onPressed, child: const Text('تلاش دوباره'))
        ],
      ),
    );
  }
}
