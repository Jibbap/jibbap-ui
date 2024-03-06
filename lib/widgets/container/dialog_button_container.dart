import 'package:flutter/cupertino.dart';

class DialogButtonContainer extends StatelessWidget {
  Color backgroundColor, borderColor, fontColor;
  final String content;
  bool? isActivated;
  DialogButtonContainer({
    super.key,
    required this.content,
    required this.backgroundColor,
    required this.borderColor,
    required this.fontColor,
    this.isActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Text(
        content,
        style: TextStyle(
          color: fontColor,
        ),
      ),
    );
  }
}
