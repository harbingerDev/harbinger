class AnalysisResult {
  String result;
  Map<String, int> languages;
  String maxLanguage;

  AnalysisResult({required this.result, required this.languages, required this.maxLanguage});

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      result: json['result'],
      languages: Map<String, int>.from(json['languages']),
      maxLanguage: json['maxLanguage'],
    );
  }
}
