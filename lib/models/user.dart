class User {
  final String firstName;
  final String lastName;
  final String email;

  User.fromJson(Map json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'];
}
