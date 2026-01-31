import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

class UAVDatabaseScreen extends StatefulWidget {
  const UAVDatabaseScreen({super.key});

  @override
  State<UAVDatabaseScreen> createState() => _UAVDatabaseScreenState();
}

class _UAVDatabaseScreenState extends State<UAVDatabaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'combat',
    'reconnaissance',
    'kamikaze',
    'commercial',
    'fpv',
  ];

  final Map<String, String> _categoryNames = {
    'all': 'ทั้งหมด',
    'combat': 'UCAV รบ',
    'reconnaissance': 'ลาดตระเวน',
    'kamikaze': 'Loitering/Kamikaze',
    'commercial': 'พาณิชย์/ดัดแปลง',
    'fpv': 'FPV',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<UAVData> get _filteredDrones {
    var drones = _allDrones;

    if (_selectedCategory != 'all') {
      drones = drones.where((d) => d.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      drones = drones.where((d) =>
        d.name.toLowerCase().contains(query) ||
        d.manufacturer.toLowerCase().contains(query) ||
        d.country.toLowerCase().contains(query)
      ).toList();
    }

    return drones;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'UAV DATABASE',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: (value) => setState(() => _searchQuery = value),
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาชื่อ, ผู้ผลิต, ประเทศ...',
                        hintStyle: TextStyle(
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  // Category Tabs
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(_categoryNames[cat]!),
                            labelStyle: TextStyle(
                              color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            backgroundColor: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                            selectedColor: AppColors.primary,
                            checkmarkColor: Colors.white,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              // Stats Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: isDark ? AppColors.surface.withAlpha(100) : AppColorsLight.surfaceLight,
                child: Row(
                  children: [
                    Icon(
                      Icons.flight,
                      size: 16,
                      color: isDark ? AppColors.radar : AppColorsLight.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'พบ ${_filteredDrones.length} รายการ',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber, size: 14, color: AppColors.danger),
                          const SizedBox(width: 4),
                          Text(
                            'ข้อมูล EW',
                            style: TextStyle(
                              color: AppColors.danger,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Drone List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredDrones.length,
                  itemBuilder: (context, index) {
                    return _buildDroneCard(_filteredDrones[index], isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDroneCard(UAVData drone, bool isDark) {
    return GestureDetector(
      onTap: () => _showDroneDetails(drone, isDark),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  colors: [
                    _getCategoryColor(drone.category).withAlpha(40),
                    _getCategoryColor(drone.category).withAlpha(20),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Real Image or Placeholder
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: drone.imageUrl != null
                        ? Image.network(
                            drone.imageUrl!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            headers: const {
                              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                              'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 160,
                                color: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                    color: _getCategoryColor(drone.category),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 160,
                                color: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                                child: Center(
                                  child: Icon(
                                    _getDroneIcon(drone.category),
                                    size: 60,
                                    color: _getCategoryColor(drone.category).withAlpha(100),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 160,
                            child: Center(
                              child: Icon(
                                _getDroneIcon(drone.category),
                                size: 60,
                                color: _getCategoryColor(drone.category).withAlpha(100),
                              ),
                            ),
                          ),
                  ),
                  // Country Flag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surface.withAlpha(230) : Colors.white.withAlpha(230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            drone.flag,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            drone.country,
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(drone.category),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _categoryNames[drone.category] ?? drone.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Threat Level
                  if (drone.threatLevel != null)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getThreatColor(drone.threatLevel!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              drone.threatLevel!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drone.name,
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drone.manufacturer,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Specs
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSpecChip(Icons.straighten, drone.wingspan, isDark),
                      _buildSpecChip(Icons.speed, drone.maxSpeed, isDark),
                      _buildSpecChip(Icons.height, drone.ceiling, isDark),
                      _buildSpecChip(Icons.timer, drone.endurance, isDark),
                    ],
                  ),

                  // EW Info Preview
                  if (drone.controlFreq != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withAlpha(15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.danger.withAlpha(50)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.wifi_tethering, size: 18, color: AppColors.danger),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Control Freq',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  drone.controlFreq!,
                                  style: TextStyle(
                                    color: AppColors.danger,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDroneDetails(UAVData drone, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColorsLight.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.border : AppColorsLight.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Large Image
                if (drone.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      drone.imageUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      headers: const {
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                        'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: _getCategoryColor(drone.category),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getDroneIcon(drone.category),
                                  size: 60,
                                  color: _getCategoryColor(drone.category),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ไม่สามารถโหลดรูปได้',
                                  style: TextStyle(
                                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    Text(drone.flag, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drone.name,
                            style: TextStyle(
                              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${drone.manufacturer} • ${drone.country}',
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                if (drone.description != null) ...[
                  Text(
                    drone.description!,
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Specifications
                _buildDetailSection('SPECIFICATIONS', Icons.settings, [
                  _buildDetailRow('Wingspan', drone.wingspan, isDark),
                  _buildDetailRow('Length', drone.length ?? 'N/A', isDark),
                  _buildDetailRow('MTOW', drone.mtow ?? 'N/A', isDark),
                  _buildDetailRow('Max Speed', drone.maxSpeed, isDark),
                  _buildDetailRow('Cruise Speed', drone.cruiseSpeed ?? 'N/A', isDark),
                  _buildDetailRow('Ceiling', drone.ceiling, isDark),
                  _buildDetailRow('Endurance', drone.endurance, isDark),
                  _buildDetailRow('Range', drone.range ?? 'N/A', isDark),
                ], isDark),
                const SizedBox(height: 20),

                // EW Information
                _buildDetailSection('EW INFORMATION', Icons.wifi_tethering, [
                  _buildDetailRow('Control Freq', drone.controlFreq ?? 'Classified', isDark),
                  _buildDetailRow('Video Link', drone.videoFreq ?? 'Classified', isDark),
                  _buildDetailRow('GPS Dependent', drone.gpsDependent ?? 'Unknown', isDark),
                  _buildDetailRow('Encryption', drone.encryption ?? 'Unknown', isDark),
                  _buildDetailRow('Autonomy', drone.autonomy ?? 'Unknown', isDark),
                ], isDark, isWarning: true),
                const SizedBox(height: 20),

                // Payload
                if (drone.payload != null) ...[
                  _buildDetailSection('PAYLOAD', Icons.inventory_2, [
                    _buildDetailRow('Capacity', drone.payloadCapacity ?? 'N/A', isDark),
                    ...drone.payload!.map((p) => _buildDetailRow('•', p, isDark)),
                  ], isDark),
                  const SizedBox(height: 20),
                ],

                // Combat History
                if (drone.combatHistory != null) ...[
                  _buildDetailSection('COMBAT HISTORY', Icons.history, [
                    ...drone.combatHistory!.map((h) => _buildDetailRow('•', h, isDark)),
                  ], isDark),
                  const SizedBox(height: 20),
                ],

                // Counter-UAS
                if (drone.counterMeasures != null) ...[
                  _buildDetailSection('COUNTER-UAS', Icons.shield, [
                    ...drone.counterMeasures!.map((c) => _buildDetailRow('•', c, isDark)),
                  ], isDark, isSuccess: true),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, IconData icon, List<Widget> children, bool isDark, {bool isWarning = false, bool isSuccess = false}) {
    Color accentColor = isDark ? AppColors.primary : AppColorsLight.primary;
    if (isWarning) accentColor = AppColors.danger;
    if (isSuccess) accentColor = AppColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: accentColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accentColor.withAlpha(10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: accentColor.withAlpha(30)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'combat': return AppColors.danger;
      case 'reconnaissance': return AppColors.primary;
      case 'kamikaze': return AppColors.warning;
      case 'commercial': return AppColors.success;
      case 'fpv': return AppColors.tabLearning;
      default: return AppColors.textMuted;
    }
  }

  IconData _getDroneIcon(String category) {
    switch (category) {
      case 'combat': return Icons.flight_takeoff;
      case 'reconnaissance': return Icons.remove_red_eye;
      case 'kamikaze': return Icons.gps_fixed;
      case 'commercial': return Icons.toys;
      case 'fpv': return Icons.videogame_asset;
      default: return Icons.flight;
    }
  }

  Color _getThreatColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical': return Colors.red.shade900;
      case 'high': return AppColors.danger;
      case 'medium': return AppColors.warning;
      case 'low': return AppColors.success;
      default: return AppColors.textMuted;
    }
  }

  // ==========================================
  // UAV DATABASE
  // ==========================================
  final List<UAVData> _allDrones = [
    // === TURKEY ===
    UAVData(
      name: 'Bayraktar TB2',
      manufacturer: 'Baykar',
      country: 'Turkey',
      flag: '🇹🇷',
      category: 'combat',
      wingspan: '12 m',
      length: '6.5 m',
      mtow: '700 kg',
      maxSpeed: '220 km/h',
      cruiseSpeed: '130 km/h',
      ceiling: '8,200 m',
      endurance: '27 hr',
      range: '150 km',
      controlFreq: '800-900 MHz / C-Band (Satcom)',
      videoFreq: 'C-Band / Ku-Band',
      gpsDependent: 'Yes (Primary)',
      encryption: 'AES-256',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '150 kg',
      payload: ['MAM-L (Smart Munition)', 'MAM-C (Laser-guided)', 'CIRIT Rockets', 'EO/IR Gimbal'],
      threatLevel: 'HIGH',
      description: 'Medium-altitude long-endurance (MALE) UAV ที่ประสบความสำเร็จในสงครามยูเครน สามารถทำลายยานเกราะและระบบป้องกันภัยทางอากาศได้อย่างมีประสิทธิภาพ',
      combatHistory: ['Libya 2019-2020', 'Syria 2020', 'Nagorno-Karabakh 2020', 'Ukraine 2022-2024'],
      counterMeasures: ['GPS Jamming', 'C-Band Disruption', 'EW Systems (Krasukha)', 'SAM Systems'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Bayraktar_TB2_UAV.jpg/800px-Bayraktar_TB2_UAV.jpg',
    ),
    UAVData(
      name: 'Bayraktar Akinci',
      manufacturer: 'Baykar',
      country: 'Turkey',
      flag: '🇹🇷',
      category: 'combat',
      wingspan: '20 m',
      length: '12.2 m',
      mtow: '6,000 kg',
      maxSpeed: '361 km/h',
      cruiseSpeed: '240 km/h',
      ceiling: '12,200 m',
      endurance: '24 hr',
      range: '300 km',
      controlFreq: 'C-Band / Ku-Band Satcom',
      videoFreq: 'Ku-Band / Ka-Band',
      gpsDependent: 'Yes + INS Backup',
      encryption: 'Military Grade',
      autonomy: 'High Autonomy',
      payloadCapacity: '1,350 kg',
      payload: ['SOM-A Cruise Missile', 'MAM-T', 'Mk-82/83 Bombs', 'AESA Radar'],
      threatLevel: 'CRITICAL',
      description: 'Heavy UCAV รุ่นใหม่ล่าสุดของ Baykar สามารถบรรทุกอาวุธหนักและมีระบบ AESA Radar',
      combatHistory: ['Ukraine 2024'],
      counterMeasures: ['Advanced EW Required', 'Multi-layer Air Defense'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Bayraktar_Akıncı_%28cropped%29.jpg/800px-Bayraktar_Akıncı_%28cropped%29.jpg',
    ),

    // === USA ===
    UAVData(
      name: 'MQ-9 Reaper',
      manufacturer: 'General Atomics',
      country: 'USA',
      flag: '🇺🇸',
      category: 'combat',
      wingspan: '20 m',
      length: '11 m',
      mtow: '4,760 kg',
      maxSpeed: '482 km/h',
      cruiseSpeed: '313 km/h',
      ceiling: '15,200 m',
      endurance: '27 hr',
      range: '1,850 km',
      controlFreq: 'Ku-Band Satcom',
      videoFreq: 'C-Band / Ku-Band',
      gpsDependent: 'Yes + INS',
      encryption: 'NSA Type 1',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '1,700 kg',
      payload: ['AGM-114 Hellfire', 'GBU-12 Paveway II', 'GBU-38 JDAM', 'AIM-9X (Block 5)'],
      threatLevel: 'CRITICAL',
      description: 'Hunter-killer UAV หลักของกองทัพสหรัฐ ใช้งานอย่างแพร่หลายในการต่อต้านการก่อการร้าย',
      combatHistory: ['Afghanistan', 'Iraq', 'Syria', 'Yemen', 'Libya', 'Somalia'],
      counterMeasures: ['High-end EW Systems', 'S-400 Class SAM'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/c/c0/MQ-9_Reaper_in_flight_%282007%29.jpg?w=800',
    ),
    UAVData(
      name: 'RQ-4 Global Hawk',
      manufacturer: 'Northrop Grumman',
      country: 'USA',
      flag: '🇺🇸',
      category: 'reconnaissance',
      wingspan: '39.9 m',
      length: '14.5 m',
      mtow: '14,628 kg',
      maxSpeed: '629 km/h',
      cruiseSpeed: '575 km/h',
      ceiling: '18,300 m',
      endurance: '34 hr',
      range: '22,780 km',
      controlFreq: 'Ku-Band Satcom',
      videoFreq: 'UHF / Ku-Band',
      gpsDependent: 'Yes + INS',
      encryption: 'NSA Type 1',
      autonomy: 'High Autonomy',
      payloadCapacity: '1,360 kg',
      payload: ['EISS Sensor Suite', 'SAR/MTI Radar', 'SIGINT Package'],
      threatLevel: 'HIGH',
      description: 'High-altitude long-endurance (HALE) ISR platform ที่บินได้สูงที่สุดในโลก',
      combatHistory: ['Global Operations'],
      counterMeasures: ['Advanced SAM (S-400)', 'High-altitude Interceptors'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/d/d5/Global_Hawk_1.jpg?w=800',
    ),
    UAVData(
      name: 'MQ-1C Gray Eagle',
      manufacturer: 'General Atomics',
      country: 'USA',
      flag: '🇺🇸',
      category: 'combat',
      wingspan: '17 m',
      length: '8 m',
      mtow: '1,633 kg',
      maxSpeed: '309 km/h',
      cruiseSpeed: '270 km/h',
      ceiling: '8,900 m',
      endurance: '25 hr',
      range: '370 km',
      controlFreq: 'C-Band / Ku-Band',
      videoFreq: 'C-Band',
      gpsDependent: 'Yes + INS',
      encryption: 'AES-256',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '488 kg',
      payload: ['AGM-114 Hellfire', 'GBU-44 Viper Strike', 'Stinger (Future)'],
      threatLevel: 'HIGH',
      description: 'Army version ของ Predator สำหรับสนับสนุนกองกำลังภาคพื้นดิน',
      combatHistory: ['Afghanistan', 'Iraq', 'Provided to Ukraine 2024'],
      counterMeasures: ['Standard EW', 'SHORAD Systems'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/9/9a/MQ-1C_Gray_Eagle.jpg/800px-MQ-1C_Gray_Eagle.jpg',
    ),
    UAVData(
      name: 'Switchblade 600',
      manufacturer: 'AeroVironment',
      country: 'USA',
      flag: '🇺🇸',
      category: 'kamikaze',
      wingspan: '1.3 m',
      length: '1.3 m',
      mtow: '23 kg',
      maxSpeed: '185 km/h',
      cruiseSpeed: '100 km/h',
      ceiling: '4,500 m',
      endurance: '40 min',
      range: '80 km',
      controlFreq: 'AES Encrypted Link',
      videoFreq: 'Digital Encrypted',
      gpsDependent: 'Yes + Lock-on',
      encryption: 'AES-256',
      autonomy: 'Lock-on after launch',
      payloadCapacity: '~7 kg Warhead',
      payload: ['Anti-armor Warhead (Javelin-derived)'],
      threatLevel: 'MEDIUM',
      description: 'Loitering munition ที่สามารถทำลายรถถังได้ ส่งให้ยูเครนจำนวนมาก',
      combatHistory: ['Ukraine 2022-2024'],
      counterMeasures: ['GPS Jamming', 'RF Jamming', 'Small Arms'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/9/93/Switchblade_Launcher_and_Missile.jpg/800px-Switchblade_Launcher_and_Missile.jpg',
    ),

    // === IRAN ===
    UAVData(
      name: 'Shahed-136 (Geran-2)',
      manufacturer: 'HESA',
      country: 'Iran',
      flag: '🇮🇷',
      category: 'kamikaze',
      wingspan: '2.5 m',
      length: '3.5 m',
      mtow: '200 kg',
      maxSpeed: '185 km/h',
      cruiseSpeed: '150 km/h',
      ceiling: '4,000 m',
      endurance: '~2,500 km range',
      range: '2,500 km',
      controlFreq: 'Pre-programmed (No C2)',
      videoFreq: 'None',
      gpsDependent: 'GLONASS + INS',
      encryption: 'N/A (Autonomous)',
      autonomy: 'Fully Autonomous',
      payloadCapacity: '40-50 kg Warhead',
      payload: ['HE Fragmentation Warhead'],
      threatLevel: 'HIGH',
      description: 'Kamikaze drone ราคาถูกที่รัสเซียใช้โจมตียูเครนเป็นจำนวนมาก (เรียก Geran-2)',
      combatHistory: ['Ukraine 2022-2024 (by Russia)', 'Middle East'],
      counterMeasures: ['GPS/GLONASS Jamming', 'MANPADS', 'Small Arms', 'Gepard SPAAG'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Shahed_136_drone.jpg/800px-Shahed_136_drone.jpg',
    ),
    UAVData(
      name: 'Mohajer-6',
      manufacturer: 'Qods Aviation',
      country: 'Iran',
      flag: '🇮🇷',
      category: 'combat',
      wingspan: '10 m',
      length: '5.6 m',
      mtow: '670 kg',
      maxSpeed: '200 km/h',
      cruiseSpeed: '150 km/h',
      ceiling: '5,500 m',
      endurance: '12 hr',
      range: '200 km',
      controlFreq: 'C-Band',
      videoFreq: 'L-Band',
      gpsDependent: 'Yes',
      encryption: 'Basic',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '100 kg',
      payload: ['Qaem PGM', 'Almas Missile', 'EO/IR Camera'],
      threatLevel: 'MEDIUM',
      description: 'Iranian combat UAV ที่ส่งให้รัสเซียและใช้โดย Houthi',
      combatHistory: ['Yemen (Houthi)', 'Ukraine (by Russia)'],
      counterMeasures: ['Standard EW', 'SHORAD'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/6/69/Mohajer-6_MAKS-2019.jpg/800px-Mohajer-6_MAKS-2019.jpg',
    ),

    // === RUSSIA ===
    UAVData(
      name: 'Orlan-10',
      manufacturer: 'Special Technology Center',
      country: 'Russia',
      flag: '🇷🇺',
      category: 'reconnaissance',
      wingspan: '3.1 m',
      length: '1.8 m',
      mtow: '18 kg',
      maxSpeed: '150 km/h',
      cruiseSpeed: '90-110 km/h',
      ceiling: '5,000 m',
      endurance: '16 hr',
      range: '120 km',
      controlFreq: '868 MHz / 900 MHz',
      videoFreq: '1.2-1.4 GHz',
      gpsDependent: 'GLONASS + Backup',
      encryption: 'Basic Russian',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '5 kg',
      payload: ['EO/IR Camera', 'SIGINT Module', 'Relay Package'],
      threatLevel: 'LOW',
      description: 'Tactical recon UAV หลักของรัสเซีย ใช้มากที่สุดในยูเครน',
      combatHistory: ['Syria', 'Ukraine 2022-2024'],
      counterMeasures: ['Standard GPS Jamming', 'RF Jamming', 'Small Arms', 'FPV Interception'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Army-2022-304.jpg/800px-Army-2022-304.jpg',
    ),
    UAVData(
      name: 'Lancet',
      manufacturer: 'ZALA Aero',
      country: 'Russia',
      flag: '🇷🇺',
      category: 'kamikaze',
      wingspan: '2.4 m',
      length: '1.2 m',
      mtow: '12 kg',
      maxSpeed: '300 km/h',
      cruiseSpeed: '110 km/h',
      ceiling: '5,000 m',
      endurance: '40 min',
      range: '40 km',
      controlFreq: '900 MHz / 1.4 GHz',
      videoFreq: '1.2-1.4 GHz',
      gpsDependent: 'GLONASS + Visual Lock',
      encryption: 'Basic',
      autonomy: 'Lock-on capability',
      payloadCapacity: '3-5 kg Warhead',
      payload: ['HE Fragmentation', 'Shaped Charge (HEAT)'],
      threatLevel: 'MEDIUM',
      description: 'Russian loitering munition ที่ทำลายยุทโธปกรณ์ยูเครนได้มาก',
      combatHistory: ['Ukraine 2022-2024'],
      counterMeasures: ['EW Jamming', 'Laser Dazzlers', 'Small Arms'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/0/0f/ZALA_Lancet_-_KUB_-_Army2021-7.jpg/800px-ZALA_Lancet_-_KUB_-_Army2021-7.jpg',
    ),

    // === ISRAEL ===
    UAVData(
      name: 'IAI Heron TP (Eitan)',
      manufacturer: 'Israel Aerospace Industries',
      country: 'Israel',
      flag: '🇮🇱',
      category: 'reconnaissance',
      wingspan: '26 m',
      length: '14 m',
      mtow: '5,400 kg',
      maxSpeed: '370 km/h',
      cruiseSpeed: '296 km/h',
      ceiling: '13,700 m',
      endurance: '36 hr',
      range: '1,000+ km',
      controlFreq: 'Satcom (Various Bands)',
      videoFreq: 'Ku-Band',
      gpsDependent: 'Yes + INS',
      encryption: 'Military Grade',
      autonomy: 'High Autonomy',
      payloadCapacity: '1,000 kg',
      payload: ['EO/IR Payload', 'SAR Radar', 'SIGINT', 'ELINT'],
      threatLevel: 'HIGH',
      description: 'MALE UAV ขนาดใหญ่ที่สุดของอิสราเอล สามารถติดอาวุธได้',
      combatHistory: ['Gaza Operations', 'Various'],
      counterMeasures: ['Advanced EW', 'High-end SAM'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/2/25/IAI_Eitan_UAV.jpg/800px-IAI_Eitan_UAV.jpg',
    ),
    UAVData(
      name: 'Harop',
      manufacturer: 'IAI',
      country: 'Israel',
      flag: '🇮🇱',
      category: 'kamikaze',
      wingspan: '3 m',
      length: '2.5 m',
      mtow: '135 kg',
      maxSpeed: '417 km/h',
      cruiseSpeed: '185 km/h',
      ceiling: '4,600 m',
      endurance: '6 hr',
      range: '1,000 km',
      controlFreq: 'Encrypted Datalink',
      videoFreq: 'EO Seeker',
      gpsDependent: 'Yes + EO Terminal',
      encryption: 'Military Grade',
      autonomy: 'Fire-and-forget / Man-in-loop',
      payloadCapacity: '23 kg Warhead',
      payload: ['Anti-radiation Seeker', 'HE Warhead'],
      threatLevel: 'HIGH',
      description: 'Loitering munition anti-radiation ที่ออกแบบมาเพื่อทำลายระบบ radar',
      combatHistory: ['Nagorno-Karabakh 2020 (Azerbaijan)'],
      counterMeasures: ['Radar Shutdown', 'Decoys', 'CIWS'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/b/bb/IAI_Harop_PAS_2013_01.jpg/800px-IAI_Harop_PAS_2013_01.jpg',
    ),

    // === CHINA ===
    UAVData(
      name: 'Wing Loong II',
      manufacturer: 'CAIG',
      country: 'China',
      flag: '🇨🇳',
      category: 'combat',
      wingspan: '20.5 m',
      length: '11.3 m',
      mtow: '4,200 kg',
      maxSpeed: '370 km/h',
      cruiseSpeed: '200 km/h',
      ceiling: '9,000 m',
      endurance: '20 hr',
      range: '200 km (C2)',
      controlFreq: 'C-Band / Satcom',
      videoFreq: 'Ku-Band',
      gpsDependent: 'BeiDou + GPS',
      encryption: 'Chinese Standard',
      autonomy: 'Semi-autonomous',
      payloadCapacity: '480 kg',
      payload: ['BA-7 ATM', 'Blue Arrow', 'LS-6 Bomb', 'YZ-212 Bomb'],
      threatLevel: 'HIGH',
      description: 'MQ-9 equivalent ของจีน ส่งออกไปหลายประเทศในตะวันออกกลางและแอฟริกา',
      combatHistory: ['Libya', 'UAE', 'Egypt', 'Saudi Arabia'],
      counterMeasures: ['Standard EW', 'SAM Systems'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/8/84/CAIG_Wing_Loong_II_at_Airshow_China_2016.jpg/800px-CAIG_Wing_Loong_II_at_Airshow_China_2016.jpg',
    ),
    UAVData(
      name: 'DJI Mavic 3',
      manufacturer: 'DJI',
      country: 'China',
      flag: '🇨🇳',
      category: 'commercial',
      wingspan: '0.38 m (folded)',
      length: '0.22 m',
      mtow: '0.9 kg',
      maxSpeed: '75 km/h',
      cruiseSpeed: '50 km/h',
      ceiling: '6,000 m',
      endurance: '46 min',
      range: '15 km',
      controlFreq: '2.4 GHz / 5.8 GHz',
      videoFreq: '2.4 GHz / 5.8 GHz (OcuSync 3)',
      gpsDependent: 'Yes + Visual',
      encryption: 'AES-256 (DJI)',
      autonomy: 'Return-to-home',
      payloadCapacity: '~200 g (Modified)',
      payload: ['4/3 CMOS Camera', 'Modified: Grenades, Bombs'],
      threatLevel: 'MEDIUM',
      description: 'Consumer drone ที่ถูกใช้แพร่หลายในสงครามยูเครน ทั้งสองฝ่าย',
      combatHistory: ['Ukraine 2022-2024 (Both sides)'],
      counterMeasures: ['DJI Aeroscope', '2.4/5.8 GHz Jamming', 'DroneGun'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/6/6d/DJI_Mavic_3_drone_in_flight.jpg/800px-DJI_Mavic_3_drone_in_flight.jpg',
    ),
    UAVData(
      name: 'DJI Matrice 30T',
      manufacturer: 'DJI',
      country: 'China',
      flag: '🇨🇳',
      category: 'commercial',
      wingspan: '0.67 m',
      length: '0.47 m',
      mtow: '3.77 kg',
      maxSpeed: '82 km/h',
      cruiseSpeed: '55 km/h',
      ceiling: '7,000 m',
      endurance: '41 min',
      range: '15 km',
      controlFreq: '2.4 GHz / 5.8 GHz (O3)',
      videoFreq: '2.4 GHz / 5.8 GHz',
      gpsDependent: 'Yes + RTK option',
      encryption: 'AES-256',
      autonomy: 'Waypoint + RTH',
      payloadCapacity: 'N/A (Integrated)',
      payload: ['Thermal Camera', 'Zoom Camera', 'Laser Rangefinder'],
      threatLevel: 'LOW',
      description: 'Enterprise drone สำหรับ ISR ดัดแปลงสำหรับการทหาร',
      combatHistory: ['Ukraine 2022-2024'],
      counterMeasures: ['DJI Aeroscope', 'RF Jamming', 'GPS Spoofing'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/7/7d/DJI_Matrice_300_RTK.jpg/800px-DJI_Matrice_300_RTK.jpg',
    ),

    // === UKRAINE ===
    UAVData(
      name: 'Punisher',
      manufacturer: 'UA Dynamics',
      country: 'Ukraine',
      flag: '🇺🇦',
      category: 'combat',
      wingspan: '2.3 m',
      length: '1.3 m',
      mtow: '7.5 kg',
      maxSpeed: '120 km/h',
      cruiseSpeed: '70 km/h',
      ceiling: '400 m',
      endurance: '3 hr',
      range: '48 km',
      controlFreq: '868 MHz Encrypted',
      videoFreq: 'Encrypted Datalink',
      gpsDependent: 'Yes + INS',
      encryption: 'Ukrainian Military',
      autonomy: 'Autonomous Flight',
      payloadCapacity: '3 kg (3x bombs)',
      payload: ['3x 1kg Fragmentation Bombs'],
      threatLevel: 'MEDIUM',
      description: 'Ukrainian mini combat UAV ที่ประสบความสำเร็จในการโจมตี',
      combatHistory: ['Ukraine 2022-2024'],
      counterMeasures: ['EW Jamming', 'Visual Detection'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/7/7f/Punisher_drone_1.jpg/800px-Punisher_drone_1.jpg',
    ),
    UAVData(
      name: 'Beaver (UJ-22)',
      manufacturer: 'Ukrjet',
      country: 'Ukraine',
      flag: '🇺🇦',
      category: 'kamikaze',
      wingspan: '4.6 m',
      length: '3.4 m',
      mtow: '85 kg',
      maxSpeed: '160 km/h',
      cruiseSpeed: '120 km/h',
      ceiling: '3,000 m',
      endurance: '6 hr',
      range: '800+ km',
      controlFreq: 'Autonomous',
      videoFreq: 'None (Pre-programmed)',
      gpsDependent: 'Yes (INS Backup)',
      encryption: 'N/A',
      autonomy: 'Fully Autonomous',
      payloadCapacity: '20 kg Warhead',
      payload: ['HE Warhead', 'Thermobaric Option'],
      threatLevel: 'MEDIUM',
      description: 'Ukrainian long-range strike UAV ใช้โจมตีลึกเข้าไปในรัสเซีย',
      combatHistory: ['Deep strikes into Russia 2023-2024'],
      counterMeasures: ['GPS Jamming', 'Air Defense'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/1/19/UJ-22_Airborne.jpg/800px-UJ-22_Airborne.jpg',
    ),

    // === FPV DRONES ===
    UAVData(
      name: 'FPV Racing Drone (Modified)',
      manufacturer: 'Various',
      country: 'Various',
      flag: '🌍',
      category: 'fpv',
      wingspan: '0.2-0.3 m',
      length: '0.15-0.25 m',
      mtow: '0.5-1.5 kg',
      maxSpeed: '150+ km/h',
      cruiseSpeed: '80 km/h',
      ceiling: '500 m (practical)',
      endurance: '5-15 min',
      range: '5-10 km',
      controlFreq: '868 MHz / 900 MHz / 2.4 GHz',
      videoFreq: '5.8 GHz (Analog/Digital)',
      gpsDependent: 'Optional',
      encryption: 'None to Basic',
      autonomy: 'Manual (First-Person View)',
      payloadCapacity: '0.5-2 kg',
      payload: ['RPG-7 Warhead', 'RKG-3 Grenade', 'VOG Grenades', 'Thermobaric'],
      threatLevel: 'HIGH',
      description: 'Modified racing drones เป็น kamikaze ราคาถูกที่เปลี่ยนสงครามยูเครน',
      combatHistory: ['Ukraine 2022-2024 (Dominant weapon)'],
      counterMeasures: ['EW Jamming (5.8 GHz)', 'Shotguns', 'Nets', 'Anti-FPV Drones'],
      imageUrl: 'https://cdn.statically.io/img/upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Racing_Drone.jpg/800px-Racing_Drone.jpg',
    ),
  ];
}

// ==========================================
// DATA MODEL
// ==========================================
class UAVData {
  final String name;
  final String manufacturer;
  final String country;
  final String flag;
  final String category;
  final String wingspan;
  final String? length;
  final String? mtow;
  final String maxSpeed;
  final String? cruiseSpeed;
  final String ceiling;
  final String endurance;
  final String? range;
  final String? controlFreq;
  final String? videoFreq;
  final String? gpsDependent;
  final String? encryption;
  final String? autonomy;
  final String? payloadCapacity;
  final List<String>? payload;
  final String? threatLevel;
  final String? description;
  final List<String>? combatHistory;
  final List<String>? counterMeasures;
  final String? imageUrl;

  UAVData({
    required this.name,
    required this.manufacturer,
    required this.country,
    required this.flag,
    required this.category,
    required this.wingspan,
    this.length,
    this.mtow,
    required this.maxSpeed,
    this.cruiseSpeed,
    required this.ceiling,
    required this.endurance,
    this.range,
    this.controlFreq,
    this.videoFreq,
    this.gpsDependent,
    this.encryption,
    this.autonomy,
    this.payloadCapacity,
    this.payload,
    this.threatLevel,
    this.description,
    this.combatHistory,
    this.counterMeasures,
    this.imageUrl,
  });
}
