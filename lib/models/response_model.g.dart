// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      reqbody: (json['reqbody'] as List<dynamic>?)
          ?.map((e) => RequestParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      pathvariable: (json['pathvariable'] as List<dynamic>?)
          ?.map((e) => RequestParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      queryparam: (json['queryparam'] as List<dynamic>?)
          ?.map((e) => RequestParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      securityparameters: json['securityparameters'] as Map<String, dynamic>?,
      extrasecurityparameters: (json['extrasecurityparameters'] as List<dynamic>?)
          ?.map((e) => RequestParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
      responseschema: (json['responseschema'] as List<dynamic>?)
          ?.map((e) => RequestParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'reqbody': instance.reqbody,
      'pathvariable': instance.pathvariable,
      'queryparam': instance.queryparam,
      'securityparameters': instance.securityparameters,
      'extrasecurityparameters': instance.extrasecurityparameters,
      'responseschema': instance.responseschema,
    };

RequestParameter _$RequestParameterFromJson(Map<String, dynamic> json) =>
    RequestParameter(
      name: json['name'] as String?,
      type: json['type'] as String?,
      placeholder: json['placeholder'] as String?,
      required: json['required'] as bool?,
    );

Map<String, dynamic> _$RequestParameterToJson(RequestParameter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'placeholder': instance.placeholder,
      'required': instance.required,
    };
