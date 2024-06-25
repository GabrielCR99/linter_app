import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/get_all_users_exception.dart';
import '../../core/exceptions/get_user_by_id_exception.dart';
import '../../core/rest_client/rest_client.dart';
import './user_repository.dart';

final class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl({required this.restClient});

  final RestClient restClient;

  @override
  Future<List<UserDTO>> getAll() async {
    try {
      final Response(:data) = await restClient.get<List<Object?>>('/users');

      return data?.cast<Map<String, dynamic>>().map((e) {
            final {
              'id': int id,
              'name': String name,
              'email': String email,
              'role': String role,
            } = e;

            return (id: id, name: name, email: email, role: role);
          }).toList() ??
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
  Future<UserInfoDTO> getById(int id) async {
    try {
      final Response(
        // ! We're ignoring this rule because we have a bug in
        // ! unnecesary_null_checks that is causing this to be marked
        // ! as an error see
        // ! https://github.com/dart-lang/linter/issues/4889
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
