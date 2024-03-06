import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/screens/jibbap_screen.dart';
import 'package:jibbap/services/kakao_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: "${dotenv.env['NATIVE_APP_KEY']}");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginModel(KakaoLogin()),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentGroupInfoModel(),
        ),
      ],
      child: const JibbapApp(),
    ),
  );
}

class JibbapApp extends StatelessWidget {
  const JibbapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jibbap',
      theme: ThemeData(
        cardColor: const Color(0xFF7CC144),
        useMaterial3: true,
      ),
      home: const JibbapScreen(),
    );
  }
}
