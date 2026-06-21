import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Imported Bursary Screen 🔐
import 'package:my_rabai/features/admin/presentation/admin_bursary_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProjectForm = false; // Toggle between Announcement and Project
  bool _isLoading = false;

  // Shared controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Announcement specific fields
  String _selectedCategory = 'General';
  
  // Project specific fields
  String _selectedWard = 'Rabai Kisurutini';
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      if (_isProjectForm) {
        // Insert into development_projects
        await supabase.from('development_projects').insert({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'ward': _selectedWard,
          'status': 'Planning',
          'progress_percentage': 0,
          'budget': _budgetController.text.isNotEmpty ? 'KES ${_budgetController.text.trim()}' : null,
        });
      } else {
        // Insert into news_posts (Announcements)
        await supabase.from('news_posts').insert({
          'title': _titleController.text.trim(),
          'content': _descriptionController.text.trim(),
          'category': _selectedCategory,
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_isProjectForm ? "Project" : "Announcement"} posted successfully!')),
        );
        // Reset form
        _titleController.clear();
        _descriptionController.clear();
        _budgetController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management Console', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔐 BURSARY CONTROL ACCESS ROOT
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade100),
              ),
              color: Colors.blue.shade50.withOpacity(0.3),
              child: ListTile(
                leading: const Icon(Icons.school, color: Colors.blue),
                title: const Text('Bursary Operations Control Room', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Review applications, process assets, and modify execution windows'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminBursaryScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            // Toggle Segment Component
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Post Announcement')),
                    selected: !_isProjectForm,
                    onSelected: (val) => setState(() => _isProjectForm = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Log New Project')),
                    selected: _isProjectForm,
                    onSelected: (val) => setState(() => _isProjectForm = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: _isProjectForm ? 'Project Title' : 'Announcement Headline',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: _isProjectForm ? 'Project Description / Objectives' : 'Announcement Content Body',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Content is required' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Dynamic Form Inputs based on selection toggle
                  if (!_isProjectForm) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category Tag',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['General', 'Bursary', 'Health', 'Development'].map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),
                  ] else ...[
                    DropdownButtonFormField<String>(
                      value: _selectedWard,
                      decoration: InputDecoration(
                        labelText: 'Target Ward Location',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['Rabai Kisurutini', 'Mwawesa', 'Ruruma', 'Kambe-Ribe'].map((ward) {
                        return DropdownMenuItem(value: ward, child: Text(ward));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedWard = val!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Budget Amount (Optional)',
                        prefixText: 'KES ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isProjectForm ? 'Launch Project Tracking' : 'Publish Announcement'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}