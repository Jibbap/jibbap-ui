import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jibbap/dtos/group_info_dto.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:jibbap/widgets/count_progress_indicator.dart';
import 'package:jibbap/widgets/steps/group_info_page_widget.dart';
import 'package:jibbap/widgets/steps/join_check_page_widget.dart';
import 'package:jibbap/widgets/steps/result_page_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class JoinGroupQRInputDialog extends StatefulWidget {
  const JoinGroupQRInputDialog({super.key});

  @override
  State<JoinGroupQRInputDialog> createState() => _QRInputDialogState();
}

class _QRInputDialogState extends State<JoinGroupQRInputDialog> {
  String _uuid = '';
  QRViewController? _controller;
  final PageController pageController = PageController(initialPage: 0);
  final usernameInGroupController = TextEditingController();
  GroupInfoDto groupInfo = GroupInfoDto.emptyGroupInfo;
  int currentPage = 0;
  double currentHeight = 350;
  double currentWidth = 350;
  List<double> pageOpacity = [1, 0, 0, 0];
  final List<double> pageHeight = [350, 460, 150, 180];

  @override
  void dispose() {
    pageController.dispose();
    usernameInGroupController.dispose();
    super.dispose();
  }

  Future<bool> getResult({required String uuid}) async {
    if (_uuid == uuid) {
      return false;
    }

    _uuid = uuid;
    groupInfo = await GroupApiService.getGroupInfo(uuid: uuid);

    if (!groupInfo.isEmpty()) {
      goForward();
    }

    return !groupInfo.isEmpty();
  }

  void goForward() {
    setState(() {
      pageOpacity[currentPage] = 0;
      currentPage += 1;
      currentWidth = currentPage == 3 ? 140 : 350;
      currentHeight = pageHeight[currentPage];
    });
    pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void goBack() {
    setState(() {
      pageOpacity[currentPage] = 0;
      currentPage -= 1;
      currentWidth = currentPage == 3 ? 140 : 350;
      currentHeight = pageHeight[currentPage];
    });
    pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void onPageChanged(int page) {
    setState(() {
      pageOpacity[page] = 1;
    });

    if (page == 0) {
      setState(() {
        _uuid = '';
      });
      _controller?.resumeCamera();
    }

    if (page == 3) {
      Timer(
        const Duration(milliseconds: 1900),
        () => Navigator.pop(context),
      );
    }
  }

  void onOutsideTap(BuildContext context) {
    if (currentPage == 3) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (event) => onOutsideTap(context),
      child: AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: currentWidth,
          height: currentHeight,
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
            children: [
              AnimatedOpacity(
                opacity: pageOpacity[0],
                duration: const Duration(milliseconds: 100),
                child: QRCamera(
                  uuid: _uuid,
                  controller: _controller,
                  getResult: getResult,
                ),
              ),
              AnimatedOpacity(
                opacity: pageOpacity[1],
                duration: const Duration(milliseconds: 100),
                child: GroupInfoPage(
                  groupInfo: groupInfo,
                  goBack: goBack,
                  goForward: goForward,
                  usernameInGroupController: usernameInGroupController,
                ),
              ),
              AnimatedOpacity(
                opacity: pageOpacity[2],
                duration: const Duration(milliseconds: 100),
                child: JoinCheckPage(
                  uuid: _uuid,
                  groupName: groupInfo.group_name,
                  usernameInGroup: usernameInGroupController.text,
                  goBack: goBack,
                  goForward: goForward,
                ),
              ),
              AnimatedOpacity(
                opacity: pageOpacity[3],
                duration: const Duration(milliseconds: 100),
                child: ResultPage(
                  groupName: groupInfo.group_name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCamera extends StatefulWidget {
  String uuid;
  QRViewController? controller;
  final Function({required String uuid}) getResult;
  QRCamera({
    super.key,
    required this.uuid,
    required this.controller,
    required this.getResult,
  });

  @override
  State<QRCamera> createState() => _QRCameraState();
}

class _QRCameraState extends State<QRCamera> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoaded = false;
  bool isUuidValid = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      widget.controller!.pauseCamera();
    } else if (Platform.isIOS) {
      widget.controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    widget.controller = controller;
    widget.controller?.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !isLoaded) {
        isUuidValid = await widget.getResult(uuid: scanData.code!);
        if (isUuidValid) {
          isLoaded = true;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color(0xFF7CC144),
              borderRadius: 10,
              borderLength: 20,
              borderWidth: 10,
            ),
          ),
        ),
        const Text('QR코드를 입력해주세요'),
        isUuidValid
            ? const Text('')
            : const Text(
                '유효하지 않은 QR코드입니다.',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
        const CountProgressIndicator(totalCount: 3, current: 0)
      ],
    );
  }
}
