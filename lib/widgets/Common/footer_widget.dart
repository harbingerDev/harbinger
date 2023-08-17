// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .03,
      width: double.infinity,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered by",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            "Feuji Inc.",
            style: TextStyle(
                fontSize: 14,
                color: Color(0xffE95622),
                fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }
}
