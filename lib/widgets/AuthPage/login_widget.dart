// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/screens/dashboard_screen.dart';

import '../../helpers/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Harbinger",
          style:
              GoogleFonts.yanoneKaffeesatz(fontSize: 50, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(15)),
          width: MediaQuery.of(context).size.width * .35,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * .30,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text(
                        "Username",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    expands: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      label: Text(
                        "Password",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    expands: false,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final message = await AuthService().login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (message!.contains('Success')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(message),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(message),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Do not have login id? Please reach out to us at",
          style: GoogleFonts.roboto(color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "harbinger@feuji.com",
          style: GoogleFonts.roboto(color: Color(0xffE95622)),
        )
      ],
    );
  }
}
