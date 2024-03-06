import 'package:flutter/material.dart';
import 'package:jibbap/services/kakao_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import '../services/user_api_service.dart';

class LoginModel extends ChangeNotifier {
  final KakaoLogin _kakaoLogin;
  bool isLogined = false;
  bool isUserJoiningJibbap = false;
  bool isWantToLogin = false;
  User? user;

  LoginModel(this._kakaoLogin) {
    init().then((_) {
      notifyListeners();
    });
  }

  Future init() async {
    OAuthToken? oauthToken =
        await TokenManagerProvider.instance.manager.getToken();

    bool flag = oauthToken != null;

    if (flag) {
      await login();
    }
    if (!isLogined) {
      isWantToLogin = true;
    }
  }

  Future login() async {
    isLogined = await _kakaoLogin.login();
    if (isLogined) {
      user = await UserApi.instance.me();
      await checkUserIsJoiningJibbap();
      isWantToLogin = false;
    }
    notifyListeners();
  }

  Future logout() async {
    await _kakaoLogin.logout();
    isLogined = false;
    user = null;
    isWantToLogin = true;
    notifyListeners();
  }

  Future checkUserIsJoiningJibbap() async {
    isUserJoiningJibbap = await UserApiService.checkUser(user!.id.toString());
    notifyListeners();
  }

  void joinJibbap() {
    isUserJoiningJibbap = true;
    notifyListeners();
  }
}
