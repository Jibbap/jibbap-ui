import 'package:flutter/material.dart';
import 'package:jibbap/dtos/group_request_dto.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:jibbap/widgets/jibbap_logo_widget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../dtos/current_group_info.dart';
import '../enums/LogoSizeType.dart';
import '../widgets/basic/text_input.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  final usernameController = TextEditingController();
  bool isGroupNameFilled = false;
  bool isUsernameFilled = false;

  @override
  void initState() {
    super.initState();
    groupNameController.addListener(checkIsGroupNameFilled);
    usernameController.addListener(checkIsUsernameFilled);
  }

  @override
  void dispose() {
    groupNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void checkIsGroupNameFilled() {
    bool isFilled = groupNameController.text.isNotEmpty;
    if (isFilled != isGroupNameFilled) {
      setState(() {
        isGroupNameFilled = isFilled;
      });
    }
  }

  void checkIsUsernameFilled() {
    bool isFilled = usernameController.text.isNotEmpty;
    if (isFilled != isUsernameFilled) {
      setState(() {
        isUsernameFilled = isFilled;
      });
    }
  }

  Future createGroup({
    required CurrentGroupInfoModel currentGroupInfoState,
    required String kakaoId,
  }) async {
    String uuid = const Uuid().v4();
    String usernameInGroup = usernameController.text;
    String groupName = groupNameController.text;

    GroupRequestDto groupRequestDto = GroupRequestDto(
      group_name: groupName,
      kakao_id: kakaoId,
      uuid: uuid,
      username_in_group: usernameInGroup,
    );

    bool isAccepted = await GroupApiService.createGroup(groupRequestDto);
    if (isAccepted) {
      if (currentGroupInfoState.isEmpty()) {
        CurrentGroupInfo currentGroupInfo = CurrentGroupInfo(
          groupName: groupName,
          uuid: uuid,
          usernameInGroup: usernameInGroup,
        );
        await currentGroupInfoState.changeGroupInfo(currentGroupInfo);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    String kakaoId = loginState.user!.id.toString();

    bool isButtonEnabled = isGroupNameFilled && isUsernameFilled;
    Color buttonIconColor =
        isButtonEnabled ? Colors.white : Colors.grey.shade500;
    Color buttonTextColor =
        isButtonEnabled ? Colors.white : Colors.grey.shade500;
    Color buttonBackgroundColor =
        isButtonEnabled ? const Color(0xFF7CC144) : Colors.grey.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('새로운 그룹 생성'),
        elevation: 1,
        foregroundColor: const Color(0xFF7CC144),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Column(
          children: [
            JibbapLogoWidget(
              size: LogoSizeType.small,
            ),
            const SizedBox(height: 20),
            TextInput(
              controller: groupNameController,
              labelText: '그룹 명 입력',
              isFilled: isGroupNameFilled,
              maxLength: 20,
            ),
            TextInput(
              controller: usernameController,
              labelText: '그룹 내에서 사용할 이름 입력',
              isFilled: isUsernameFilled,
              maxLength: 20,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: isButtonEnabled
                  ? () => createGroup(
                      currentGroupInfoState: currentGroupInfoState,
                      kakaoId: kakaoId)
                  : () {},
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
                      Icons.play_lesson_outlined,
                      color: buttonIconColor,
                    ),
                    Text(
                      '그룹 생성하기',
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
