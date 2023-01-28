class CodeStructure {
  String? name;
  List<String>? tags;
  List<Statements>? statements;
  int? start;
  int? end;

  CodeStructure({this.name, this.tags, this.statements, this.start, this.end});

  CodeStructure.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tags = json['tags'].cast<String>();
    if (json['statements'] != null) {
      statements = <Statements>[];
      json['statements'].forEach((v) {
        statements!.add(new Statements.fromJson(v));
      });
    }
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tags'] = this.tags;
    if (this.statements != null) {
      data['statements'] = this.statements!.map((v) => v.toJson()).toList();
    }
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class Statements {
  String? type;
  int? start;
  int? end;

  Statements({this.type, this.start, this.end});

  Statements.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
