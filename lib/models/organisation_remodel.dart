class Organisationremodel {
  int orgId;
  String orgName;
  String orgCode;
  String orgDesc;
  DateTime orgStartDate;
  DateTime orgEndDate;
  String status;
  String createdBy;
  String updatedBy;
  DateTime createdOn;
  DateTime updatedOn;
  List<OrganisationAdmin> orgAdmins;
  List<ProjectAdmin> projectAdmins;
  List<ProjectMember> projectMembers;
 
  Organisationremodel({
    this.orgId = 0,
    required this.orgName,
    this.orgCode = '',
    this.orgDesc = '',
    required this.orgStartDate,
    required this.orgEndDate,
    this.status = '',
    this.createdBy = '',
    this.updatedBy = '',
    required this.createdOn,
    required this.updatedOn,
    required this.orgAdmins,
    required this.projectAdmins,
    required this.projectMembers,
  });
 
  factory Organisationremodel.fromJson(Map<String, dynamic> map) {
    return Organisationremodel(
      orgId: map['org_id'] ?? 0,
      orgName: map['org_name'] ?? '',
      orgCode: map['org_code'] ?? '',
      orgDesc: map['org_desc'] ?? '',
      orgStartDate: DateTime.parse(map['org_start_date'] ?? '1970-01-01T00:00:00.000Z'),
      orgEndDate: DateTime.parse(map['org_end_date'] ?? '1970-01-01T00:00:00.000Z'),
      status: map['status'] ?? '',
      createdBy: map['created_by'] ?? '',
      updatedBy: map['updated_by'] ?? '',
      createdOn: DateTime.parse(map['created_on'] ?? '1970-01-01T00:00:00.000Z'),
      updatedOn: DateTime.parse(map['updated_on'] ?? '1970-01-01T00:00:00.000Z'),
      orgAdmins: List<OrganisationAdmin>.from(map['org_admin']?.map((item){
        print("items of orgAdmins$item");
        return OrganisationAdmin.fromJson(item);
      }) ?? []),
      projectAdmins: List<ProjectAdmin>.from(map['project_admin']?.map((item) => ProjectAdmin.fromJson(item)) ?? []),
      projectMembers: List<ProjectMember>.from(map['project_members']?.map((item) => ProjectMember.fromJson(item)) ?? []),
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'org_id': orgId,
      'org_name': orgName,
      'org_code': orgCode,
      'org_desc': orgDesc,
      'org_start_date': orgStartDate.toIso8601String(),
      'org_end_date': orgEndDate.toIso8601String(),
      'status': status,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_on': createdOn.toIso8601String(),
      'updated_on': updatedOn.toIso8601String(),
      'orgAdmins': orgAdmins.map((admin) => admin.toJson()).toList(),
      'projectAdmins': projectAdmins.map((admin) => admin.toJson()).toList(),
      'projectMembers': projectMembers.map((member) => member.toJson()).toList(),
    };
  }
}
 
 
 
 
class OrganisationAdmin {
  int orgAdminId;
  String emailId;
  int? orgRefId;
 
  OrganisationAdmin({
    this.orgAdminId = 0,
    required this.emailId,
    required this.orgRefId,
  });
 
  factory OrganisationAdmin.fromJson(Map<String, dynamic> map) {
    return OrganisationAdmin(
      orgAdminId: map['org_admin_id'],
      emailId: map['email_id'],
      orgRefId: map['org_ref_id'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'org_admin_id': orgAdminId,
      'email_id': emailId,
      'org_ref_id': orgRefId,
    };
  }
}
 
class ProjectAdmin {
  int projectAdminId;
  String emailId;
  int? orgRefId;
 
  ProjectAdmin({
    this.projectAdminId = 0,
    required this.emailId,
    required this.orgRefId,
  });
 
  factory ProjectAdmin.fromJson(Map<String, dynamic> map) {
    return ProjectAdmin(
      projectAdminId: map['project_admin_id'],
      emailId: map['email_id'],
      orgRefId: map['org_ref_id'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'project_admin_id': projectAdminId,
      'email_id': emailId,
      'org_ref_id': orgRefId,
    };
  }
}
 
class ProjectMember {
  int projectMemberId;
  String emailId;
  int? orgRefId;
  int? projectAdminRefId;
 
  ProjectMember({
    this.projectMemberId = 0,
    required this.emailId,
    required this.orgRefId,
    required this.projectAdminRefId,
  });
 
  factory ProjectMember.fromJson(Map<String, dynamic> map) {
    return ProjectMember(
      projectMemberId: map['project_member_id'],
      emailId: map['email_id'],
      orgRefId: map['org_ref_id'],
      projectAdminRefId: map['project_admin_ref_id'],
    );
  }
 
  Map<String, dynamic> toJson() {
    return {
      'project_member_id': projectMemberId,
      'email_id': emailId,
      'org_ref_id': orgRefId,
      'project_admin_ref_id': projectAdminRefId,
    };
  }
}
 