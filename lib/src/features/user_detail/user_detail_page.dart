import 'package:flutter/material.dart';

import 'user_detail_controller.dart';

typedef UserDetailPageArguments = ({
  String name,
  String email,
  String role,
  int id,
});

final class UserDetailPage extends StatefulWidget {
  const UserDetailPage({
    required this.arguments,
    required this.controller,
    super.key,
  });

  final UserDetailPageArguments arguments;
  final UserDetailController controller;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

final class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    final UserDetailPage(:controller, :arguments) = widget;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.getUserDetail(arguments.id));
  }

  @override
  Widget build(BuildContext context) {
    const itemTextStyle = TextStyle(fontSize: 18);
    final UserDetailPage(:arguments, :controller) = widget;

    return Scaffold(
      appBar: AppBar(title: Text(arguments.name)),
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (__, value, _) {
          final (:status, :errorMessage, :user) = value;

          return switch (status) {
            UserDetailStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            UserDetailStatus.success => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${arguments.name}', style: itemTextStyle),
                    Text('Email: ${arguments.email}', style: itemTextStyle),
                    Text('Role: ${arguments.role}', style: itemTextStyle),
                    Text('Address: ${user.address}', style: itemTextStyle),
                    Text('Phone: ${user.phone}', style: itemTextStyle),
                  ],
                ),
              ),
            UserDetailStatus.error =>
              Center(child: Text(errorMessage ?? 'Unknown error')),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
