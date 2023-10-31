
import 'package:json_annotation/json_annotation.dart';


class Endpoint {
  final String path;
  final  String httpMethod;

  Endpoint({
    required this.path,
    required this.httpMethod,
  });

  factory Endpoint.fromJson(Map<String, dynamic> json) {
    return Endpoint(
      path: json['path'],
      httpMethod: json['http_method'],
    );
  }
}

