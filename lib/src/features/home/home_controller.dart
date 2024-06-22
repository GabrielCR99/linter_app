import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../core/exceptions/get_all_users_exception.dart';
import '../../models/user_model.dart';
import '../../repositories/user/user_repository.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  error;
}

typedef HomeState = ({
  HomeStatus status,
  String? errorMessage,
  List<UserModel> users,
});

final class HomeController extends ValueNotifier<HomeState> {
  HomeController({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(
          (status: HomeStatus.initial, errorMessage: null, users: const []),
        );

  final UserRepository _userRepository;

  Future<void> getHomeData() async {
    try {
      value = (status: HomeStatus.loading, errorMessage: null, users: const []);
      final result = await _userRepository.getAll();
      await Future<void>.delayed(const Duration(seconds: 1));
      value = (status: HomeStatus.success, errorMessage: null, users: result);
    } on GetAllUsersException catch (e, s) {
      log('Error on getHomeData', error: e, stackTrace: s);

      value =
          (status: HomeStatus.error, errorMessage: e.message, users: const []);
    }
  }
}
