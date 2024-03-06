class UserInfoWithMealInGroupDto {
  final String usernameInGroup, profileImageUrl, kakaoId, isJibbap;

  UserInfoWithMealInGroupDto.fromJson(Map<String, dynamic> json)
      : usernameInGroup = json['username_in_group'],
        profileImageUrl = json['profile_image_url'],
        kakaoId = json['kakao_id'],
        isJibbap = json['is_jibbap'];
}
