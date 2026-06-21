import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_rabai/features/bursaries/data/bursary_application_model.dart'; 

final bursarySubmitProvider = Provider((ref) {
  return BursarySubmitService();
});

final myApplicationsStreamProvider = StreamProvider.autoDispose<List<BursaryApplicationModel>>((ref) {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) {
    return Stream.value([]);
  }

  return supabase
      .from('bursary_applications')
      .stream(primaryKey: ['id'])
      .eq('applicant_id', user.id)
      .order('created_at', ascending: false)
      .asyncMap((snapshot) async {
        if (snapshot.isEmpty) return [];

        final response = await supabase
            .from('bursary_applications')
            .select('*, bursaries(title)')
            .eq('applicant_id', user.id)
            .order('created_at', ascending: false);
            
        return (response as List).map((json) => BursaryApplicationModel.fromJson(json)).toList();
      });
});

class BursarySubmitService {
  final _supabase = Supabase.instance.client;

  /// Helper execution task to upload bytes array safely across Web/Mobile configurations
  Future<String> _uploadToStorage({
    required String pathName,
    required Uint8List fileBytes,
    required String fileExtension,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    final fullPath = '$pathName/$fileName';

    await _supabase.storage.from('bursary-attachments').uploadBinary(
          fullPath,
          fileBytes,
          fileOptions: FileOptions(contentType: 'application/$fileExtension'),
        );

    // Returns the fully qualified public link destination address URL reference
    return _supabase.storage.from('bursary-attachments').getPublicUrl(fullPath);
  }

  Future<void> submitApplication({
    required String bursaryId,
    required String fullName,
    required String idNumber,
    required String phoneNumber,
    required String institutionName,
    required String admissionNumber,
    required String academicYear,
    required String semester,
    required Uint8List idBytes,
    required String idExtension,
    required Uint8List admissionBytes,
    required String admissionExtension,
    required Uint8List feeStructureBytes,
    required String feeStructureExtension,
    required Uint8List selfieBytes,
    required String selfieExtension,
  }) async {
    final user = _supabase.auth.currentUser;
    
    if (user == null) {
      throw Exception('You must be logged in to apply for bursaries.');
    }

    final folderPath = user.id;

    // 1. Fire off file storage executions concurrently
    final urls = await Future.wait([
      _uploadToStorage(pathName: '$folderPath/id_docs', fileBytes: idBytes, fileExtension: idExtension),
      _uploadToStorage(pathName: '$folderPath/admission_letters', fileBytes: admissionBytes, fileExtension: admissionExtension),
      _uploadToStorage(pathName: '$folderPath/fee_structures', fileBytes: feeStructureBytes, fileExtension: feeStructureExtension),
      _uploadToStorage(pathName: '$folderPath/selfies', fileBytes: selfieBytes, fileExtension: selfieExtension),
    ]);

    // 2. Commit metadata database record insert entry trace
    await _supabase.from('bursary_applications').insert({
      'bursary_id': bursaryId,
      'applicant_id': user.id, 
      'full_name': fullName,
      'id_number': idNumber,
      'phone_number': phoneNumber,
      'institution_name': institutionName,
      'admission_number': admissionNumber,
      'academic_year': academicYear,
      'semester': semester,
      'id_url': urls[0],
      'admission_letter_url': urls[1],
      'fee_structure_url': urls[2],
      'selfie_url': urls[3],
      'status': 'pending', 
    });
  }
}