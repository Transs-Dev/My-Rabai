import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_rabai/features/admin/data/bursary_management_provider.dart';
import 'package:url_launcher/url_launcher.dart'; 

class AdminBursaryScreen extends ConsumerWidget {
  const AdminBursaryScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'under_review': return Colors.blue;
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.grey;
    }
  }

  Future<void> _updateStatus(BuildContext context, String appId, String status) async {
    try {
      await Supabase.instance.client
          .from('bursary_applications')
          .update({'status': status})
          .eq('id', appId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Application marked as ${status.toUpperCase()}'))
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e'), backgroundColor: Colors.red)
        );
      }
    }
  }

  Future<void> _togglePeriodStatus(BuildContext context, String periodId, bool forceClose) async {
    try {
      await Supabase.instance.client
          .from('bursary_periods')
          .update({'is_force_closed': forceClose})
          .eq('id', periodId);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update period window: $e'), backgroundColor: Colors.red)
        );
      }
    }
  }

  Future<void> _viewFileUrl(BuildContext context, String? path) async {
    if (path == null || path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No document URL attached to this application.'))
      );
      return;
    }

    final Uri url = Uri.parse(path);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open document link: $path'))
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: $e'), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(adminApplicationsStreamProvider);
    final periodAsync = ref.watch(bursaryPeriodStreamProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bursary Control Hub', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.description), text: 'Applications'),
              Tab(icon: Icon(Icons.tune), text: 'Configure Window'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: APPLICATIONS LIST VIEW
            applicationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading files: $err')),
              data: (apps) {
                if (apps.isEmpty) return const Center(child: Text('No student profiles submitted yet.'));
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    final color = _getStatusColor(app['status'] ?? 'pending');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ExpansionTile(
                        title: Text(app['bursary_title'] ?? 'General Bursary Scheme', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Applicant: ${app['student_name'] ?? "Unknown Student"}'),
                        trailing: Chip(
                          label: Text(
                            (app['status'] ?? 'pending').toString().toUpperCase(), 
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                          ),
                          backgroundColor: color,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Institution: ${app['institution_name'] ?? "N/A"}'),
                                const SizedBox(height: 4),
                                Text('Admission Number: ${app['admission_number'] ?? "N/A"}'),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.file_present),
                                      label: const Text('View Documents'),
                                      onPressed: app['document_url'] != null 
                                        ? () => _viewFileUrl(context, app['document_url'])
                                        : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                                      onPressed: () => _updateStatus(context, app['id'].toString(), 'under_review'),
                                      child: const Text('Review'),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(foregroundColor: Colors.green),
                                      onPressed: () => _updateStatus(context, app['id'].toString(), 'approved'),
                                      child: const Text('Approve'),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                      onPressed: () => _updateStatus(context, app['id'].toString(), 'rejected'),
                                      child: const Text('Reject'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // TAB 2: DATE CONFIGURATION SETTINGS
            periodAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (period) {
                if (period == null) return const Center(child: Text('No setup configuration available.'));
                
                final start = DateTime.parse(period['start_date']);
                final end = DateTime.parse(period['end_date']);
                final isForceClosed = period['is_force_closed'] ?? false;
                final now = DateTime.now();
                
                final bool isWindowActive = now.isAfter(start) && now.isBefore(end) && !isForceClosed;

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(period['title'] ?? 'Bursary Schedule Window', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('System Status: '),
                          Chip(
                            label: Text(isWindowActive ? 'OPEN' : 'CLOSED', style: const TextStyle(color: Colors.white)),
                            backgroundColor: isWindowActive ? Colors.green : Colors.red,
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Start Window Date'),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm a').format(start)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: const Text('Deadline Expiration Date'),
                        subtitle: Text(DateFormat('yyyy-MM-dd HH:mm a').format(end)),
                      ),
                      const Divider(height: 40),
                      SwitchListTile(
                        title: const Text('Force Close Registration Window'),
                        subtitle: const Text('Immediately flags application process as locked regardless of calendar target range configurations'),
                        value: isForceClosed,
                        onChanged: (val) => _togglePeriodStatus(context, period['id'].toString(), val),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}