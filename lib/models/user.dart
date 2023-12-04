 
import 'dart:convert';
 
class User {
  int userId;
  String firstName;
  String lastName;
  String emailId;
  String password;
  String createdBy;
  String updatedBy;
  DateTime createdOn;
  DateTime updatedOn;
  DateTime lastLoggedIn;
  bool status;
  int roleRefId;
 
  User({
    this.userId = 0,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.password,
    this.createdBy = '',
    this.updatedBy = '',
    required this.createdOn,
    required this.updatedOn,
    required this.lastLoggedIn,
    this.status = false,
    this.roleRefId = 0,
  });
 
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      emailId: map['email_id'],
      password: map['password'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      createdOn: DateTime.parse(map['created_on']),
      updatedOn: DateTime.parse(map['updated_on']),
      lastLoggedIn: DateTime.parse(map['last_logedin']),
      status: map['status'],
      roleRefId: map['role_ref_id'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email_id': emailId,
      'password': password,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_on': createdOn.toIso8601String(),
      'updated_on': updatedOn.toIso8601String(),
      'last_logedin': lastLoggedIn.toIso8601String(),
      'status': status,
      'role_ref_id': roleRefId,
    };
  }
 
 
 
  @override
  String toString() {
    return 'User{userId: $userId, firstName: $firstName, lastName: $lastName, emailId: $emailId, password: $password, roleRefId: $roleRefId}';
  }
}
 
List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}
 
String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
 
