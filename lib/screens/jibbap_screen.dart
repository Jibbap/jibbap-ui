import 'package:flutter/material.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';
import 'login_screen.dart';

class JibbapScreen extends StatelessWidget {
  const JibbapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginModel>(
      builder: (context, provider, child) {
        bool isUserJoiningJibbap = provider.isUserJoiningJibbap;
        return isUserJoiningJibbap ? const MainScreen() : const LoginScreen();
      },
    );
  }
}
