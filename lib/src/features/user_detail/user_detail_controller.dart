import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../core/exceptions/get_user_by_id_exception.dart';
import '../../repositories/user/user_repository.dart';

enum UserDetailStatus {
  initial,
  loading,
  success,
  error;
}

typedef UserDetailState = ({
  UserDetailStatus status,
  String? errorMessage,
  UserInfoDTO user,
});

const _emptyUser = (address: '', phone: '');

final class UserDetailController extends ValueNotifier<UserDetailState> {
  UserDetailController({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(
          const (
            status: UserDetailStatus.initial,
            errorMessage: null,
            user: _emptyUser,
          ),
        );

  final UserRepository _userRepository;

  Future<void> getUserDetail(int id) async {
    try {
      value = (
        status: UserDetailStatus.loading,
        errorMessage: null,
        user: _emptyUser,
      );
      final user = await _userRepository.getById(id);
      await Future<void>.delayed(const Duration(seconds: 1));
      value =
          (status: UserDetailStatus.success, errorMessage: null, user: user);
    } on GetUserByIdException catch (e, s) {
      log('Error on getUserDetail', error: e, stackTrace: s);
      value = (
        status: UserDetailStatus.error,
        errorMessage: e.message,
        user: _emptyUser,
      );
    }
  }
}
