import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Greetings extends StatelessWidget {
  const Greetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.brightness_2_outlined, color: Colors.black87),
        SizedBox(width: 10),
        Text(
          "Good ",
          style: GoogleFonts.roboto(fontSize: 20, color: Colors.black87),
        ),
        Text(
          greeting(),
          style: GoogleFonts.roboto(fontSize: 20, color: Colors.black87),
        ),
        Text(
          "!",
          style: GoogleFonts.roboto(fontSize: 20, color: Colors.black87),
        )
      ],
    );
  }
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}
