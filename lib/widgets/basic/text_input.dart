import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  TextInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isFilled,
    required this.maxLength,
    this.isEnabled,
    this.errorText,
  });

  final TextEditingController controller;
  final String labelText;
  final bool isFilled;
  final int maxLength;
  String? errorText;
  bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    Color borderColor =
        isFilled ? const Color(0xFF7CC144) : Colors.grey.shade600;
    return TextField(
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        enabled: isEnabled ?? true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        floatingLabelStyle: TextStyle(
            color: errorText == null ? const Color(0xFF7CC144) : Colors.red),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF7CC144)),
        ),
      ),
    );
  }
}
