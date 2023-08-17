// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarLaunch extends StatelessWidget implements PreferredSizeWidget {
  const AppbarLaunch({super.key});
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 40,
      leading: Icon(Icons.rocket_launch, color: Color(0xff285981)),
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        "HARBINGER",
        style: GoogleFonts.roboto(
            fontSize: 18,
            color: Color(0xff285981),
            fontWeight: FontWeight.bold),
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.app_registration_outlined,
                        color: Color(0xff285981), size: 15),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Sign up",
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Color(0xff285981),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: Color(0xff285981),
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Help",
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Color(0xff285981),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
