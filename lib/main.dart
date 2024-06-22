import 'package:flutter/material.dart';

import 'src/core/rest_client/rest_client.dart';
import 'src/features/home/home_controller.dart';
import 'src/features/home/home_page.dart';
import 'src/features/user_detail/user_detail_controller.dart';
import 'src/features/user_detail/user_detail_page.dart';
import 'src/repositories/user/user_repository_impl.dart';

void main() {
  final restClient = RestClient(baseUrl: 'http://localhost:8080/');
  final userRepository = UserRepositoryImpl(restClient: restClient);
  final homeController = HomeController(userRepository: userRepository);
  final userDetailController =
      UserDetailController(userRepository: userRepository);

  // print('foo');

  return runApp(
    MainApp(
      homeController: homeController,
      userDetailController: userDetailController,
    ),
  );
}

final class MainApp extends StatelessWidget {
  const MainApp({
    required this.homeController,
    required this.userDetailController,
    super.key,
  });

  final HomeController homeController;
  final UserDetailController userDetailController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(controller: homeController),
      routes: {
        '/user_detail': (context) => UserDetailPage(
              arguments: ModalRoute.of(context)!.settings.arguments!
                  as UserDetailPageArguments,
              controller: userDetailController,
            ),
      },
    );
  }
}
