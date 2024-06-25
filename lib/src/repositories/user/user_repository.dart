typedef UserInfoDTO = ({String phone, String address});
typedef UserDTO = ({int id, String name, String email, String role});

abstract interface class UserRepository {
  Future<List<UserDTO>> getAll();
  Future<UserInfoDTO> getById(int id);
}
