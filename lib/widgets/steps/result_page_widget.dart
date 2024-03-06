import 'package:flutter/cupertino.dart';

class ResultPage extends StatelessWidget {
  String groupName;
  ResultPage({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/approved.gif',
          width: 150,
          height: 150,
        ),
        Wrap(
          children: [
            Text(
              groupName,
              style: const TextStyle(
                color: Color(0xFF7CC144),
                fontSize: 16,
              ),
            ),
            const Text(
              '에서 ',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Text(
              '집밥',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7CC144),
              ),
            ),
            const Text(
              '하세요',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
