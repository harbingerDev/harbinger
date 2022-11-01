// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff285981),
      height: MediaQuery.of(context).size.height * .02,
      width: double.infinity,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.copyright_outlined, size: 12, color: Colors.white),
          SizedBox(
            width: 2,
          ),
          Text(
            "Feuji Inc.",
            style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        ],
      )),
    );
  }
}
