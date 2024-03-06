import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/widgets/dialogs/qr_output_dialog.dart';
import 'package:provider/provider.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '그룹 초대',
        ),
        elevation: 1,
        foregroundColor: const Color(0xFF7CC144),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
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
                    'QR 코드 출력: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text('QR코드 확인을 통해 그룹에 가입 시킬 수 있습니다.'),
                  SizedBox(height: 5),
                  Text(
                    'uuid 복사: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text(
                    '복사한 uuid를 통해 그룹에 가입 시킬 수 있습니다.',
                  ),
                  Text(
                    '가입 방법: ',
                    style: TextStyle(color: Color(0xFF7CC144)),
                  ),
                  Text('설정화면 현재 그룹 설정 버튼 > 그룹 추가 > 기존 그룹 가입 > 방식 선택'),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  void onQRCodeTap({required BuildContext context}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const QROutputDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onQRCodeTap(context: context),
      child: const ButtonContainer(
        icon: Icons.qr_code_scanner_rounded,
        content: 'QR 코드 출력',
      ),
    );
  }
}

class UuidButton extends StatelessWidget {
  const UuidButton({
    super.key,
  });

  void onCopyUuidTap({required String uuid}) {
    Clipboard.setData(ClipboardData(text: uuid));
    Fluttertoast.showToast(
      msg: 'uuid가 복사되엇습니다.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade400,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    String uuid = currentGroupInfoState.uuid;

    return GestureDetector(
      onTap: () => onCopyUuidTap(uuid: uuid),
      child: const ButtonContainer(
        icon: Icons.content_copy_rounded,
        content: 'uuid 복사',
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final IconData icon;
  final String content;
  const ButtonContainer({
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
