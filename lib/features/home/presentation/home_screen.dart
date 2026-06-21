import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_rabai/features/admin/data/bursary_management_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final periodAsync = ref.watch(bursaryPeriodStreamProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 28,
              width: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.gavel_rounded, color: primaryColor, size: 24);
              },
            ),
            const SizedBox(width: 10),
            const Text(
              'MY RABAI DIGITAL PORTAL', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: Colors.black87)
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // ZONE 1: THE GATEWAY & WELCOME BANNER
              // ==========================================
              const Text('Habari, Resident! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 4),
              Text('Welcome back to the official sub-county gateway system.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              const SizedBox(height: 16),

              periodAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox.shrink(),
                data: (period) {
                  if (period == null) return const SizedBox.shrink();
                  final bool isClosed = period['is_force_closed'] ?? false;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isClosed ? Colors.red.shade50 : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isClosed ? Colors.red.shade200 : Colors.amber.shade300, width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(isClosed ? Icons.lock_outline_rounded : Icons.hourglass_top_rounded, color: isClosed ? Colors.red.shade700 : Colors.amber.shade800, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isClosed ? 'Important Notice: Window Closed' : 'Important Notice: System Open',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isClosed ? Colors.red.shade900 : Colors.amber.shade900),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isClosed 
                                  ? 'The Higher Education Bursary verification window is officially locked. Evaluation is in progress.'
                                  : 'The current Higher Education Bursary Window is active. Submit files before the deadline.',
                                style: TextStyle(fontSize: 12, color: isClosed ? Colors.red.shade800 : Colors.amber.shade800, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // ==========================================
              // ZONE 2: ACTION MATRIX GRID (DOWNLOADS REMOVED)
              // ==========================================
              const Text('QUICK ACCESS UTILITIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.35,
                children: [
                  _buildMatrixCard(
                    context, 
                    title: 'Public Feedback', 
                    subtitle: 'Report & Suggestions', 
                    icon: Icons.chat_bubble_outline_rounded, 
                    color: Colors.purple,
                    destination: const PublicFeedbackPage(), 
                  ),
                  _buildMatrixCard(
                    context, 
                    title: 'Opportunities', 
                    subtitle: 'Tenders & Jobs', 
                    icon: Icons.card_membership_rounded, 
                    color: Colors.orange,
                    destination: const OpportunitiesPage(), 
                  ),
                  _buildMatrixCard(
                    context, 
                    title: 'Emergency Desk', 
                    subtitle: 'Sub-County Contacts', 
                    icon: Icons.phone_in_talk_rounded, 
                    color: Colors.teal,
                    destination: const EmergencyDeskPage(), 
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // ==========================================
              // ZONE 3: DYNAMIC COMMUNITY PULSE
              // ==========================================
              const Text('ONGOING WARD ACTIVITIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2, 
                itemBuilder: (context, index) {
                  final activities = [
                    {'title': 'Ruruma Youth Tree Planting Drive', 'time': 'Ongoing • Closes 4 PM', 'ward': 'Ruruma Ward'},
                    {'title': 'Kambe-Ribe Sub-County Public Budget Hearing', 'time': 'Tomorrow • 9:00 AM', 'ward': 'Kambe Ward'}
                  ];
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: index == 0 ? primaryColor : Colors.grey.shade400, shape: BoxShape.circle)),
                            Expanded(child: Container(width: 2, color: index == 1 ? Colors.transparent : Colors.grey.shade300)),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(activities[index]['ward']!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor)),
                                    const SizedBox(width: 8),
                                    Text(activities[index]['time']!, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(activities[index]['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Text('LATEST PUBLIC OPPORTUNITIES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 16),
              SizedBox(
                height: 75,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final opportunities = [
                      {'title': 'Mizijini Water Network Piping Tender', 'type': 'Tender'},
                      {'title': 'Sub-County ICT Vocational Training Intake', 'type': 'Youth Program'},
                      {'title': 'Rabai Health Center Nursing Internships', 'type': 'Employment'},
                    ];
                    return Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('0${index + 1}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: primaryColor.withOpacity(0.2), height: 0.9)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(opportunities[index]['type']!.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5)),
                                const SizedBox(height: 2),
                                Text(opportunities[index]['title']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.2)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              const Text('CITIZEN VOICE QUICK REPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(hintText: "What's happening in your ward today?", hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13), border: InputBorder.none),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.arrow_forward_rounded, color: primaryColor), onPressed: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              const Text('THE RABAI MIRROR GALLERY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildGalleryTile('https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=500', 190, 'New School Desks Block'),
                        const SizedBox(height: 12),
                        _buildGalleryTile('https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=500', 130, 'Youth Assembly'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _buildGalleryTile('https://images.unsplash.com/photo-1509062522246-3755977927d7?w=500', 120, 'Graduation Day'),
                        const SizedBox(height: 12),
                        _buildGalleryTile('https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=500', 200, 'Sub-County Cup Finals'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // ==========================================
              // ZONE 4: THE ANCHOR, FORM & DEVELOPER BASELINE
              // ==========================================
              const Text('OFFICIAL SYSTEM CONTACT FORM', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 16),
              
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Your Name / Identity Context',
                      labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Detailed Inquiry or Desk Message Request',
                      labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      child: const Text('Dispatch Inquiry Line', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              const Text('DIRECT HELPDESK LINES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5)),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('OMAR WASHE KONDE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.3)),
                        const SizedBox(height: 2),
                        Text('System Core Architect & Developer', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('+254 725 409 996', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primaryColor)),
                      const SizedBox(height: 2),
                      Text('omaryw003@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, decoration: TextDecoration.underline)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 48),

              Center(
                child: Column(
                  children: [
                    Text(
                      '“ A transparent, empowered, and unified community. ”',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade200, thickness: 1),
                    const SizedBox(height: 12),
                    Text(
                      'Somali & Rabai Community System Context Portal',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '© 2026 Developed by Omar Washe Konde. All Rights Reserved.',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixCard(
    BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color,
    required Widget destination,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryTile(String imageUrl, double height, String label) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ====================================================================
// REMAINING UTILITY DESTINATIONS
// ====================================================================

class PublicFeedbackPage extends StatelessWidget {
  const PublicFeedbackPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PUBLIC FEEDBACK & GRIEVANCES')),
      body: const Center(child: Text('Lodge official complaints, suggestions, or ward-specific reports.')),
    );
  }
}

class OpportunitiesPage extends StatelessWidget {
  const OpportunitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PUBLIC OPPORTUNITIES')),
      body: const Center(child: Text('Active Ward Tenders, Vacancies, and Youth Program Intakes')),
    );
  }
}

class EmergencyDeskPage extends StatelessWidget {
  const EmergencyDeskPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMERGENCY SUPPORT DESK')),
      body: const Center(child: Text('Immediate Sub-County Emergency Hotline Matrix and Helpdesk Contacts')),
    );
  }
}