import 'package:flutter/material.dart';
import 'package:jibbap/dtos/current_group_info.dart';
import 'package:jibbap/dtos/group_including_user_dto.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/services/user_api_service.dart';
import 'package:provider/provider.dart';

import 'create_group_dialog.dart';

class GroupInfosDialog extends StatefulWidget {
  final String kakaoId;
  String uuid;
  GroupInfosDialog({
    super.key,
    required this.uuid,
    required this.kakaoId,
  });

  @override
  State<GroupInfosDialog> createState() => _GroupInfosDialogState();
}

class _GroupInfosDialogState extends State<GroupInfosDialog> {
  late Future<List<GroupIncludingUserDto>> groupInfos;

  @override
  void initState() {
    super.initState();
    groupInfos = UserApiService.getAllGroupsIncludingUser(widget.kakaoId);
  }

  void onGroupInfoTap({
    required CurrentGroupInfoModel currentGroupInfoState,
    required GroupIncludingUserDto groupIncludingUserDto,
    required BuildContext context,
  }) async {
    await currentGroupInfoState
        .changeGroupInfo(groupIncludingUserDto.toCurrentGroupInfo());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    return TapRegion(
      onTapOutside: (event) => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              // color: const Color(0xFF313033),
              color: const Color(0xFF7CC144),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: FutureBuilder(
              future: groupInfos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => onGroupInfoTap(
                        currentGroupInfoState: currentGroupInfoState,
                        groupIncludingUserDto: snapshot.data![index],
                        context: context,
                      ),
                      child: EachGroupInfo(
                          groupInfo: snapshot.data![index].toCurrentGroupInfo(),
                          currentGroupUuid: widget.uuid),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            decoration: const BoxDecoration(
              // color: const Color(0xFF313033).withOpacity(0.7),
              color: Color(0xFF7CC144),
            ),
            child: GestureDetector(
              onTap: () {
                showBottomSheet(
                    context: context,
                    builder: (context) => const CreateGroupDialog(),
                    backgroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        '그룹 추가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class EachGroupInfo extends StatelessWidget {
  final CurrentGroupInfo groupInfo;
  String currentGroupUuid;
  EachGroupInfo({
    super.key,
    required this.groupInfo,
    required this.currentGroupUuid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF7CC144),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.group_rounded, color: Colors.white),
          SizedBox(
            width: MediaQuery.sizeOf(context).width - 150,
            child: Text(
              '${groupInfo.groupName}(${groupInfo.usernameInGroup})',
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          currentGroupUuid == groupInfo.uuid
              ? const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                )
              : const SizedBox(
                  width: 28,
                ),
        ],
      ),
    );
  }
}
