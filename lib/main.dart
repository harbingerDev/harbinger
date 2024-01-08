// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harbinger/firebase_options.dart';
import 'package:harbinger/models/projects.dart';
import 'package:harbinger/models/testScriptModel.dart';
import 'package:harbinger/screens/auth_screen.dart';
import 'package:harbinger/screens/dashboard_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaru/yaru.dart';
import 'widgets/Common/footer_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final screenProvider = StateProvider<String>((ref) => "Nothing");
final roleBasedNavigatorProvider = StateProvider<String>((ref) => "Nothing");
final filePathProvider = StateProvider<String>((ref) => "Nothing");
final selectedTabProvider = StateProvider<int>((ref) => 0);
final godJSONProvider = StateProvider<TestScriptModel?>((ref) => null);
final apiTestScriptProvider = StateProvider<ApiTest?>((ref) => null);

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.windows);
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectsAdapter());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(builder: (context, yaru, child) {
      return Consumer(builder: (context, ref, child) {
        return MaterialApp(
          theme: yaru.theme,
          darkTheme: yaru.darkTheme,
          debugShowCheckedModeBanner: false,
          title: 'Harbinger - your own automation copilot',
          home: FutureBuilder(
            future: isLoggedin(ref),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                if (snapshot.data == true) {
                  return DashboardScreen();
                } else {
                  return const MyHomePage(
                      title: 'Harbinger - your own automation copilot');
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      });
    });
  }

  static Future<bool> isLoggedin(ref) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("token");
    final role = sharedPreferences.getString("role");
    ref.read(roleBasedNavigatorProvider.notifier).state = role;

    if (token != null) {
      final tokenData = jsonDecode(
          ascii.decode(base64.decode(base64.normalize(token.split(".")[1]))));
      final int expirySeconds = tokenData['exp'];
      final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Check if the token is expired
      if (currentTime < expirySeconds) {
        return true; // Token is valid
      } else {
        sharedPreferences.clear(); //expired token removed.
      }
    }
    return false; // Token is invalid or not found
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
      body: Center(child: AuthScreen()),
    );
  }
}
