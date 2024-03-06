class UserRequestDto {
  final String kakao_id, profile_image_url, username;

  UserRequestDto({
    required this.kakao_id,
    required this.profile_image_url,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'kakao_id': kakao_id,
      'profile_image_url': profile_image_url,
      'username': username
    };
  }
}
