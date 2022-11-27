// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:harbinger/models/projects.dart';
import 'package:harbinger/screens/login_screen.dart';
import 'package:harbinger/widgets/footer_widget.dart';
import 'package:harbinger/widgets/lanch_text_widget.dart';
import 'package:harbinger/widgets/launch_app_bar_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectsAdapter());
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
      bottomSheet: Footer(),
      appBar: AppbarLaunch(),
      backgroundColor: Color(0xFFE8E8E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    LaunchText(
                      showLogin: showLogin,
                      showLoginBox: showLoginBox,
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
