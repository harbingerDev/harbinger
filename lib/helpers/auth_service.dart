// import 'package:firebase_auth/firebase_auth.dart';
// class AuthService {
//   Future<String?> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return 'Success';
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         return 'Wrong password provided for that user.';
//       } else {
//         return e.message;
//       }
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }

// AuthService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
 
class AuthService {
  final String baseUrl;
 
  AuthService(this.baseUrl);
 
  Future<Map<String, dynamic>?> login({
    required String email_id,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email_id": email_id, "password": password}),
      );
 
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return data;
        } catch (e) {
          print('Error decoding JSON: $e');
          return null;
        }
      } else {
        // Print the response body for debugging
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle network or other errors
      print('Login failed: $e');
      return null;
    }
  }
}
