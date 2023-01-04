class TestStructure {
  String? testName;
  List<Steps>? steps;

  TestStructure({this.testName, this.steps});

  TestStructure.fromJson(Map<String, dynamic> json) {
    testName = json['testName'];
    if (json['steps'] != null) {
      steps = <Steps>[];
      json['steps'].forEach((v) {
        steps!.add(new Steps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['testName'] = this.testName;
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Steps {
  String? stepName;
  String? action;
  String? operatedOn;
  List<Strategies>? strategies;

  Steps({this.stepName, this.action, this.operatedOn, this.strategies});

  Steps.fromJson(Map<String, dynamic> json) {
    stepName = json['stepName'];
    action = json['action'];
    operatedOn = json['operatedOn'];
    if (json['strategies'] != null) {
      strategies = <Strategies>[];
      json['strategies'].forEach((v) {
        strategies!.add(new Strategies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stepName'] = this.stepName;
    data['action'] = this.action;
    data['operatedOn'] = this.operatedOn;
    if (this.strategies != null) {
      data['strategies'] = this.strategies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Strategies {
  String? strategy;
  String? value;

  Strategies({this.strategy, this.value});

  Strategies.fromJson(Map<String, dynamic> json) {
    strategy = json['strategy'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['strategy'] = this.strategy;
    data['value'] = this.value;
    return data;
  }
}
