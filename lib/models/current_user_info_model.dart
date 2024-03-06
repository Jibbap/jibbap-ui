import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../dtos/current_group_info.dart';

class CurrentGroupInfoModel extends ChangeNotifier {
  static const CURRENT_GROUP_INFO_KEY = 'group-info';
  final storage = const FlutterSecureStorage();
  bool isLoaded = false;
  String groupName = '';
  String usernameInGroup = '';
  String uuid = '';

  CurrentGroupInfoModel() {
    init().then((_) => notifyListeners());
  }

  Future init() async {
    // await storage.deleteAll();
    final jsonData = await storage.read(key: CURRENT_GROUP_INFO_KEY) ?? '';
    if (jsonData != '') {
      CurrentGroupInfo groupInfo =
          CurrentGroupInfo.fromJson(jsonDecode(jsonData));
      groupName = groupInfo.groupName;
      usernameInGroup = groupInfo.usernameInGroup;
      uuid = groupInfo.uuid;
    }
    isLoaded = true;
  }

  bool isEmpty() => uuid == '';

  Future changeGroupInfo(CurrentGroupInfo groupInfo) async {
    groupName = groupInfo.groupName;
    usernameInGroup = groupInfo.usernameInGroup;
    uuid = groupInfo.uuid;

    await storage.write(
      key: CURRENT_GROUP_INFO_KEY,
      value: jsonEncode(groupInfo),
    );

    notifyListeners();
  }
}
