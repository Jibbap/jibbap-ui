import 'package:flutter/material.dart';
import 'package:jibbap/dtos/meal_info_in_group_dto.dart';
import 'package:jibbap/screens/create_group_screen.dart';
import 'package:jibbap/screens/join_group_screen.dart';
import 'package:jibbap/services/group_api_service.dart';
import 'package:provider/provider.dart';

import '../models/current_user_info_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentGroupInfoState = context.watch<CurrentGroupInfoModel>();

    if (!currentGroupInfoState.isLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF7CC144),
        ),
      );
    } else if (currentGroupInfoState.isEmpty()) {
      return const EmptyWidget();
    }
    return MealWidget(
      uuid: currentGroupInfoState.uuid,
    );
  }
}

class MealWidget extends StatefulWidget {
  String uuid;
  MealWidget({super.key, required this.uuid});

  @override
  State<MealWidget> createState() => _MealWidgetState();
}

class _MealWidgetState extends State<MealWidget> {
  late Future<MealInfoInGroupDto> mealInfoInGroup;

  @override
  void initState() {
    super.initState();
    mealInfoInGroup = GroupApiService.getMealInfoInGroup(uuid: widget.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mealInfoInGroup,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Row(
                children: [
                  Text(
                    snapshot.data!.groupName,
                    style: const TextStyle(fontSize: 28),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('', style: TextStyle(fontSize: 18)),
                  Text('아침', style: TextStyle(fontSize: 18)),
                  Text('점심', style: TextStyle(fontSize: 18)),
                  Text('저녁', style: TextStyle(fontSize: 18)),
                ],
              )
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7CC144),
          ),
        );
      },
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  onNavigateButtonTap(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('현재 포함된 그룹이 없네요.'),
          const Text('새로운 그룹을 만들거나 기존의 그룹에 가입해주세요.'),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onNavigateButtonTap(
                  context,
                  const CreateGroupScreen(),
                ),
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF7CC144)),
                ),
                child: const Text('그룹 만들기'),
              ),
              ElevatedButton(
                onPressed: () =>
                    onNavigateButtonTap(context, const JoinGroupScreen()),
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF7CC144)),
                ),
                child: const Text('그룹 가입하기'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
