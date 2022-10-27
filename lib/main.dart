// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harbinger/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harbinger - your own automation copilot',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showLogin = false;
  bool authenticated = false;
  void showLoginBox() {
    setState(() {
      showLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
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
      ),
      appBar: AppBar(
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
      ),
      backgroundColor: Color(0xFFE8E8E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * .9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
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
                              : ElevatedButton(
                                  onPressed: () => {showLoginBox()},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff285981),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    textStyle: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  child: Text("Get started"),
                                )
                        ],
                      ),
                    ),
                    showLogin
                        ? LoginScreen()
                        : Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .45,
                            child: Image.asset("assets/images/launch.png"),
                          )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
