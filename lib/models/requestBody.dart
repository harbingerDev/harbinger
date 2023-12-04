// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RequestBodyParameter {
  String? paramkey;
  String? paramvalue;
  String? paramtype;
  bool? isFakerEnabled;
  String? fakertype;

  RequestBodyParameter({
     this.paramkey,
     this.paramvalue,
     this.paramtype,
     this.isFakerEnabled,
     this.fakertype,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paramkey': paramkey,
      'paramvalue': paramvalue,
      'paramtype': paramtype,
      'isFakerEnabled': isFakerEnabled,
      'fakertype': fakertype,
    };
  }

  factory RequestBodyParameter.fromMap(Map<String, dynamic> map) {
    return RequestBodyParameter(
      paramkey: map['paramkey'] != null ? map['paramkey'] as String : null,
      paramvalue:
          map['paramvalue'] != null ? map['paramvalue'] as String : null,
      paramtype: map['paramtype'] != null ? map['paramtype'] as String : null,
      isFakerEnabled:
          map['isFakerEnabled'] != null ? map['isFakerEnabled'] as bool : null,
      fakertype: map['fakertype'] != null ? map['fakertype'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestBodyParameter.fromJson(String source) =>
      RequestBodyParameter.fromMap(json.decode(source) as Map<String, dynamic>);

  static String listToJson(List<RequestBodyParameter> reqbodyList) {
    List<Map<String, dynamic>> jsonList = reqbodyList.map((param) => param.toMap()).toList();
    return json.encode(jsonList);
  }
}

