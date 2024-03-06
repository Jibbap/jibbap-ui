import 'package:flutter/material.dart';
import 'package:jibbap/widgets/dialogs/join_group_uuid_input_dialog.dart';
import 'package:jibbap/widgets/dialogs/join_group_qr_input_dialog.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기존 그룹 가입'),
        elevation: 1,
        foregroundColor: const Color(0xFF7CC144),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QR 코드 입력: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text('카메라를 통해 QR코드를 확인하여 그룹에 가입할 수 있습니다.'),
                  SizedBox(height: 5),
                  Text(
                    'uuid 입력: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text(
                    '전달 받은 uuid를 입력하여 그룹에 가입할 수 있습니다.',
                  ),
                  SizedBox(height: 5),
                  Text(
                    '초대 방법: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text('홈화면 오른쪽 위 설정 버튼 > 구성원 추가 > 방식 선택'),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QRButton(),
                UuidButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QRButton extends StatelessWidget {
  const QRButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const JoinGroupQRInputDialog(),
      ),
      child: const JoinButton(
        icon: Icons.qr_code_scanner_rounded,
        content: 'QR 코드 입력',
      ),
    );
  }
}

class UuidButton extends StatelessWidget {
  const UuidButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const JoinGroupUuidInputDialog(),
        );
      },
      child: const JoinButton(
        icon: Icons.input_rounded,
        content: 'uuid 입력',
      ),
    );
  }
}

class JoinButton extends StatelessWidget {
  final IconData icon;
  final String content;
  const JoinButton({
    super.key,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF7CC144),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.white,
          ),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
