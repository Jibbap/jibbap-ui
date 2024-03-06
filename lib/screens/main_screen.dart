import 'package:flutter/material.dart';
import 'package:jibbap/enums/LogoSizeType.dart';
import 'package:jibbap/models/current_user_info_model.dart';
import 'package:jibbap/models/login_model.dart';
import 'package:jibbap/screens/home_screen.dart';
import 'package:jibbap/screens/setting_screen.dart';
import 'package:jibbap/widgets/jibbap_logo_widget.dart';
import 'package:provider/provider.dart';

import 'home_menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuTap() {
    var currentGroupInfoState = context.read<CurrentGroupInfoModel>();
    String uuid = currentGroupInfoState.uuid;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeMenuScreen(uuid: uuid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var loginState = context.watch<LoginModel>();
    String kakaoId = loginState.user!.id.toString();
    Widget screen;
    Widget? floatingActionButton;
    AppBar? appBar;
    if (_selectedIndex == 0) {
      screen = const HomeScreen();
      appBar = homeAppBar();
      floatingActionButton = floatingButton();
    } else {
      screen = const SettingScreen();
      appBar = null;
      floatingActionButton = null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: screen,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        notchMargin: 11,
        height: 70,
        shape: const CircularNotchedRectangle(),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            navigateButton(0, Icons.home_rounded, 'Home'),
            const Spacer(),
            navigateButton(1, Icons.settings_rounded, 'Settings'),
          ],
        ),
      ),
    );
  }

  IconButton navigateButton(int index, IconData iconData, String tooltip) {
    return IconButton(
      onPressed: () => _onItemTap(index),
      icon: Icon(
        iconData,
        color: index == _selectedIndex ? const Color(0xFF7CC144) : Colors.grey,
        size: 30,
      ),
      tooltip: tooltip,
    );
  }

  Widget? floatingButton() {
    return SizedBox(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        foregroundColor: Colors.black,
        onPressed: () {},
        tooltip: 'Create',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        splashColor: Colors.grey[400],
        child: const Icon(Icons.edit_calendar),
      ),
    );
  }

  AppBar homeAppBar() {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();
    bool isCurrentGroupEmpty = currentGroupInfoState.isEmpty();
    return AppBar(
      elevation: 1,
      foregroundColor: const Color(0xFF7CC144),
      title: JibbapLogoWidget(
        size: LogoSizeType.tiny,
      ),
      actions: isCurrentGroupEmpty
          ? null
          : [
              IconButton(
                onPressed: _onMenuTap,
                icon: const Icon(Icons.menu_rounded),
                color: Colors.grey.shade600,
              ),
            ],
    );
  }
}
