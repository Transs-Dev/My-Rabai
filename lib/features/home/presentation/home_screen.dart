import 'package:flutter/material.dart';

// ============================================================
// MY RABAI — HomeScreen  (full rewrite)
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // ── Scroll anchor keys ──────────────────────────────────
  final GlobalKey _discoverKey     = GlobalKey();
  final GlobalKey _opportunitiesKey = GlobalKey();
  final GlobalKey _feedbackKey     = GlobalKey();
  final GlobalKey _leadershipKey   = GlobalKey();
  final GlobalKey _historyKey      = GlobalKey();
  final GlobalKey _sitesKey        = GlobalKey();

  // ── Feedback form ────────────────────────────────────────
  final _formKey              = GlobalKey<FormState>();
  final _nameController       = TextEditingController();
  final _emailController      = TextEditingController();
  final _messageController    = TextEditingController();

  // ── Discover expandable cards ────────────────────────────
  final List<bool> _isCardExpanded = [false, false, false, false];

  // ── Gallery ──────────────────────────────────────────────
  int _selectedGalleryCategory = 0;
  final List<Map<String, String>> _galleryCategories = [
    {'label': 'Schools',         'key': 'schools'},
    {'label': 'Hospitals',       'key': 'hospitals'},
    {'label': 'Roads',           'key': 'roads'},
    {'label': 'Cultural Sites',  'key': 'cultural_sites'},
    {'label': 'Events',          'key': 'community_events'},
    {'label': 'Nature',          'key': 'nature'},
  ];

  // ── Hero animation ───────────────────────────────────────
  late final AnimationController _heroCtrl;
  late final Animation<double>   _heroFade;
  late final Animation<Offset>   _heroSlide;

  // ── Section fade-in controller (simple) ─────────────────
  late final AnimationController _sectionCtrl;
  late final Animation<double>   _sectionFade;

  @override
  void initState() {
    super.initState();

    _heroCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _heroFade  = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
            begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));

    _sectionCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _sectionFade = CurvedAnimation(parent: _sectionCtrl, curve: Curves.easeIn);

    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300),
        () => _sectionCtrl.forward());
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _sectionCtrl.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic);
    }
  }

  // ── Palette ──────────────────────────────────────────────
  static const Color _primary   = Color(0xFF004D40);
  static const Color _accent    = Color(0xFFFFB300);
  static const Color _surface   = Color(0xFFF7FAF9);
  static const Color _cardBg    = Colors.white;

  // ============================================================
  //  BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHero(),
            _buildLeadershipSection(),
            _buildSectionHeader('Discover Rabai', key: _discoverKey),
            _buildDiscoverCards(),
            _buildSectionHeader('Economic Activities'),
            _buildEconomicGrid(),
            _buildSectionHeader('Education & Youth Empowerment'),
            _buildEducationSection(),
            _buildSectionHeader('Healthcare Services'),
            _buildHealthcareSection(),
            _buildSectionHeader('Infrastructure Development'),
            _buildInfrastructureSection(),
            _buildSectionHeader('Rabai Gallery'),
            _buildGallerySection(),
            _buildSectionHeader('Opportunities', key: _opportunitiesKey),
            _buildOpportunitiesSection(),
            _buildSectionHeader('Our Culture'),
            _buildCultureSection(),
            _buildSectionHeader('Our History', key: _historyKey),
            _buildHistorySection(),
            _buildSectionHeader('Historical Sites', key: _sitesKey),
            _buildHistoricalSitesSection(),
            _buildImpactSection(),
            _buildSectionHeader('Your Voice Matters', key: _feedbackKey),
            _buildFeedbackForm(),
            const SizedBox(height: 40),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  APP BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.white,
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo left-aligned
          Image.asset(
            'assets/logo.png',
            height: 40,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.account_balance_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('MY RABAI',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: _primary)),
              Text('Official Digital Gateway',
                  style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 0.5,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.black87),
            onPressed: () {}),
        const SizedBox(width: 4),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade100, height: 1),
      ),
    );
  }

  // ============================================================
  //  1. HERO
  // ============================================================
  Widget _buildHero() {
    return FadeTransition(
      opacity: _heroFade,
      child: SlideTransition(
        position: _heroSlide,
        child: Stack(
          children: [
            Container(
              height: 420,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF002B24), _primary, Color(0xFF00796B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative circles
            Positioned(
                right: -60, top: -40,
                child: _decorCircle(260, Colors.white.withOpacity(0.04))),
            Positioned(
                right: 60, top: 80,
                child: _decorCircle(120, Colors.white.withOpacity(0.03))),
            Positioned(
                left: -30, bottom: -30,
                child: _decorCircle(180, Colors.white.withOpacity(0.03))),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pill('OFFICIAL DIGITAL GATEWAY'),
                  const SizedBox(height: 16),
                  const Text('My Rabai',
                      style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.5,
                          height: 1.0)),
                  const SizedBox(height: 8),
                  const Text(
                      'Connecting People,\nOpportunities & Development',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFB2DFDB),
                          height: 1.3)),
                  const SizedBox(height: 14),
                  const Text(
                      'Your digital home for information, services, development projects and community engagement within Rabai Constituency.',
                      style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF80CBC4),
                          height: 1.55)),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _heroBtn(
                            icon: Icons.explore_rounded,
                            label: 'Explore Rabai',
                            filled: true,
                            onTap: () => _scrollToSection(_discoverKey)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _heroBtn(
                            icon: Icons.star_border_rounded,
                            label: 'Opportunities',
                            filled: false,
                            onTap: () =>
                                _scrollToSection(_opportunitiesKey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorCircle(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color));

  Widget _pill(String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
            color: _accent.withOpacity(0.85),
            borderRadius: BorderRadius.circular(30)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
      );

  Widget _heroBtn(
      {required IconData icon,
      required String label,
      required bool filled,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        decoration: BoxDecoration(
          color: filled ? _accent : Colors.transparent,
          border: Border.all(
              color: filled ? _accent : Colors.white38, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: filled ? Colors.white : Colors.white70),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: filled ? Colors.white : Colors.white70)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  2. LEADERSHIP (MP + MCA) with Read More popup
  // ============================================================
  Widget _buildLeadershipSection() {
    return FadeTransition(
      opacity: _sectionFade,
      child: Padding(
        key: _leadershipKey,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            _buildLeaderCard(
              name: 'Hon. Antony Kenga Mupe',
              role: 'MEMBER OF PARLIAMENT • RABAI CONSTITUENCY',
              photo: 'assets/mp_photo.png',
              preview:
                  'Welcome to our Rabai — a constituency rich in heritage, promise and unity. Together we are building a brighter future for every household in our great Rabai.',
              fullMessage:
                  'Welcome to our Rabai. I am honoured to serve this great constituency and to stand alongside each one of you as we journey towards progress.\n\nOur administration is committed to expanding educational infrastructure, empowering our youth with economic opportunities, improving healthcare access, and ensuring every road and public facility serves the people well.\n\nRabai is more than a constituency — it is a family. And I am proud to be part of this family. Thank you for your continued trust, participation and resilience. Together, we will achieve great things.',
            ),
            const SizedBox(height: 14),
            _buildLeaderCard(
              name: 'Mae Mwadena',
              role: 'MEMBER OF COUNTY ASSEMBLY',
              photo: 'assets/mca_photo.png',
              preview:
                  'Welcome to our Rabai. My focus remains on local development, grassroots participation, and ensuring quality services reach every corner of our ward.',
              fullMessage:
                  'Welcome to our Rabai. As your elected Member of County Assembly, my mandate is clear: to bring government services closer to you and to ensure that every development project genuinely impacts your daily life.\n\nI am working closely with county offices to improve water access, upgrade local health facilities, and create platforms where residents can voice their needs directly.\n\nYour feedback is the engine of our progress. Let us build our Rabai together — ward by ward, family by family.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderCard({
    required String name,
    required String role,
    required String photo,
    required String preview,
    required String fullMessage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 78,
              height: 98,
              color: const Color(0xFFE0F2F1),
              child: Image.asset(photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      color: _primary,
                      size: 40)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role,
                    style: TextStyle(
                        color: _accent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6)),
                const SizedBox(height: 2),
                Text(name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87)),
                const SizedBox(height: 6),
                Text(preview,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () =>
                      _showReadMoreDialog(name, fullMessage),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: _primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('Read Full Message →',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _primary)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showReadMoreDialog(String name, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_circle_rounded,
                      color: _primary, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(name,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.grey),
                      onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(height: 20),
              Text(message,
                  style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      height: 1.6)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close',
                        style: TextStyle(color: _primary))),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  //  SECTION HEADER
  // ============================================================
  Widget _buildSectionHeader(String title, {GlobalKey? key}) {
    return Padding(
      key: key,
      padding:
          const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 12),
      child: Row(
        children: [
          Container(width: 4, height: 22,
              decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  // ============================================================
  //  3. DISCOVER — expandable cards
  // ============================================================
  Widget _buildDiscoverCards() {
    final items = [
      _DiscoverItem(0, 'Rich Cultural Heritage', Icons.gavel_rounded,
          'Rabai is home to deep traditions and cultural diversity that continue to shape the community\'s identity.',
          'As a cornerstone of early education and community governance, Rabai retains robust traditional systems, sacred Kaya shrines and vibrant ceremonial life that stretch back centuries.'),
      _DiscoverItem(1, 'Natural Beauty', Icons.landscape_rounded,
          'Scenic landscapes, green forests and unique natural attractions define Rabai\'s environment.',
          'From the UNESCO-recognised Kaya forests to verdant agricultural ridges and breathtaking coastal hinterland views — Rabai offers genuine eco-tourism potential waiting to be discovered.'),
      _DiscoverItem(2, 'Strategic Location', Icons.map_rounded,
          'Rabai connects the interior with the coast, contributing to regional growth and trade.',
          'Positioned adjacent to key arterials linking agricultural systems to Mombasa and Kilifi markets, Rabai is an essential node in the Coast Region\'s economic geography.'),
      _DiscoverItem(3, 'Growing Development', Icons.analytics_rounded,
          'Continuous investments in roads, schools, healthcare and public infrastructure are transforming the constituency.',
          'Modern vocational labs, solar-powered health links, tarmac road extensions and digital service hubs are all part of Rabai\'s accelerating development trajectory.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: items
            .map((item) => _buildExpandableCard(item))
            .toList(),
      ),
    );
  }

  Widget _buildExpandableCard(_DiscoverItem item) {
    final expanded = _isCardExpanded[item.index];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: expanded ? _primary : Colors.grey.shade100,
            width: expanded ? 1.5 : 1.0),
        boxShadow: expanded
            ? [BoxShadow(color: _primary.withOpacity(0.08),
                blurRadius: 12, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () => setState(
                () => _isCardExpanded[item.index] = !expanded),
            leading: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      expanded ? _primary : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon,
                  color: expanded ? Colors.white : Colors.black45,
                  size: 20),
            ),
            title: Text(item.title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            trailing: AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Text(item.description,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600)),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0FAF8),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(item.extended,
                    style: const TextStyle(
                        fontSize: 12.5,
                        color: Colors.black87,
                        height: 1.45)),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ============================================================
  //  4. ECONOMIC GRID
  // ============================================================
  Widget _buildEconomicGrid() {
    final items = [
      _EcoItem(Icons.grass_rounded, 'Agriculture',
          'Cash crops, local food production and organic farming.'),
      _EcoItem(Icons.pets_rounded, 'Livestock Farming',
          'Dairy networks, poultry systems and veterinary support.'),
      _EcoItem(Icons.storefront_rounded, 'Small Businesses',
          'Vibrant local markets, retail spaces and MSME growth.'),
      _EcoItem(Icons.paid_rounded, 'Trade & Commerce',
          'Inter-county trading centres and market connectivity.'),
      _EcoItem(Icons.local_shipping_rounded, 'Transport',
          'Boda boda associations, mini-bus networks and logistics.'),
      _EcoItem(Icons.forest_rounded, 'Eco-Tourism',
          'Cultural forest excursions and ancestral landmark visits.'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.88,
        children: items.map(_buildEcoCard).toList(),
      ),
    );
  }

  Widget _buildEcoCard(_EcoItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: _primary, size: 28),
          const SizedBox(height: 8),
          Text(item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87)),
          const SizedBox(height: 4),
          Expanded(
              child: Text(item.desc,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey, height: 1.35),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  // ============================================================
  //  5. EDUCATION
  // ============================================================
  Widget _buildEducationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _statCard('70+', 'Schools',
                  Icons.school_rounded, Colors.blue.shade700)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('4', 'Technical Institutes',
                  Icons.construction_rounded, Colors.purple.shade700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _statCard('15+', 'Youth Programs',
                  Icons.groups_rounded, Colors.orange.shade700)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('100%', 'Bursary Coverage',
                  Icons.account_balance_wallet_rounded,
                  Colors.green.shade700)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded,
                        color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Text('Bursary & Scholarship',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Support Portals Active',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(
                  'Constituency educational sponsorship applications are processed through designated ward administrators.',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                      height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey, height: 1.1)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ============================================================
  //  6. HEALTHCARE
  // ============================================================
  Widget _buildHealthcareSection() {
    final cards = [
      _HealthCard('Rabai Sub-County Hospital',
          'Level 4 referral hospital with 24/7 outpatient and emergency care.',
          Icons.local_hospital_rounded),
      _HealthCard('Kokotoni Dispensary',
          'Primary care dispensary serving Kokotoni residents with essential health services.',
          Icons.health_and_safety_rounded),
      _HealthCard('Kajiwe Dispensary',
          'Community dispensary offering maternal care, immunisation and outpatient services.',
          Icons.medical_services_rounded),
      _HealthCard('Community Health Programs',
          'Community Health Volunteers handle household diagnostics, referrals and clinics.',
          Icons.volunteer_activism_rounded),
    ];
    return SizedBox(
      height: 185,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: cards.map(_buildHealthCard).toList(),
      ),
    );
  }

  Widget _buildHealthCard(_HealthCard c) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(c.icon, color: Colors.red.shade700, size: 28),
          const SizedBox(height: 10),
          Text(c.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(c.desc,
              style: const TextStyle(
                  fontSize: 11, color: Colors.grey, height: 1.3),
              maxLines: 4,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // ============================================================
  //  7. INFRASTRUCTURE
  // ============================================================
  Widget _buildInfrastructureSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(
          children: [
            _progressRow('Road Tarmac & Grading', 0.78, '78%'),
            const SizedBox(height: 16),
            _progressRow('Water Projects & Piping', 0.62, '62%'),
            const SizedBox(height: 16),
            _progressRow('Rural Electricity Grid', 0.85, '85%'),
            const SizedBox(height: 16),
            _progressRow('Public Buildings', 0.45, '45%'),
          ],
        ),
      ),
    );
  }

  Widget _progressRow(String title, double val, String pct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.bold)),
            Text(pct,
                style: const TextStyle(
                    fontSize: 12,
                    color: _primary,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: val),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
          builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              backgroundColor: Colors.grey.shade100,
              color: _primary,
              minHeight: 7,
              borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }

  // ============================================================
  //  8. GALLERY
  // ============================================================
  Widget _buildGallerySection() {
    return Column(
      children: [
        // Category chips
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _galleryCategories.length,
            itemBuilder: (_, i) {
              final sel = i == _selectedGalleryCategory;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedGalleryCategory = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color:
                          sel ? _primary : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(_galleryCategories[i]['label']!,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              sel ? Colors.white : Colors.black54)),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            itemBuilder: (_, i) {
              final catKey =
                  _galleryCategories[_selectedGalleryCategory]['key']!;
              final assetPath =
                  'assets/gallery_${catKey}_${i + 1}.png';
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey.shade100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_rounded,
                                        size: 36,
                                        color: Colors.grey.shade400),
                                    const SizedBox(height: 6),
                                    Text('Add asset:\n$assetPath',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 9.5,
                                            color:
                                                Colors.grey.shade600,
                                            fontFamily: 'monospace')),
                                  ],
                                ),
                              )),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black87
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        right: 14,
                        child: Text(
                            '${_galleryCategories[_selectedGalleryCategory]['label']} #${i + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  //  9. OPPORTUNITIES — open in new tab (url_launcher style)
  // ============================================================
  Widget _buildOpportunitiesSection() {
    final opps = [
      _Opp('Bursaries & Scholarships', 'Higher Education Support',
          Icons.monetization_on_rounded,
          'https://rabai.go.ke/bursaries'),
      _Opp('Technical Internships', 'County Infrastructure Nodes',
          Icons.card_membership_rounded,
          'https://rabai.go.ke/internships'),
      _Opp('Public Service Jobs', 'Administrative Hubs',
          Icons.work_rounded,
          'https://rabai.go.ke/jobs'),
      _Opp('Women Empowerment', 'Micro-Financing Trade Tools',
          Icons.assignment_ind_rounded,
          'https://rabai.go.ke/women'),
    ];

    return Column(
      children: [
        SizedBox(
          height: 155,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children:
                opps.map((o) => _buildOppCard(o)).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: _primary),
            ),
            icon: const Icon(Icons.open_in_new_rounded,
                color: _primary, size: 16),
            label: const Text('View All Opportunities',
                style: TextStyle(
                    color: _primary, fontWeight: FontWeight.bold)),
            onPressed: () => _openUrl('https://rabai.go.ke/opportunities'),
          ),
        ),
      ],
    );
  }

  Widget _buildOppCard(_Opp o) {
    return GestureDetector(
      onTap: () => _openUrl(o.url),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(o.icon, color: _accent, size: 24),
                const Icon(Icons.open_in_new_rounded,
                    size: 14, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(o.title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(o.dept,
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 6),
            Text('Tap to open →',
                style: TextStyle(
                    fontSize: 10,
                    color: _primary.withOpacity(0.7),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// Opens a URL — uses url_launcher in real app; shows dialog here
  void _openUrl(String url) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Open Link',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.open_in_new_rounded,
                color: _primary, size: 36),
            const SizedBox(height: 10),
            Text('This will open in your browser:',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(url,
                style: const TextStyle(
                    fontSize: 11,
                    color: _primary,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.pop(context);
              // TODO: launch(url) — add url_launcher package
            },
            child: const Text('Open'),
          )
        ],
      ),
    );
  }

  // ============================================================
  //  10. OUR CULTURE — clickable cards with detail popup
  // ============================================================
  Widget _buildCultureSection() {
    final cultures = [
      _CultureItem(
          'Traditions & Celebrations',
          Icons.gavel_rounded,
          'Rabai communities observe a rich calendar of traditional ceremonies including initiation rites, harvest celebrations, and ancestral remembrance events that bind generations together.',
          Colors.orange.shade700),
      _CultureItem(
          'Local Languages',
          Icons.translate_rounded,
          'The Rabai dialect of the Mijikenda Bantu language group is a living treasure. Oral literature, proverbs and songs carry the community\'s wisdom across generations.',
          Colors.blue.shade700),
      _CultureItem(
          'Community Values',
          Icons.favorite_rounded,
          'Ubuntu — the belief that "I am because we are" — underpins Rabai community life. Collective welfare, respect for elders and hospitality are cornerstones of local culture.',
          Colors.red.shade700),
      _CultureItem(
          'Historical Landmarks',
          Icons.account_balance_rounded,
          'From the Kaya Rabai sacred forest to early mission stations, Rabai\'s landscape holds physical monuments to its centuries-long history and cultural evolution.',
          Colors.green.shade700),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
        children: cultures.map(_buildCultureCard).toList(),
      ),
    );
  }

  Widget _buildCultureCard(_CultureItem c) {
    return GestureDetector(
      onTap: () => _showCultureDetail(c),
      child: Container(
        decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100)),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: c.color.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: Icon(c.icon, color: c.color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(c.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            Text('Tap to learn more',
                style: TextStyle(
                    fontSize: 9.5,
                    color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  void _showCultureDetail(_CultureItem c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: c.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(c.icon, color: c.color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(c.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(c.detail,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 13)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //  11. OUR HISTORY
  // ============================================================
  Widget _buildHistorySection() {
    final events = [
      _HistoryEvent('Pre-Colonial Era',
          'c. 1500s',
          'The Rabai people, part of the Mijikenda group, settled the coastal hinterland establishing the Kaya Rabai — a fortified sacred forest settlement that served as the political and spiritual heartland of the community.'),
      _HistoryEvent('Mission & Early Education',
          '1844',
          'German missionaries Johann Ludwig Krapf and Johannes Rebmann established a mission station at Rabai, making it one of the earliest sites of modern education and Christian mission activity in East Africa.'),
      _HistoryEvent('Colonial Period',
          '1895–1963',
          'Rabai was incorporated into the British East Africa Protectorate. The period saw the construction of early roads and administrative structures, though also the disruption of traditional governance systems.'),
      _HistoryEvent('Independence & Integration',
          '1963',
          'With Kenya\'s independence, Rabai was integrated into the new nation. The constituency began its journey of self-governance, representation and development under successive parliamentary leaders.'),
      _HistoryEvent('Modern Development Era',
          '2010–Present',
          'Under the new constitutional framework, Rabai Constituency has benefited from devolution, increased constituency development funds and active community participation — driving visible transformation across all sectors.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: events.asMap().entries.map((e) {
          return _historyEventTile(e.value, e.key == events.length - 1);
        }).toList(),
      ),
    );
  }

  Widget _historyEventTile(_HistoryEvent event, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline spine
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: _primary, width: 2)),
            ),
            if (!isLast)
              Container(
                  width: 2,
                  height: 80,
                  color: _primary.withOpacity(0.15)),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(event.year,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(event.title,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.desc,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.45)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  //  12. HISTORICAL SITES
  // ============================================================
  Widget _buildHistoricalSitesSection() {
    final sites = [
      _Site('Kaya Rabai Sacred Forest',
          Icons.forest_rounded,
          'A UNESCO World Heritage component, Kaya Rabai is the ancient fortified forest settlement of the Rabai Mijikenda people. It remains a living spiritual and cultural landmark.',
          Colors.green.shade700),
      _Site('Rabai Mission Station',
          Icons.church_rounded,
          'Established in 1844 by missionaries Krapf and Rebmann, this is one of the oldest mission stations in East Africa and the site of early Swahili scriptural work.',
          Colors.brown.shade600),
      _Site('Shimba Hills Viewpoint',
          Icons.landscape_rounded,
          'The Shimba Hills boundary areas offer panoramic views across the Rabai landscape, blending natural beauty with ecological significance.',
          Colors.teal.shade700),
      _Site('Traditional Kaya Elders\' Council Grounds',
          Icons.gavel_rounded,
          'The original governance grounds where Kaya elders — the Vaya — deliberated community affairs, resolved disputes and performed sacred rituals.',
          Colors.orange.shade700),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: sites.map(_buildSiteCard).toList(),
      ),
    );
  }

  Widget _buildSiteCard(_Site s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: s.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(s.icon, color: s.color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(s.desc,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  //  13. COMMUNITY IMPACT COUNTER
  // ============================================================
  Widget _buildImpactSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('Building a Better Rabai Together',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _counter('4,500+', 'Students Supported'),
              _counter('32+', 'Development Projects'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _counter('12+', 'Community Programs'),
              _counter('18,000+', 'Beneficiaries'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counter(String num, String label) => Column(
        children: [
          Text(num,
              style: const TextStyle(
                  color: _accent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 11)),
        ],
      );

  // ============================================================
  //  14. FEEDBACK FORM
  // ============================================================
  Widget _buildFeedbackForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ]),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share your ideas, suggestions and concerns to help improve our constituency.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: _inputDeco(
                    'Full Name', Icons.person_outline_rounded),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDeco('Email / Phone',
                    Icons.alternate_email_rounded),
                validator: (v) =>
                    (v == null || !v.contains('@'))
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: _inputDeco('Your Message / Concern',
                    Icons.chat_bubble_outline_rounded),
                validator: (v) =>
                    (v == null || v.trim().length < 5)
                        ? 'Please add more detail'
                        : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text('Feedback submitted. Thank you!'),
                          ],
                        ),
                        backgroundColor: _primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    _nameController.clear();
                    _emailController.clear();
                    _messageController.clear();
                  }
                },
                child: const Text('Submit Feedback',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 18, color: _primary),
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primary)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.red.shade200)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.red.shade700)),
    );
  }

  // ============================================================
  //  15. FOOTER
  // ============================================================
  Widget _buildFooter() {
    return Container(
      color: Colors.grey.shade900,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo row
          Row(
            children: [
              Image.asset('assets/logo.png',
                  height: 36,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.white54,
                      size: 28)),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('MY RABAI',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                  Text('"Connecting. Informing. Empowering."',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('OFFICIAL CONTACTS',
              style: TextStyle(
                  color: _accent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const SizedBox(height: 6),
          _footerContact(Icons.phone_android_rounded,
              '+254 700 000000 / +254 711 000000'),
          const SizedBox(height: 4),
          _footerContact(Icons.email_outlined,
              'info@rabai.go.ke / support@rabai.go.ke'),
          const Divider(color: Colors.white12, height: 28),
          const Text('QUICK LINKS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink('Leadership',
                  () => _scrollToSection(_leadershipKey)),
              _footerLink('Discover',
                  () => _scrollToSection(_discoverKey)),
              _footerLink('Our History',
                  () => _scrollToSection(_historyKey)),
              _footerLink('Historical Sites',
                  () => _scrollToSection(_sitesKey)),
              _footerLink('Opportunities',
                  () => _scrollToSection(_opportunitiesKey)),
              _footerLink('Feedback',
                  () => _scrollToSection(_feedbackKey)),
            ],
          ),
          const Divider(color: Colors.white12, height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('© 2026 Rabai Constituency',
                  style: TextStyle(
                      color: Colors.white38, fontSize: 10)),
              Row(
                children: [
                  Icons.facebook_rounded,
                  Icons.language_rounded,
                  Icons.alternate_email_rounded
                ]
                    .map((ic) => Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Icon(ic,
                              color: Colors.white38, size: 18),
                        ))
                    .toList(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _footerContact(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 13, color: Colors.white54),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 12)),
        ],
      );

  Widget _footerLink(String text, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 3, horizontal: 2),
          child: Text(text,
              style: const TextStyle(
                  color: Color(0xFFB2DFDB),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline)),
        ),
      );
}

// ============================================================
//  DATA MODELS (internal)
// ============================================================

class _DiscoverItem {
  final int index;
  final String title, description, extended;
  final IconData icon;
  const _DiscoverItem(
      this.index, this.title, this.icon, this.description, this.extended);
}

class _EcoItem {
  final IconData icon;
  final String title, desc;
  const _EcoItem(this.icon, this.title, this.desc);
}

class _HealthCard {
  final String name, desc;
  final IconData icon;
  const _HealthCard(this.name, this.desc, this.icon);
}

class _Opp {
  final String title, dept, url;
  final IconData icon;
  const _Opp(this.title, this.dept, this.icon, this.url);
}

class _CultureItem {
  final String title, detail;
  final IconData icon;
  final Color color;
  const _CultureItem(this.title, this.icon, this.detail, this.color);
}

class _HistoryEvent {
  final String title, year, desc;
  const _HistoryEvent(this.title, this.year, this.desc);
}

class _Site {
  final String name, desc;
  final IconData icon;
  final Color color;
  const _Site(this.name, this.icon, this.desc, this.color);
}