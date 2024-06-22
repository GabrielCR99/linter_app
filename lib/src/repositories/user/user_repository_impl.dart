import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/get_all_users_exception.dart';
import '../../core/exceptions/get_user_by_id_exception.dart';
import '../../core/rest_client/rest_client.dart';
import '../../models/user_model.dart';
import './user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required this.restClient});

  final RestClient restClient;

  @override
  Future<List<UserModel>> getAll() async {
    try {
      // ignore: unnecessary_null_checks
      final Response(:data) = await restClient.get<List<Object?>>('/users');

      return data
              ?.cast<Map<String, dynamic>>()
              .map(UserModel.fromMap)
              .toList() ??
          const [];
    } on DioException catch (e, s) {
      log('Error on getAll', error: e, stackTrace: s);

      return Error.throwWithStackTrace(
        const GetAllUsersException(message: 'Error while fetching users'),
        s,
      );
    }
  }

  @override
  Future<UserByIdDto> getById(int id) async {
    try {
      final Response(
        // ignore: unnecessary_null_checks
        data: {'address': String address, 'phone': String phone}!
      ) = await restClient.get<Map<String, dynamic>>('/user_details/$id');

      return (address: address, phone: phone);
    } on DioException catch (e, s) {
      log('Error on getById', error: e, stackTrace: s);

      return Error.throwWithStackTrace(
        GetUserByIdException(message: 'Error while fetching user with id $id'),
        s,
      );
    }
  }
}
