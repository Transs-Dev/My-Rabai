import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Global Keys for programmatic section jump redirection
  final GlobalKey _discoverKey = GlobalKey();
  final GlobalKey _opportunitiesKey = GlobalKey();
  final GlobalKey _feedbackKey = GlobalKey();
  final GlobalKey _leadershipKey = GlobalKey();

  // Feedback Form Controllers & Key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Expandable description card matrices
  final List<bool> _isCardExpanded = [false, false, false, false];

  // Selected Category state machine for the Image Gallery Matrix
  int _selectedGalleryCategory = 0;
  final List<Map<String, String>> _galleryCategories = [
    {'label': 'Schools', 'key': 'schools'},
    {'label': 'Hospitals', 'key': 'hospitals'},
    {'label': 'Roads', 'key': 'roads'},
    {'label': 'Cultural Sites', 'key': 'cultural_sites'},
    {'label': 'Community Events', 'key': 'community_events'},
    {'label': 'Nature', 'key': 'nature'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Smooth scroll translation logic to targeting anchors
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        // FIXED: Removed 'const' before BoxFit.contain
        title: Image.asset(
          'assets/logo.png',
          height: 42,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Graceful typography fallback if asset file is missing initially
            return const Text(
              'MY RABAI',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xFF004D40)),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // ==========================================
            // 1. HERO WELCOME SECTION
            // ==========================================
            Stack(
              children: [
                Container(
                  height: 390,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF004D40), Color(0xFF00796B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  right: -50,
                  top: -20,
                  child: Icon(Icons.wb_sunny_rounded, size: 280, color: Colors.white.withOpacity(0.04)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "OFFICIAL DIGITAL GATEWAY",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "My Rabai",
                        style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1),
                      ),
                      const Text(
                        "Connecting People, Opportunities and Development",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFFE0F2F1), height: 1.2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Welcome to My Rabai, your digital gateway to information, opportunities, public services, development projects and community engagement within Rabai Constituency.",
                        style: TextStyle(fontSize: 13, color: Color(0xFFB2DFDB), height: 1.5),
                      ),
                      const SizedBox(height: 28),
                      
                      // BUTTONS: Programmatic routing across the viewport
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.explore_rounded, size: 18),
                              label: const Text("Explore Rabai", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              onPressed: () => _scrollToSection(_discoverKey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white38, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.star_border_purple500_rounded, size: 18),
                              label: const Text("Latest Opportunities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              onPressed: () => _scrollToSection(_opportunitiesKey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ==========================================
            // 2. LEADERSHIP MESSAGES (MP & MCA)
            // ==========================================
            Padding(
              key: _leadershipKey,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildLeadershipCard(
                    title: "Message from Our Member of Parliament",
                    role: "MEMBER OF PARLIAMENT • RABAI CONSTITUENCY",
                    content: "A welcoming message highlighting targeted local development, educational infrastructural support, youth economic empowerment frameworks, and sustainable community unity across all wards.",
                    imageAssetPath: "assets/mp_photo.png",
                  ),
                  const SizedBox(height: 16),
                  _buildLeadershipCard(
                    title: "Message from Our MCA",
                    role: "MEMBER OF COUNTY ASSEMBLY",
                    content: "A short leadership message focusing on local structural development parameters, active grassroots community participation, and efficient service delivery tracking maps.",
                    imageAssetPath: "assets/mca_photo.png",
                  ),
                ],
              ),
            ),

            // ==========================================
            // 3. WHY RABAI IS SPECIAL (Expandable Cards)
            // ==========================================
            _buildSectionHeader(title: "Discover Rabai", sectionKey: _discoverKey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildExpandableCard(
                    index: 0,
                    title: "Rich Cultural Heritage",
                    icon: Icons.gavel_rounded,
                    description: "Rabai is home to a rich history, traditions and cultural diversity that continue to shape the identity of the community.",
                    extendedText: "As a cornerstone site of early educational infrastructure and historical community squares, our cultural landscape retains robust traditional governance systems and values.",
                  ),
                  _buildExpandableCard(
                    index: 1,
                    title: "Natural Beauty",
                    icon: Icons.landscape_rounded,
                    description: "Rabai offers scenic landscapes, green environments and unique natural attractions.",
                    extendedText: "From the strictly preserved ecosystems of the UNESCO-recognized Kaya forests to verdant agricultural ridges, the region offers premier eco-tourism potential.",
                  ),
                  _buildExpandableCard(
                    index: 2,
                    title: "Strategic Location",
                    icon: Icons.map_rounded,
                    description: "Rabai serves as an important connection point within the Coast Region and contributes to regional growth.",
                    extendedText: "Positioned elegantly adjacent to key transportation arterials linking interior agricultural systems directly to the Mombasa and Kilifi market nodes.",
                  ),
                  _buildExpandableCard(
                    index: 3,
                    title: "Growing Development",
                    icon: Icons.analytics_rounded,
                    description: "Continuous investments in roads, schools, healthcare and public infrastructure are transforming the constituency.",
                    extendedText: "Through active modernization protocols, we continue to verify systematic expansions across vocational labs, solar health links, and tarmac connectivity maps.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 4. ECONOMIC ACTIVITIES
            // ==========================================
            _buildSectionHeader(title: "Economic Activities in Rabai"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.88,
                children: [
                  _buildEconomicCard(Icons.grass_rounded, "Agriculture", "Cash crops, local food production platforms, and organic farming models."),
                  _buildEconomicCard(Icons.pets_rounded, "Livestock Farming", "Dairy farming networks, poultry systems, and local veterinary support nodes."),
                  _buildEconomicCard(Icons.storefront_rounded, "Small Businesses", "Vibrant local market environments, retail spaces, and MSME growth metrics."),
                  _buildEconomicCard(Icons.paid_rounded, "Trade and Commerce", "Inter-county trading centers and cross-regional market connectivity logs."),
                  _buildEconomicCard(Icons.local_shipping_rounded, "Transport Services", "Boda boda operational associations, mini-bus frameworks, and logistics channels."),
                  _buildEconomicCard(Icons.forest_rounded, "Tourism Activities", "Eco-cultural forest excursions and ancestral landmark visitor path systems."),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 5. EDUCATION IN RABAI
            // ==========================================
            _buildSectionHeader(title: "Education and Youth Empowerment"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("70+", "Primary & Sec Schools", Icons.school_rounded, Colors.blue.shade700)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard("4", "Technical Institutes", Icons.construction_rounded, Colors.purple.shade700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("15+", "Active Youth Programs", Icons.groups_rounded, Colors.orange.shade700)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildStatCard("100%", "Scholarship & Bursary", Icons.account_balance_wallet_rounded, Colors.green.shade700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 24),
                            SizedBox(width: 8),
                            Text("Empowerment & Vetting", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bursary Support Portals Active",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Verified constituency educational sponsorship application maps are processed natively through designated ward administrators.",
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, height: 1.3),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 6. HEALTHCARE SERVICES
            // ==========================================
            _buildSectionHeader(title: "Healthcare Services"),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildHealthcareCard("Rabai Sub-County Hospital", "Level 4 core referral hospital structure configured for 24/7 outpatient care.", Icons.local_hospital_rounded),
                  _buildHealthcareCard("Kisauni Health Centres", "Maternal monitoring maps, outpatient immunization fields, and preventative assistance.", Icons.health_and_safety_rounded),
                  _buildHealthcareCard("Community Health Programs", "Informed healthcare volunteers handling household diagnostic records and clinics.", Icons.volunteer_activism_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 7. ROADS AND INFRASTRUCTURE
            // ==========================================
            _buildSectionHeader(title: "Infrastructure Development"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildProgressRow("Road Tarmac & Grading Network", 0.78, "78% Completed"),
                    const SizedBox(height: 16),
                    _buildProgressRow("Water Projects & Piping Outlets", 0.62, "62% Active Pipeline"),
                    const SizedBox(height: 16),
                    _buildProgressRow("Rural Electricity Grid Transformation", 0.85, "85% Transformer Coverage"),
                    const SizedBox(height: 16),
                    _buildProgressRow("Public Buildings & Community Labs", 0.45, "45% Structural Phase"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 8. GALLERY OF RABAI (Dynamic Automations)
            // ==========================================
            _buildSectionHeader(title: "Explore Rabai Gallery"),
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _galleryCategories.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedGalleryCategory == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGalleryCategory = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF004D40) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _galleryCategories[index]['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 3,
                itemBuilder: (context, index) {
                  final String currentCategoryKey = _galleryCategories[_selectedGalleryCategory]['key']!;
                  // DYNAMIC FILENAME COMPILATION STRATEGY
                  final String expectedAssetPath = "assets/gallery_${currentCategoryKey}_${index + 1}.png";

                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            expectedAssetPath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Elegant blueprint vector display if photo asset is unrendered
                              return Container(
                                color: Colors.grey.shade100,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_rounded, size: 40, color: Colors.grey.shade400),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Add to assets: \n$expectedAssetPath",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontFamily: 'monospace'),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                // FIXED: Replaced non-existent Colors.black70 with Colors.black87
                                colors: [Colors.transparent, Colors.black87],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16, bottom: 16, right: 16,
                            child: Text(
                              "${_galleryCategories[_selectedGalleryCategory]['label']} Feature Frame #${index + 1}",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 9. OPPORTUNITIES SECTION
            // ==========================================
            _buildSectionHeader(title: "Opportunities for Residents", sectionKey: _opportunitiesKey),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildOpportunityCard("Bursaries & Scholarships", "Higher Education Support Maps", Icons.monetization_on_rounded),
                  _buildOpportunityCard("Local Technical Internships", "County Infrastructure Nodes", Icons.card_membership_rounded),
                  _buildOpportunityCard("Public Service Job Postings", "Administrative Assistance Hubs", Icons.work_rounded),
                  _buildOpportunityCard("Women Empowerment Programs", "Micro-Financing Trade Tools", Icons.assignment_ind_rounded),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: Color(0xFF004D40)),
                ),
                onPressed: () {},
                child: const Text("View All Opportunities", style: TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.bold)),
              ),
            ),

            // ==========================================
            // 10. CULTURE AND HERITAGE
            // ==========================================
            _buildSectionHeader(title: "Our Culture"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
                children: [
                  _buildCultureItem("Traditions & Celebrations", Icons.gavel_rounded),
                  _buildCultureItem("Local Languages", Icons.translate_rounded),
                  _buildCultureItem("Community Values", Icons.favorite_rounded),
                  _buildCultureItem("Historical Landmarks", Icons.account_balance_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 11. COMMUNITY IMPACT SECTION
            // ==========================================
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF004D40),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    "Building a Better Rabai Together",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImpactCounter("4,500+", "Students Supported"),
                      _buildImpactCounter("32+", "Development Projects"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImpactCounter("12+", "Community Programs"),
                      _buildImpactCounter("18,000+", "Beneficiaries Reached"),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // 12. INTERACTIVE FEEDBACK FORM SECTION
            // ==========================================
            _buildSectionHeader(title: "Your Voice Matters", sectionKey: _feedbackKey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Share your ideas, suggestions and concerns to help improve our constituency.",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration("Full Name", Icons.person_outline_rounded),
                        validator: (value) => (value == null || value.trim().isEmpty) ? "Please type your name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration("Email Address / Contact", Icons.alternate_email_rounded),
                        validator: (value) => (value == null || value.contains('@') == false) ? "Provide a valid email layout" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: _buildInputDecoration("Your Message / Concern", Icons.chat_bubble_outline_rounded),
                        validator: (value) => (value == null || value.trim().length < 5) ? "Please extend your statement details" : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Processing feedback entry into the public queue..."),
                                backgroundColor: Color(0xFF004D40),
                              ),
                            );
                            _nameController.clear();
                            _emailController.clear();
                            _messageController.clear();
                          }
                        },
                        child: const Text("Submit Feedback Entry", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ==========================================
            // 13. COMPREHENSIVE FOOTER SECTION
            // ==========================================
            Container(
              color: Colors.grey.shade900,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("My Rabai", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text(
                    '"Connecting. Informing. Empowering."', 
                    style: TextStyle(color: Colors.white60, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  
                  // Contact Meta Coordinates block
                  const Text("OFFICIAL CONSTITUENCY CONTACTS", style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(Icons.phone_android_rounded, size: 14, color: Colors.white70),
                      SizedBox(width: 8),
                      Text("+254 700 000000 / +254 711 000000", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.email_outlined, size: 14, color: Colors.white70),
                      SizedBox(width: 8),
                      Text("info@rabai.go.ke / support@rabai.go.ke", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  
                  const Divider(color: Colors.white12, height: 32),
                  const Text("QUICK LINKS NAVIGATION", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  
                  // Interactive Quick links mapping directly back to view states
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _buildFooterLink("News", () => _scrollToSection(_leadershipKey)),
                      _buildFooterLink("Projects", () => _scrollToSection(_discoverKey)),
                      _buildFooterLink("Opportunities", () => _scrollToSection(_opportunitiesKey)),
                      _buildFooterLink("Feedback Portal", () => _scrollToSection(_feedbackKey)),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("© 2026 Constituency Development", style: TextStyle(color: Colors.white38, fontSize: 11)),
                      Row(
                        children: [Icons.facebook_rounded, Icons.language_rounded, Icons.alternate_email_rounded].map((icon) => Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Icon(icon, color: Colors.white54, size: 18),
                        )).toList(),
                      )
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Visual Utility Helpers
  Widget _buildSectionHeader({required String title, GlobalKey? sectionKey}) {
    return Padding(
      key: sectionKey,
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 28, bottom: 14),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: Colors.black87),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 18, color: const Color(0xFF004D40)),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF004D40))),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.red.shade200)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.red.shade700)),
    );
  }

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFFB2DFDB), fontSize: 12, fontWeight: FontWeight.w600, decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  Widget _buildLeadershipCard({required String title, required String role, required String content, required String imageAssetPath}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 75, height: 95,
              color: const Color(0xFFE0F2F1),
              child: Image.asset(
                imageAssetPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person_rounded, color: Color(0xFF004D40), size: 36);
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role, style: TextStyle(color: Colors.amber.shade800, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(content, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.35), maxLines: 3, overflow: TextOverflow.ellipsis),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {},
                  child: const Text("Read Full Message →", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpandableCard({required int index, required String title, required IconData icon, required String description, required String extendedText}) {
    bool expanded = _isCardExpanded[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: expanded ? const Color(0xFF004D40) : Colors.grey.shade200, width: expanded ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => setState(() => _isCardExpanded[index] = !expanded),
            leading: Icon(icon, color: expanded ? const Color(0xFF004D40) : Colors.black45),
            title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            trailing: Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: expanded ? 75 : 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRect(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Text(extendedText, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.3)),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildEconomicCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF004D40), size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 4),
          Expanded(child: Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String label, IconData icon, Color col) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Icon(icon, color: col, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.1)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHealthcareCard(String name, String desc, IconData icon) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade700, size: 30),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String title, double value, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(status, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: value, backgroundColor: Colors.grey.shade100, color: const Color(0xFF004D40), minHeight: 6),
      ],
    );
  }

  Widget _buildOpportunityCard(String title, String dept, IconData icon) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber.shade800, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(dept, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCultureItem(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildImpactCounter(String num, String label) {
    return Column(
      children: [
        Text(num, style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}