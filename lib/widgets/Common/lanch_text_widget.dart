// ignore_for_file: prefer_const_constructors

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaunchText extends StatelessWidget {
  const LaunchText(
      {super.key, required this.showLogin, required this.showLoginBox});
  final bool showLogin;
  final VoidCallback showLoginBox;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EasyRichText(
            "Launch fast!",
            defaultStyle: GoogleFonts.roboto(
              fontSize: 75,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Color(0xff285981),
            ),
            textAlign: TextAlign.left,
          ),
          EasyRichText(
            "Real fast!",
            defaultStyle: GoogleFonts.roboto(
              fontSize: 95,
              fontWeight: FontWeight.bold,
              color: Color(0xff285981),
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .30,
            child: Text(
              "Choose your tool, language, CI tool and we get you started in no time. We help you create tests, manage the way it is being written, gauging it's effectiveness and tracking the minutest of details all at one place. That too with more than 50% of effort and time saving. That's our promise.",
              style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff285981)),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          showLogin
              ? Container()
              : ElevatedButton.icon(
                  onPressed: () => {showLoginBox()},
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Color(0xff285981),
                  //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //   textStyle: GoogleFonts.roboto(
                  //       fontSize: 18,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.normal),
                  // ),
                  label: Text("Get started"),
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                )
        ],
      ),
    );
  }
}
