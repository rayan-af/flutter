enum UserRole {
  manager,
  employee,
  customer,
  reception,
  chef,
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? imageUrl;
  final UserRole role;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.imageUrl,
    required this.role,
  });
}
