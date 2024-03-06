class GroupRequestDto {
  final String group_name, kakao_id, uuid, username_in_group;

  GroupRequestDto({
    required this.group_name,
    required this.kakao_id,
    required this.uuid,
    required this.username_in_group,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_name': group_name,
      'kakao_id': kakao_id,
      'uuid': uuid,
      'username_in_group': username_in_group
    };
  }
}
