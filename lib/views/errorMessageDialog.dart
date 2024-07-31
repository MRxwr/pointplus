import 'package:flutter/material.dart';
import 'package:point/presentation/resources/color_manager.dart';

class ErrorMessageDialog extends StatelessWidget {
  const ErrorMessageDialog({required this.errorMessage, super.key});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.transparent,
      content: Text(
        errorMessage!,
        style: TextStyle(color: ColorManager.primary),
      ),
    );
  }
}
