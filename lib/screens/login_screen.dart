import 'package:flutter/material.dart';
import 'package:jibbap/services/user_api_service.dart';
import 'package:provider/provider.dart';

import '../dtos/user_request_dto.dart';
import '../models/login_model.dart';
import '../widgets/jibbap_logo_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget loginButton =
      const CircularProgressIndicator(color: Color(0xFF7CC144));

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    bool isWantToLogin = loginState.isWantToLogin;
    bool isUserJoiningJibbap = loginState.isUserJoiningJibbap;
    bool isLogined = loginState.isLogined;

    if (isWantToLogin) {
      loginButton = Column(
        children: [
          const LoginButton(),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '카카오 로그인을 통해 ',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              const Text(
                'Jibbap',
                style: TextStyle(
                  color: Color(0xFF7CC144),
                ),
              ),
              Text(
                '에 가입할 수 있습니다.',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (isLogined && !isUserJoiningJibbap) {
      loginButton = const Column(
        children: [
          JibbapJoinButton(),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Jibbap', style: TextStyle(color: Color(0xFF7CC144))),
              Text('을 통해 집밥하세요'),
            ],
          ),
        ],
      );
    } else {
      loginButton = const CircularProgressIndicator(color: Color(0xFF7CC144));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  JibbapLogoWidget(),
                  Transform.translate(
                    offset: const Offset(0, 10),
                    child: const Text(
                      'Jibbap은 모든 가족의 집밥을 희망합니다.',
                      style: TextStyle(
                        color: Color(0xFFA2D183),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: loginButton,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  void onLoginTap(
    Future Function() kakaoLogin,
    Future Function() checkUserIsJoiningJibbap,
  ) async {
    await kakaoLogin();
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    return Column(
      children: [
        GestureDetector(
          onTap: () => onLoginTap(
            loginState.login,
            loginState.checkUserIsJoiningJibbap,
          ),
          child: Image.asset(
            'assets/kakao_login.png',
            width: 280,
          ),
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

class JibbapJoinButton extends StatelessWidget {
  const JibbapJoinButton({
    super.key,
  });

  Future onJoinTap(
    String kakaoId,
    String nickname,
    String profileImageUrl,
  ) async {
    UserRequestDto userRequest = UserRequestDto(
      kakao_id: kakaoId,
      profile_image_url: profileImageUrl,
      username: nickname,
    );
    bool isAccepted = await UserApiService.joinJibbap(userRequest);
    return isAccepted;
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    final kakaoId = loginState.user?.id;
    final nickname = loginState.user?.kakaoAccount?.profile?.nickname;
    final profileImageUrl =
        loginState.user?.kakaoAccount?.profile?.profileImageUrl;

    return GestureDetector(
      onTap: () async {
        bool isAccepted =
            await onJoinTap(kakaoId.toString(), nickname!, profileImageUrl!);
        if (isAccepted) {
          loginState.joinJibbap();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 280,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
        ),
        child: const Text(
          '가입',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
