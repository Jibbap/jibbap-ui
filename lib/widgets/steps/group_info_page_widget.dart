import 'package:flutter/material.dart';
import 'package:jibbap/dtos/group_info_dto.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/widgets/basic/text_input.dart';
import 'package:jibbap/widgets/container/dialog_button_container.dart';
import 'package:jibbap/widgets/count_progress_indicator.dart';
import 'package:provider/provider.dart';

class GroupInfoPage extends StatefulWidget {
  GroupInfoDto groupInfo;
  final Function() goForward, goBack;
  final TextEditingController usernameInGroupController;

  GroupInfoPage({
    super.key,
    required this.groupInfo,
    required this.goBack,
    required this.goForward,
    required this.usernameInGroupController,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  bool isUsernameInGroupFilled = false;
  bool isErrorTextEnabled = false;

  @override
  void initState() {
    super.initState();
    isUsernameInGroupFilled = widget.usernameInGroupController.text != '';
    widget.usernameInGroupController.addListener(checkIsUsernameInGroupFilled);
  }

  @override
  void dispose() {
    widget.usernameInGroupController
        .removeListener(checkIsUsernameInGroupFilled);
    super.dispose();
  }

  void checkIsUsernameInGroupFilled() {
    bool isFilled = widget.usernameInGroupController.text.isNotEmpty;
    if (isFilled != isUsernameInGroupFilled) {
      setState(() {
        isUsernameInGroupFilled = isFilled;
      });
    }
    if (isFilled && isErrorTextEnabled) {
      setState(() {
        isErrorTextEnabled = false;
      });
    }
  }

  void onJoinGroupTap() async {
    if (!isUsernameInGroupFilled) {
      setState(() {
        isErrorTextEnabled = true;
      });
      return;
    }

    widget.goForward();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    String kakaoId = loginState.user!.id.toString();
    bool isAlreadyAccepted = widget.groupInfo.userInfos.any(
      (element) => element.kakaoId == kakaoId,
    );
    String? errorText;
    if (isAlreadyAccepted) {
      errorText = '이미 가입된 그룹입니다.';
    } else if (isErrorTextEnabled) {
      errorText = '유저명이 비어있습니다.';
    } else {
      errorText = null;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 21),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: const Color(0xFF7CC144),
            ),
            child: Text(
              widget.groupInfo.group_name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 230,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF7CC144).withOpacity(0.7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView.separated(
              itemCount: widget.groupInfo.userInfos.length,
              physics: widget.groupInfo.userInfos.length <= 4
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => UserProfile(
                username: widget.groupInfo.userInfos[index].usernameInGroup,
                profileImageUrl:
                    widget.groupInfo.userInfos[index].profileImageUrl,
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 5),
            ),
          ),
          TextInput(
            controller: widget.usernameInGroupController,
            labelText: '그룹 유저명',
            isFilled: isUsernameInGroupFilled,
            isEnabled: !isAlreadyAccepted,
            maxLength: 20,
            errorText: errorText,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: widget.goBack,
                child: DialogButtonContainer(
                  backgroundColor: const Color(0xFF7CC144).withOpacity(0.2),
                  borderColor: const Color(0xFF7CC144),
                  fontColor: Colors.black,
                  content: '돌아가기',
                ),
              ),
              TextButton(
                onPressed: onJoinGroupTap,
                child: DialogButtonContainer(
                  backgroundColor: const Color(0xFF7CC144),
                  borderColor: const Color(0xFF7CC144),
                  fontColor: Colors.white,
                  content: '그룹 가입',
                ),
              ),
            ],
          ),
          const CountProgressIndicator(totalCount: 3, current: 1)
        ],
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  final String username, profileImageUrl;
  const UserProfile({
    super.key,
    required this.username,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(profileImageUrl),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(username),
      ],
    );
  }
}
