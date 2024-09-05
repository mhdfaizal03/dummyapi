class UserModel {
  final String id;
  final String title;
  final String firstName;
  final String lastName;
  final String picture;

  UserModel(
      {required this.id,
      required this.title,
      required this.firstName,
      required this.lastName,
      required this.picture});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      title: json['title'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      picture: json['picture'],
    );
  }
}
