import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jibbap/dtos/group_info_dto.dart';
import 'package:jibbap/dtos/group_request_dto.dart';
import 'package:jibbap/dtos/meal_info_in_group_dto.dart';

class GroupApiService {
  // static const String baseUrl = 'http://172.16.101.124:8080/api/groups';
  static const String baseUrl = 'http://192.168.45.188:8080/api/groups';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<bool> createGroup(GroupRequestDto groupRequestDto) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: jsonEncode(groupRequestDto),
      headers: headers,
    );

    return response.statusCode == 201;
  }

  static Future<GroupInfoDto> getGroupInfo({required String uuid}) async {
    final url = Uri.parse('$baseUrl/$uuid/user-info');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 404) {
      return GroupInfoDto.emptyGroupInfo;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    GroupInfoDto groupInfo = GroupInfoDto.fromJson(json);
    return groupInfo;
  }

  static Future<bool> joinGroup({
    required String uuid,
    required String kakaoId,
    required String usernameInGroup,
  }) async {
    final url = Uri.parse('$baseUrl/$uuid/users/$kakaoId');
    var body = jsonEncode({'username_in_group': usernameInGroup});
    final response = await http.post(url, body: body, headers: headers);

    return response.statusCode == 204;
  }

  static Future<bool> changeUsernameInGroup({
    required String uuid,
    required String kakaoId,
    required String usernameInGroup,
  }) async {
    final url = Uri.parse('$baseUrl/$uuid/users/$kakaoId');
    var body = jsonEncode({'username_in_group': usernameInGroup});
    final response = await http.put(url, body: body, headers: headers);
    return response.statusCode == 204;
  }

  static Future<MealInfoInGroupDto> getMealInfoInGroup({
    required String uuid,
  }) async {
    final url = Uri.parse('$baseUrl/$uuid/meal-info');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 404) {
      return MealInfoInGroupDto.emptyMealInfo;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    MealInfoInGroupDto mealInfoInGroup = MealInfoInGroupDto.fromJson(json);
    return mealInfoInGroup;
  }
}
