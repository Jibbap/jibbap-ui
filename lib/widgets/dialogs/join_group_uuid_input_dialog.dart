import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:jibbap/widgets/basic/text_input.dart';
import 'package:jibbap/widgets/count_progress_indicator.dart';
import 'package:jibbap/widgets/steps/group_info_page_widget.dart';
import 'package:jibbap/widgets/steps/join_check_page_widget.dart';
import 'package:jibbap/widgets/steps/result_page_widget.dart';

import '../../dtos/group_info_dto.dart';
import '../container/dialog_button_container.dart';

class JoinGroupUuidInputDialog extends StatefulWidget {
  const JoinGroupUuidInputDialog({super.key});

  @override
  State<JoinGroupUuidInputDialog> createState() =>
      _JoinGroupUuidInputDialogState();
}

class _JoinGroupUuidInputDialogState extends State<JoinGroupUuidInputDialog> {
  final PageController pageController = PageController(initialPage: 0);
  final usernameInGroupController = TextEditingController();
  final uuidController = TextEditingController();
  GroupInfoDto groupInfo = GroupInfoDto.emptyGroupInfo;
  int currentPage = 0;
  double currentHeight = 250;
  double currentWidth = 350;
  List<double> pageOpacity = [1, 0, 0, 0];
  final List<double> pageHeight = [250, 460, 200, 200];

  @override
  void dispose() {
    pageController.dispose();
    usernameInGroupController.dispose();
    uuidController.dispose();
    super.dispose();
  }

  Future<bool> getGroupInfo({required String uuid}) async {
    groupInfo = await GroupApiService.getGroupInfo(uuid: uuid);
    setState(() {});

    if (!groupInfo.isEmpty()) {
      FocusManager.instance.primaryFocus?.unfocus();

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
            const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                child: UuidInputPage(
                  getGroupInfo: getGroupInfo,
                  uuidController: uuidController,
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
                  uuid: uuidController.text,
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

class UuidInputPage extends StatefulWidget {
  final TextEditingController uuidController;
  final Future<bool> Function({required String uuid}) getGroupInfo;
  const UuidInputPage({
    super.key,
    required this.getGroupInfo,
    required this.uuidController,
  });

  @override
  State<UuidInputPage> createState() => _UuidFirstPageState();
}

class _UuidFirstPageState extends State<UuidInputPage> {
  bool isUuidFilled = false;
  bool isUuidValid = true;
  bool isErrorTextEnabled = false;

  @override
  void initState() {
    super.initState();
    isUuidFilled = widget.uuidController.text != '';
    widget.uuidController.addListener(checkIsGroupNameFilled);
  }

  @override
  void dispose() {
    widget.uuidController.removeListener(checkIsGroupNameFilled);
    super.dispose();
  }

  void onReturnTap(BuildContext context) {
    Navigator.pop(context);
  }

  void onCheckGroupTap({
    required String uuid,
  }) async {
    if (!isUuidFilled) {
      setState(() {
        isErrorTextEnabled = true;
      });
      return;
    }

    bool flag = await widget.getGroupInfo(uuid: uuid);
    if (!flag) {
      setState(() {
        isUuidValid = false;
      });
    }
  }

  void checkIsGroupNameFilled() {
    bool isFilled = widget.uuidController.text.isNotEmpty;
    if (isFilled != isUuidFilled) {
      setState(() {
        isUuidFilled = isFilled;
      });
    }

    if (isFilled && isErrorTextEnabled) {
      setState(() {
        isErrorTextEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? errorText;
    if (!isUuidValid) {
      errorText = '유효하지 않은 uuid입니다.';
    }
    if (isErrorTextEnabled) {
      errorText = 'uuid가 비어있습니다.';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const UuidDialogTitle(),
        TextInput(
          controller: widget.uuidController,
          labelText: 'uuid',
          isFilled: isUuidFilled,
          maxLength: 36,
          errorText: errorText,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => onReturnTap(context),
              child: DialogButtonContainer(
                backgroundColor: const Color(0xFF7CC144).withOpacity(0.2),
                borderColor: const Color(0xFF7CC144),
                fontColor: Colors.black,
                content: '돌아가기',
              ),
            ),
            TextButton(
              onPressed: () =>
                  onCheckGroupTap(uuid: widget.uuidController.text),
              child: DialogButtonContainer(
                backgroundColor: const Color(0xFF7CC144),
                borderColor: const Color(0xFF7CC144),
                fontColor: Colors.white,
                content: '그룹 조회',
              ),
            ),
          ],
        ),
        const CountProgressIndicator(totalCount: 3, current: 0)
      ],
    );
  }
}

class UuidDialogTitle extends StatelessWidget {
  const UuidDialogTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '그룹 ',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'uuid',
          style: TextStyle(
            color: Color(0xFF7CC144),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '를 입력해주세요',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
