// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/screens/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Color(0xff285981),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: MediaQuery.of(context).size.width * .45,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * .30,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "username",
                    focusColor: Color(0xff285981),
                  ),
                  cursorColor: Color(0xff285981),
                  expands: false,
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "password",
                    focusColor: Color(0xff285981),
                  ),
                  cursorColor: Color(0xff285981),
                  expands: false,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DashboardScreen()))
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff285981),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.normal),
                  ),
                  child: Text("Login"),
                ),
                SizedBox(
                  height: 30,
                ),
              ]),
            ),
          ),
        ));
  }
}
