import 'package:flutter/material.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QROutputDialog extends StatelessWidget {
  const QROutputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    String uuid = currentGroupInfoState.uuid;

    return AlertDialog(
      content: Container(
        alignment: Alignment.center,
        width: 240,
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: uuid,
              version: QrVersions.auto,
              size: 200,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'QR코드',
                  style: TextStyle(
                    color: Color(0xFF7CC144),
                    fontSize: 16,
                  ),
                ),
                Text(
                  '를 인식하세요',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
