import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harbinger/assets/config.dart';
import 'package:harbinger/models/user.dart';
import 'package:http/http.dart' as http;

class UserRegistrationForm extends StatefulWidget {
  final int orgId;
  final int roleRefId;

  const UserRegistrationForm({
    Key? key,
    required this.orgId,
    required this.roleRefId,
  }) : super(key: key);

  @override
  _UserRegistrationFormState createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  User user = User(
    firstName: '',
    lastName: '',
    emailId: '',
    password: '',
    createdOn: DateTime.now(),
    updatedOn: DateTime.now(),
    lastLoggedIn: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) => user.firstName = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Add space between the fields
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => user.lastName = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => user.emailId = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                initialValue: 'Harbinger@123',
                onSaved: (value) => user.password = value!,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 26.0),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      Navigator.of(context).pop();
                      form.save();
                      print("orgid${widget.orgId}");
                      registerUser(widget.orgId, user, widget.roleRefId);
                      //
                      final Uri url = Uri.parse(
                          "${AppConfig.BASE_URL2}/organisation/withorgadminprojectadminprojectmember/${widget.orgId}");

                      final response = await http.get(url);
                    }
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> registerUser(int orgId, User user, int roleRefId) async {
    user.roleRefId = roleRefId;
    final response = await http.post(
      Uri.parse('${AppConfig.BASE_URL2}/user/register/$orgId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final registeredUser = User.fromJson(jsonDecode(response.body));
      print(
          'User registration successful: ${registeredUser.firstName} ${registeredUser.lastName}');
      return registeredUser;
    } else {
      final errorMessage = 'Failed to register user: ${response.statusCode}';
      print(errorMessage);
      throw Exception(errorMessage);
    }
  }
}
