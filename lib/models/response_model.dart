import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  List<RequestParameter>? reqbody;
  List<RequestParameter>? pathvariable;
  List<RequestParameter>? queryparam;
  Map<String, dynamic>? securityparameters;
  List<RequestParameter>? responseschema;

  ResponseModel({
    this.reqbody,
    this.pathvariable,
    this.queryparam,
    this.securityparameters,
    this.responseschema
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}

@JsonSerializable()
class RequestParameter {
  String name;
  String type;
  String placeholder;
  bool required;

  RequestParameter({
    required this.name,
    required this.type,
    required this.placeholder,
    required this.required,
  });

  factory RequestParameter.fromJson(Map<String, dynamic> json) =>
      _$RequestParameterFromJson(json);

  Map<String, dynamic> toJson() => _$RequestParameterToJson(this);
}
