import 'package:jibbap/dtos/user_info_in_group_dto.dart';

class GroupInfoDto {
  final String group_name;
  final List<UserInfoInGroupDto> userInfos;
  static GroupInfoDto emptyGroupInfo =
      GroupInfoDto(group_name: '', userInfos: []);

  GroupInfoDto({
    required this.group_name,
    required this.userInfos,
  });

  GroupInfoDto.fromJson(Map<String, dynamic> json)
      : group_name = json['group_name'],
        userInfos = (json['user_infos'] as List)
            .map((e) => UserInfoInGroupDto.fromJson(e))
            .toList();

  bool isEmpty() => group_name == '';
}
