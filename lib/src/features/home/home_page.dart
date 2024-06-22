import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import 'home_controller.dart';

final class HomePage extends StatefulWidget {
  const HomePage({required this.controller, super.key});

  final HomeController controller;

  @override
  State<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.controller.getHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: ValueListenableBuilder(
        valueListenable: widget.controller,
        builder: (_, value, __) {
          final (:status, :errorMessage, :users) = value;

          return switch (status) {
            HomeStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            HomeStatus.success => ListView.builder(
                itemBuilder: (_, index) {
                  final UserModel(:id, :name, :email, :role) = users[index];

                  return ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                    onTap: () => Navigator.of(context).pushNamed<void>(
                      '/user_detail',
                      arguments: (name: name, email: email, role: role, id: id),
                    ),
                  );
                },
                itemCount: users.length,
              ),
            HomeStatus.error =>
              Center(child: Text(errorMessage ?? 'Unknown error')),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
