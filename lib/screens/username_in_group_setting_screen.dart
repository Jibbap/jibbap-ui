import 'package:flutter/material.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:jibbap/widgets/basic/text_input.dart';
import 'package:provider/provider.dart';

class UsernameInGroupSettingScreen extends StatefulWidget {
  final String usernameInGroup;
  const UsernameInGroupSettingScreen(
      {super.key, required this.usernameInGroup});

  @override
  State<UsernameInGroupSettingScreen> createState() =>
      _UsernameInGroupSettingScreenState();
}

class _UsernameInGroupSettingScreenState
    extends State<UsernameInGroupSettingScreen> {
  final textController = TextEditingController();
  bool isUsernameFilled = true;
  bool isChangeAccepted = true;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    textController.text = widget.usernameInGroup;
    textController.addListener(checkIsTextFilled);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void checkIsTextFilled() {
    bool isFilled = textController.text.isNotEmpty;
    if (isFilled != isUsernameFilled) {
      setState(() {
        isUsernameFilled = isFilled;
      });
    }

    if (isButtonEnabled && textController.text == widget.usernameInGroup) {
      setState(() {
        isButtonEnabled = false;
      });
    } else if (!isButtonEnabled &&
        textController.text != widget.usernameInGroup) {
      setState(() {
        isButtonEnabled = true;
      });
    }
  }

  void changeUsername() async {
    if (!(isUsernameFilled && isButtonEnabled)) {
      return;
    }

    var loginState = context.read<LoginModel>();
    var currentGoupInfoState = context.read<CurrentGroupInfoModel>();
    String kakaoId = loginState.user!.id.toString();
    String uuid = currentGoupInfoState.uuid;
    String usernameInGroup = textController.text;

    bool isAccepted = await GroupApiService.changeUsernameInGroup(
        uuid: uuid, kakaoId: kakaoId, usernameInGroup: usernameInGroup);

    if (!isAccepted) {
      setState(() {
        isChangeAccepted = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.read<CurrentGroupInfoModel>();
    String groupName = currentGroupInfoState.groupName;

    bool isEnabled = isButtonEnabled && isUsernameFilled;
    Color buttonIconColor = isEnabled ? Colors.white : Colors.grey.shade500;
    Color buttonTextColor = isEnabled ? Colors.white : Colors.grey.shade500;
    Color buttonBackgroundColor =
        isEnabled ? const Color(0xFF7CC144) : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 유저명 수정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  groupName,
                  style: const TextStyle(color: Color(0xFF7CC144)),
                ),
                const Text('의 유저명 수정'),
              ],
            ),
            TextInput(
              controller: textController,
              labelText: '그룹 유저명',
              isFilled: isUsernameFilled,
              errorText: isChangeAccepted ? null : '잘못된 uuid를 사용중입니다.',
              maxLength: 20,
            ),
            GestureDetector(
              onTap: changeUsername,
              child: Container(
                width: 300,
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: buttonBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.published_with_changes_rounded,
                      color: buttonIconColor,
                    ),
                    Text(
                      '그룹 유저명 변경',
                      style: TextStyle(
                          color: buttonTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    const SizedBox(width: 24)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
