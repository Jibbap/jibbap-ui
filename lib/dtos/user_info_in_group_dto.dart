class UserInfoInGroupDto {
  final String usernameInGroup, profileImageUrl, kakaoId;

  UserInfoInGroupDto.fromJson(Map<String, dynamic> json)
      : usernameInGroup = json['username_in_group'],
        kakaoId = json['kakao_id'],
        profileImageUrl = json['profile_image_url'];
}
