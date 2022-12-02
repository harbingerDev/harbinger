// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      height: MediaQuery.of(context).size.height * .03,
      width: double.infinity,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered by",
            style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            "Feuji Inc.",
            style: GoogleFonts.roboto(
                fontSize: 14,
                color: Color(0xffE95622),
                fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }
}
