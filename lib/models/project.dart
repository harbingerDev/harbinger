class Project {
  int? id;
  String? projectName;
  String? projectPath;
  int? defaultTimeout;
  String? environments;
  String? parallelExecution;
  String? browsers;

  Project(
      {this.id,
      this.projectName,
      this.projectPath,
      this.defaultTimeout,
      this.environments,
      this.parallelExecution,
      this.browsers});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['project_name'];
    projectPath = json['project_path'];
    defaultTimeout = json['default_timeout'];
    environments = json['environments'];
    parallelExecution = json['parallel_execution'];
    browsers = json['browsers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_name'] = this.projectName;
    data['project_path'] = this.projectPath;
    data['default_timeout'] = this.defaultTimeout;
    data['environments'] = this.environments;
    data['parallel_execution'] = this.parallelExecution;
    data['browsers'] = this.browsers;
    return data;
  }
}
