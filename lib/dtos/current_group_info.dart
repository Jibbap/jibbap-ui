class CurrentGroupInfo {
  final String groupName, uuid, usernameInGroup;

  CurrentGroupInfo.fromJson(Map<String, dynamic> json)
      : groupName = json['groupName'],
        uuid = json['uuid'],
        usernameInGroup = json['usernameInGroup'];

  CurrentGroupInfo({
    required this.groupName,
    required this.uuid,
    required this.usernameInGroup,
  });

  Map<String, dynamic> toJson() => {
        'groupName': groupName,
        'uuid': uuid,
        'usernameInGroup': usernameInGroup,
      };

  bool isEmpty() => groupName == '';
}
