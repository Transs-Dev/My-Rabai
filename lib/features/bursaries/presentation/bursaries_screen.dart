import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_rabai/features/bursaries/data/bursary_application_provider.dart';

// ==========================================
// 1. MAIN BURSARIES SCREEN (LIST VIEW)
// ==========================================
class BursariesScreen extends StatelessWidget {
  const BursariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ FIXED: Replaced mock strings with your active production database UUIDs
    final List<Map<String, String>> activeBursaries = [
      {
        'id': 'fda9cc7e-66bb-4d32-badd-f9d99b8b159a', 
        'title': 'Higher Education Bursary (HEB)',
        'description': 'Open to all registered university and college students residing in Rabai.',
      },
      {
        'id': '19d419b5-f73d-4232-98b7-6a9073a79cf4', 
        'title': 'Secondary School Fund',
        'description': 'Special tuition relief allocation for vulnerable secondary school students.',
      },
      {
        'id': '3ba3716b-0a83-45bd-bbef-ad54b3551a8c',
        'title': 'Special Education Support Fund',
        'description': 'Assistance for students with specialized assessment or educational needs.',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Bursaries', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: activeBursaries.length,
        itemBuilder: (context, index) {
          final bursary = activeBursaries[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bursary['title']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bursary['description']!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplyBursaryScreen(
                              bursaryId: bursary['id']!,
                              bursaryTitle: bursary['title']!,
                            ),
                          ),
                        );
                      },
                      child: const Text('Apply Now'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 2. UPGRADED FORM SCREEN (APPLICATION PIPELINE)
// ==========================================
class ApplyBursaryScreen extends ConsumerStatefulWidget {
  final String bursaryId;
  final String bursaryTitle;

  const ApplyBursaryScreen({
    super.key,
    required this.bursaryId,
    required this.bursaryTitle,
  });

  @override
  ConsumerState<ApplyBursaryScreen> createState() => _ApplyBursaryScreenState();
}

class _ApplyBursaryScreenState extends ConsumerState<ApplyBursaryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _institutionController = TextEditingController();
  final _admissionController = TextEditingController();

  String? _selectedYear;
  String? _selectedSemester;

  Uint8List? _idBytes;
  String? _idExtension;

  Uint8List? _admissionBytes;
  String? _admissionExtension;

  Uint8List? _feeStructureBytes;
  String? _feeStructureExtension;

  Uint8List? _selfieBytes;
  String? _selfieExtension;

  final List<String> _academicYears = ['Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5'];
  final List<String> _semesters = ['Semester 1', 'Semester 2', 'Semester 3'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _phoneNumberController.dispose();
    _institutionController.dispose();
    _admissionController.dispose();
    super.dispose();
  }

  Future<void> _pickDocumentFile({required String type}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          if (type == 'id') {
            _idBytes = bytes;
            _idExtension = file.name.split('.').last;
          } else if (type == 'admission') {
            _admissionBytes = bytes;
            _admissionExtension = file.name.split('.').last;
          } else if (type == 'fee') {
            _feeStructureBytes = bytes;
            _feeStructureExtension = file.name.split('.').last;
          }
        });
      }
    } catch (e) {
      _showSnackBar('Error picking document: $e', isError: true);
    }
  }

  Future<void> _captureSelfieImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _selfieBytes = bytes;
          _selfieExtension = photo.name.split('.').last;
        });
      }
    } catch (e) {
      _showSnackBar('Error capturing selfie: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedYear == null || _selectedSemester == null) {
      _showSnackBar('Please select both Academic Year and Semester.', isError: true);
      return;
    }

    if (_idBytes == null || _admissionBytes == null || _feeStructureBytes == null || _selfieBytes == null) {
      _showSnackBar('All document attachments and your selfie are strictly required!', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(bursarySubmitProvider).submitApplication(
            bursaryId: widget.bursaryId,
            fullName: _fullNameController.text.trim(),
            idNumber: _idNumberController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            institutionName: _institutionController.text.trim(),
            admissionNumber: _admissionController.text.trim(),
            academicYear: _selectedYear!,
            semester: _selectedSemester!,
            idBytes: _idBytes!,
            idExtension: _idExtension!,
            admissionBytes: _admissionBytes!,
            admissionExtension: _admissionExtension!,
            feeStructureBytes: _feeStructureBytes!,
            feeStructureExtension: _feeStructureExtension!,
            selfieBytes: _selfieBytes!,
            selfieExtension: _selfieExtension!,
          );

      _showSnackBar('Application submitted successfully!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Submission Failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply: ${widget.bursaryTitle}'),
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Uploading attachments and files...', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Please keep the app open.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal & Academic Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(labelText: 'Full Name (As it appears on National ID)', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Full name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _idNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'National ID Number / Birth Certificate No.', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'ID number is required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Phone number is required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _institutionController,
                      decoration: const InputDecoration(labelText: 'Institution Name (University/College/School)', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Institution name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _admissionController,
                      decoration: const InputDecoration(labelText: 'Admission / Registration Number', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Admission number is required' : null,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedYear,
                            decoration: const InputDecoration(labelText: 'Academic Year', border: OutlineInputBorder()),
                            items: _academicYears.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                            onChanged: (val) => setState(() => _selectedYear = val),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedSemester,
                            decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                            items: _semesters.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (val) => setState(() => _selectedSemester = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Required Documents (Clear & Unblurred)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _buildAttachmentTile(
                      title: 'Scanned ID Card or Birth Certificate (Image)',
                      hasFile: _idBytes != null,
                      onTap: () => _pickDocumentFile(type: 'id'),
                    ),

                    _buildAttachmentTile(
                      title: 'Official Admission Letter (Image)',
                      hasFile: _admissionBytes != null,
                      onTap: () => _pickDocumentFile(type: 'admission'),
                    ),

                    _buildAttachmentTile(
                      title: 'Current Fee Structure (Image)',
                      hasFile: _feeStructureBytes != null,
                      onTap: () => _pickDocumentFile(type: 'fee'),
                    ),

                    _buildAttachmentTile(
                      title: 'Current Passport Selfie Photo (Take Live Photo)',
                      hasFile: _selfieBytes != null,
                      isCamera: true,
                      onTap: _captureSelfieImage,
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Submit Application', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAttachmentTile({
    required String title,
    required bool hasFile,
    required VoidCallback onTap,
    bool isCamera = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: hasFile ? Colors.green : Colors.grey.shade300, width: hasFile ? 2 : 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: hasFile ? Colors.green.withOpacity(0.1) : Colors.grey.shade100,
          child: Icon(
            hasFile ? Icons.check_circle : (isCamera ? Icons.camera_alt_outlined : Icons.upload_file_outlined),
            color: hasFile ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(
          hasFile ? 'Document attached successfully' : 'File must be filled/unblurred',
          style: TextStyle(fontSize: 12, color: hasFile ? Colors.green : Colors.grey),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}