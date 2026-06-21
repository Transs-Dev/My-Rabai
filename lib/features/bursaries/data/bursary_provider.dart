import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BursaryModel {
  final String id;
  final String title;
  final String academicYear;
  final String description;
  final List<String> requirements;
  final DateTime deadline;
  final String? formDownloadUrl;
  final bool isActive;

  BursaryModel({
    required this.id,
    required this.title,
    required this.academicYear,
    required this.description,
    required this.requirements,
    required this.deadline,
    this.formDownloadUrl,
    required this.isActive,
  });

  factory BursaryModel.fromJson(Map<String, dynamic> json) {
    // Safely parse Postgres text arrays into a Dart List<String>
    final reqsData = json['requirements'];
    final List<String> parsedRequirements = reqsData != null 
        ? List<String>.from(reqsData as List) 
        : [];

    return BursaryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      academicYear: json['academic_year'] as String? ?? 'N/A',
      description: json['description'] as String? ?? '',
      requirements: parsedRequirements,
      deadline: DateTime.parse(json['deadline'] as String),
      formDownloadUrl: json['form_download_url'] as String?,
      isActive: json['is_active'] as bool? ?? false,
    );
  }
}

// Live real-time stream provider matching your true schema
final bursariesStreamProvider = StreamProvider<List<BursaryModel>>((ref) {
  final supabase = Supabase.instance.client;

  return supabase
      .from('bursaries')
      .stream(primaryKey: ['id'])
      .order('id') 
      .map((List<Map<String, dynamic>> data) {
        return data.map((json) => BursaryModel.fromJson(json)).toList();
      });
});