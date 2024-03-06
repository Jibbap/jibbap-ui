import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jibbap/dtos/group_including_user_dto.dart';
import 'package:jibbap/dtos/user_request_dto.dart';

class UserApiService {
  // static const String baseUrl = 'http://172.16.101.124:8080/api/users';
  static const String baseUrl = 'http://192.168.45.188:8080/api/users';
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<bool> joinJibbap(UserRequestDto userRequest) async {
    final url = Uri.parse(baseUrl);
    final response =
        await http.post(url, body: jsonEncode(userRequest), headers: headers);

    return response.statusCode == 201;
  }

  static Future<bool> checkUser(String kakaoId) async {
    final url = Uri.parse('$baseUrl/$kakaoId');
    final response = await http.get(url);

    return response.statusCode == 200;
  }

  static Future<List<GroupIncludingUserDto>> getAllGroupsIncludingUser(
      String kakaoId) async {
    final url = Uri.parse('$baseUrl/$kakaoId/detail');
    final response = await http.get(url);
    List<GroupIncludingUserDto> groupsIncludingUser = [];

    if (response.statusCode == 200) {
      final groups = jsonDecode(utf8.decode(response.bodyBytes));
      for (var group in groups) {
        groupsIncludingUser.add(GroupIncludingUserDto.fromJson(group));
      }

      return groupsIncludingUser;
    }

    throw Error();
  }
}
