class TestBlock {
  String? type;
  String? testName;
  List<String>? testTags;
  List<TestStep>? testStepsArray;

  TestBlock.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    testName = json['testName'];
    testTags = List<String>.from(json['testTags']);
    testStepsArray = List<TestStep>.from(
        json['testStepsArray'].map((stepJson) => TestStep.fromJson(stepJson)));
  }
}

class TestStep {
  String? statement;
  List<String>? tokens;
  String? humanReadableStatement;

  TestStep.fromJson(Map<String, dynamic> json) {
    statement = json['statement'];
    tokens = List<String>.from(json['tokens']);
    humanReadableStatement = json['humanReadableStatement'];
  }
}

class TestScriptModel {
  List<Map<String, dynamic>>? preTestBlock;
  List<TestBlock>? testBlockArray;

  TestScriptModel.fromJson(Map<String, dynamic> json) {
    preTestBlock = List<Map<String, dynamic>>.from(json['preTestBlock']);
    testBlockArray = List<TestBlock>.from(json['testBlockArray']
        .map((blockJson) => TestBlock.fromJson(blockJson)));
  }
}
