import 'package:flutter/material.dart';
import 'package:jibbap/screens/create_group_screen.dart';

import '../../screens/join_group_screen.dart';

class CreateGroupDialog extends StatelessWidget {
  const CreateGroupDialog({super.key});

  onNavigateButtonTap(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) => Navigator.pop(context),
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  onNavigateButtonTap(context, const CreateGroupScreen()),
              child: const Button(
                icon: Icon(
                  Icons.add_home_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                content: '새로운 그룹 생성',
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () =>
                  onNavigateButtonTap(context, const JoinGroupScreen()),
              child: const Button(
                icon: Icon(
                  Icons.group_add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                content: '기존 그룹 가입',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Icon icon;
  final String content;
  const Button({
    super.key,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF7CC144),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}
