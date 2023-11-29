class Organisation {
  int? orgId;
  String? orgName;
  String? orgCode;
  String? orgDesc;
  DateTime? orgStartDate;
  DateTime? orgEndDate;
  String? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdOn;
  DateTime? updatedOn;
 
  Organisation({
    this.orgId,
    this.orgName,
    this.orgCode,
    this.orgDesc,
    this.orgStartDate,
    this.orgEndDate,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdOn,
    this.updatedOn,
  });
 
  Organisation.fromJson(Map<String, dynamic> json) {
    orgId = json['org_id'];
    orgName = json['org_name'];
    orgCode = json['org_code'];
    orgDesc = json['org_desc'];
    orgStartDate = DateTime.parse(json['org_start_date']);
    orgEndDate = DateTime.parse(json['org_end_date']);
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdOn = DateTime.parse(json['created_on']);
    updatedOn = DateTime.parse(json['updated_on']);
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'org_id': orgId,
      'org_name': orgName,
      'org_code': orgCode,
      'org_desc': orgDesc,
      'org_start_date': orgStartDate?.toIso8601String(),
      'org_end_date': orgEndDate?.toIso8601String(),
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_on': createdOn?.toIso8601String(),
      'updated_on': updatedOn?.toIso8601String(),
    };
 
    return data;
  }
}