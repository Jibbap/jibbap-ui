import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin {
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken oAuthToken;
      if (isInstalled) {
        try {
          oAuthToken = await UserApi.instance.loginWithKakaoTalk();
        } catch (e) {
          return false;
        }
      } else {
        try {
          oAuthToken = await UserApi.instance.loginWithKakaoAccount();
        } catch (e) {
          return false;
        }
      }
      await TokenManagerProvider.instance.manager.setToken(oAuthToken);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await UserApi.instance.logout();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
