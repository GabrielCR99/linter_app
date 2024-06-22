import '../../models/user_model.dart';

typedef UserByIdDto = ({String phone, String address});

abstract interface class UserRepository {
  Future<List<UserModel>> getAll();
  Future<UserByIdDto> getById(int id);
}
