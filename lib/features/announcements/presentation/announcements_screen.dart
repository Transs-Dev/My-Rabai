import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Handles clean date formatting
import 'package:my_rabai/features/announcements/data/announcements_provider.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsyncValue = ref.watch(announcementsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rabai News & Updates', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: announcementsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load updates: $err')),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text('No announcements found at the moment.', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final DateTime createdAt = DateTime.parse(post['created_at']);
              final String formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(createdAt);

              final isBursary = post['category'] == 'Bursary';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Fixed property layout name
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isBursary ? Colors.amber.shade100 : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              post['category'] ?? 'General',
                              style: TextStyle(
                                fontSize: 11, 
                                fontWeight: FontWeight.bold,
                                color: isBursary ? Colors.amber.shade900 : Colors.blue.shade900,
                              ),
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        post['title'] ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post['content'] ?? '',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}