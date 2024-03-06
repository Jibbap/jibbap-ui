import 'package:flutter/material.dart';
import 'package:jibbap/dtos/group_info_dto.dart';
import 'package:jibbap/dtos/user_info_in_group_dto.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/screens/invite_screen.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:provider/provider.dart';

class HomeMenuScreen extends StatefulWidget {
  final String uuid;
  const HomeMenuScreen({super.key, required this.uuid});

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  late Future<GroupInfoDto> groupInfo;

  @override
  void initState() {
    super.initState();
    groupInfo = GroupApiService.getGroupInfo(uuid: widget.uuid);
  }

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    String groupName = currentGroupInfoState.groupName;
    double maxHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        300;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color(0xFF7CC144),
        elevation: 1,
        title: Text(groupName),
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('구성원'),
                  FutureBuilder(
                    future: groupInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<UserInfoInGroupDto> userInfos =
                            snapshot.data!.userInfos;
                        return Column(
                          children: [
                            for (var userInfo in userInfos)
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(userInfo.profileImageUrl),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(userInfo.usernameInGroup),
                                ],
                              )
                          ],
                        );
                      }
                      return const CircularProgressIndicator(
                        color: Color(0xFF7CC144),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: TextButton(
              onPressed: onInviteTap,
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFF7CC144),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  '구성원 추가',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onInviteTap() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InviteScreen(),
        ));
  }
}
