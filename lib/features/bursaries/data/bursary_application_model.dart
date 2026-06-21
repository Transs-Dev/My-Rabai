class BursaryApplicationModel {
  final String id;
  final String fullName;
  final String idNumber;
  final String phoneNumber;
  final String institutionName;
  final String admissionNumber;
  final String academicYear;
  final String semester;
  final String idUrl;
  final String admissionLetterUrl;
  final String feeStructureUrl;
  final String selfieUrl;
  final String status;
  final DateTime createdAt;
  final String? bursaryTitle;

  BursaryApplicationModel({
    required this.id,
    required this.fullName,
    required this.idNumber,
    required this.phoneNumber,
    required this.institutionName,
    required this.admissionNumber,
    required this.academicYear,
    required this.semester,
    required this.idUrl,
    required this.admissionLetterUrl,
    required this.feeStructureUrl,
    required this.selfieUrl,
    required this.status,
    required this.createdAt,
    this.bursaryTitle,
  });

  factory BursaryApplicationModel.fromJson(Map<String, dynamic> json) {
    final bursaryData = json['bursaries'] as Map<String, dynamic>?;
    final title = bursaryData != null ? bursaryData['title'] as String? : 'Bursary Scheme';

    return BursaryApplicationModel(
      id: json['id'] as String,
      fullName: json['full_name'] ?? '',
      idNumber: json['id_number'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      institutionName: json['institution_name'] as String,
      admissionNumber: json['admission_number'] as String,
      academicYear: json['academic_year'] ?? '',
      semester: json['semester'] ?? '',
      idUrl: json['id_url'] ?? '',
      admissionLetterUrl: json['admission_letter_url'] ?? '',
      feeStructureUrl: json['fee_structure_url'] ?? '',
      selfieUrl: json['selfie_url'] ?? '',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      bursaryTitle: title,
    );
  }
}