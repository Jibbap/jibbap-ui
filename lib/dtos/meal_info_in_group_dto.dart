import 'package:jibbap/dtos/user_info_with_meal_in_group_dto.dart';

class MealInfoInGroupDto {
  final String groupName;
  final List<UserInfoWithMealInGroupDto> userInfos;
  static MealInfoInGroupDto emptyMealInfo =
      MealInfoInGroupDto(groupName: '', userInfos: []);

  bool isEmpty() => groupName == '';

  MealInfoInGroupDto({required this.groupName, required this.userInfos});

  MealInfoInGroupDto.fromJson(Map<String, dynamic> json)
      : groupName = json['group_name'],
        userInfos = (json['user_infos'] as List)
            .map((e) => UserInfoWithMealInGroupDto.fromJson(e))
            .toList();
}
