import 'package:jibbap/dtos/current_group_info.dart';

class GroupIncludingUserDto {
  final String groupName, uuid, usernameInGroup;

  GroupIncludingUserDto.fromJson(Map<String, dynamic> json)
      : groupName = json['group_name'],
        uuid = json['uuid'],
        usernameInGroup = json['username_in_group'];
  GroupIncludingUserDto({
    required this.groupName,
    required this.uuid,
    required this.usernameInGroup,
  });

  CurrentGroupInfo toCurrentGroupInfo() => CurrentGroupInfo(
      groupName: groupName, uuid: uuid, usernameInGroup: usernameInGroup);
}
