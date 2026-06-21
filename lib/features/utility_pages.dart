import 'package:flutter/material.dart';

// 1. Downloads Screen
class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DOWNLOADS & GUIDELINES')),
      body: const Center(child: Text('Official Sub-County Forms and Guidelines Document Repository')),
    );
  }
}

// 2. Public Feedback / Report Screen
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

// 3. Opportunities Screen
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

// 4. Emergency Desk Screen
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