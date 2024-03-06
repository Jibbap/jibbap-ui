import 'package:flutter/material.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/screens/username_in_group_setting_screen.dart';
import 'package:jibbap/widgets/dialogs/group_infos_dialog.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    var currentGoupInfoState = context.watch<CurrentGroupInfoModel>();
    String kakaoId = loginState.user!.id.toString();
    String usernameInGroup = currentGoupInfoState.usernameInGroup;
    String groupName = currentGoupInfoState.groupName;
    String uuid = currentGoupInfoState.uuid;

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          const UserProfile(),
          TaggedText(
            tag: '현재 그룹',
            nickname: groupName,
            onSettingPressed: () => showBottomSheet(
              context: context,
              builder: (context) => GroupInfosDialog(
                uuid: uuid,
                kakaoId: kakaoId,
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TaggedText(
            tag: '그룹 유저명',
            nickname: usernameInGroup,
            onSettingPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsernameInGroupSettingScreen(
                  usernameInGroup: usernameInGroup,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaggedText extends StatelessWidget {
  final String nickname, tag;
  final Function() onSettingPressed;
  const TaggedText({
    super.key,
    required this.tag,
    required this.nickname,
    required this.onSettingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(tag),
        ),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  nickname,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                ),
              ),
              Transform.translate(
                offset: const Offset(12, 0),
                child: IconButton(
                  onPressed: onSettingPressed,
                  icon: const Icon(
                    Icons.settings_rounded,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.watch<LoginModel>().user;
    return Column(
      children: [
        CircleAvatar(
          radius: 100,
          backgroundImage: NetworkImage(
            user!.kakaoAccount!.profile!.profileImageUrl!,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          user.kakaoAccount!.profile!.nickname!,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
