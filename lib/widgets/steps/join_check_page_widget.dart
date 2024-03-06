import 'package:flutter/material.dart';
import 'package:jibbap/dtos/current_group_info.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:jibbap/widgets/container/dialog_button_container.dart';
import 'package:jibbap/widgets/count_progress_indicator.dart';
import 'package:provider/provider.dart';

class JoinCheckPage extends StatelessWidget {
  String groupName, usernameInGroup, uuid;
  final Function() goBack, goForward;
  JoinCheckPage({
    super.key,
    required this.uuid,
    required this.groupName,
    required this.usernameInGroup,
    required this.goBack,
    required this.goForward,
  });

  void onJoinGroupTap({
    required String uuid,
    required String kakaoId,
    required String usernameInGroup,
    required CurrentGroupInfoModel currentGroupInfoState,
  }) async {
    bool isAccepted = await GroupApiService.joinGroup(
        uuid: uuid, kakaoId: kakaoId, usernameInGroup: usernameInGroup);
    if (isAccepted) {
      goForward();
      if (currentGroupInfoState.isEmpty()) {
        CurrentGroupInfo currentGroupInfo = CurrentGroupInfo(
          groupName: groupName,
          uuid: uuid,
          usernameInGroup: usernameInGroup,
        );
        currentGroupInfoState.changeGroupInfo(currentGroupInfo);
      }
    }
  }

  bool checkBottomConsonant(String input) {
    bool result = false;
    if (isKorean(korean: input)) {
      result = ((input.runes.first - 0xAC00) / (28 * 21)) < 0
          ? false
          : (((input.runes.first - 0xAC00) % 28 != 0) ? true : false);
    }
    return result;
  }

  bool isKorean({required String korean}) {
    bool isKorean = false;
    int inputToUniCode = korean.codeUnits[0];

    isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643)
        ? true
        : (inputToUniCode >= 44032 && inputToUniCode <= 55203)
            ? true
            : false;

    return isKorean;
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    String kakaoId = loginState.user!.id.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Wrap(
              children: [
                Text(
                  groupName,
                  style: const TextStyle(
                    color: Color(0xFF7CC144),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  '에',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  usernameInGroup,
                  style: const TextStyle(
                    color: Color(0xFF7CC144),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${checkBottomConsonant(usernameInGroup.substring(usernameInGroup.length - 1)) ? '으로' : '로'} 가입하시겠습니까?',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: goBack,
              child: DialogButtonContainer(
                backgroundColor: const Color(0xFF7CC144).withOpacity(0.2),
                borderColor: const Color(0xFF7CC144),
                fontColor: Colors.black,
                content: '돌아가기',
              ),
            ),
            TextButton(
              onPressed: () => onJoinGroupTap(
                kakaoId: kakaoId,
                usernameInGroup: usernameInGroup,
                uuid: uuid,
                currentGroupInfoState: currentGroupInfoState,
              ),
              child: DialogButtonContainer(
                backgroundColor: const Color(0xFF7CC144),
                borderColor: const Color(0xFF7CC144),
                fontColor: Colors.white,
                content: '그룹 가입',
              ),
            ),
          ],
        ),
        const CountProgressIndicator(totalCount: 3, current: 2)
      ],
    );
  }
}
