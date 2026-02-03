import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/progress_service.dart';
import '../../services/theme_provider.dart';

// Drone Model
class DroneModel {
  final String id;
  final String name;
  final String manufacturer;
  final String origin;
  final DroneCategory category;
  final DroneSize size;
  final String description;
  final List<String> characteristics;
  final double maxSpeed; // km/h
  final double maxRange; // km
  final double maxAltitude; // m
  final double weight; // kg
  final String rfFrequency;
  final String imageAsset; // For future use with actual images
  final String silhouette; // Character representation

  const DroneModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.origin,
    required this.category,
    required this.size,
    required this.description,
    required this.characteristics,
    required this.maxSpeed,
    required this.maxRange,
    required this.maxAltitude,
    required this.weight,
    required this.rfFrequency,
    this.imageAsset = '',
    required this.silhouette,
  });
}

enum DroneCategory {
  consumer,
  commercial,
  military,
  fpv,
  fixedWing,
}

enum DroneSize {
  micro,
  small,
  medium,
  large,
}

extension DroneCategoryExtension on DroneCategory {
  String get displayName {
    switch (this) {
      case DroneCategory.consumer:
        return 'Consumer';
      case DroneCategory.commercial:
        return 'Commercial';
      case DroneCategory.military:
        return 'Military';
      case DroneCategory.fpv:
        return 'FPV Racing';
      case DroneCategory.fixedWing:
        return 'Fixed Wing';
    }
  }

  Color get color {
    switch (this) {
      case DroneCategory.consumer:
        return Colors.blue;
      case DroneCategory.commercial:
        return Colors.green;
      case DroneCategory.military:
        return Colors.red;
      case DroneCategory.fpv:
        return Colors.orange;
      case DroneCategory.fixedWing:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case DroneCategory.consumer:
        return Icons.flight;
      case DroneCategory.commercial:
        return Icons.precision_manufacturing;
      case DroneCategory.military:
        return Icons.gps_fixed;
      case DroneCategory.fpv:
        return Icons.sports_motorsports;
      case DroneCategory.fixedWing:
        return Icons.airplanemode_active;
    }
  }
}

extension DroneSizeExtension on DroneSize {
  String get displayName {
    switch (this) {
      case DroneSize.micro:
        return 'Micro (<250g)';
      case DroneSize.small:
        return 'Small (250g-2kg)';
      case DroneSize.medium:
        return 'Medium (2-25kg)';
      case DroneSize.large:
        return 'Large (>25kg)';
    }
  }
}

// Training Mode Types
enum TrainingMode {
  visualId,
  rfSignature,
  specifications,
  mixedQuiz,
}

extension TrainingModeExtension on TrainingMode {
  String get displayName {
    switch (this) {
      case TrainingMode.visualId:
        return 'Visual ID';
      case TrainingMode.rfSignature:
        return 'RF Signature';
      case TrainingMode.specifications:
        return 'Specifications';
      case TrainingMode.mixedQuiz:
        return 'Mixed Quiz';
    }
  }

  String get description {
    switch (this) {
      case TrainingMode.visualId:
        return 'จำแนกโดรนจากรูปร่าง Silhouette';
      case TrainingMode.rfSignature:
        return 'จำแนกจากย่านความถี่ RF';
      case TrainingMode.specifications:
        return 'ระบุสเปคและลักษณะเฉพาะ';
      case TrainingMode.mixedQuiz:
        return 'ทดสอบทุกรูปแบบแบบสุ่ม';
    }
  }

  IconData get icon {
    switch (this) {
      case TrainingMode.visualId:
        return Icons.visibility;
      case TrainingMode.rfSignature:
        return Icons.wifi_tethering;
      case TrainingMode.specifications:
        return Icons.description;
      case TrainingMode.mixedQuiz:
        return Icons.quiz;
    }
  }

  Color get color {
    switch (this) {
      case TrainingMode.visualId:
        return AppColors.primary;
      case TrainingMode.rfSignature:
        return AppColors.warning;
      case TrainingMode.specifications:
        return AppColors.success;
      case TrainingMode.mixedQuiz:
        return AppColors.danger;
    }
  }
}

// Drone Database
class DroneDatabase {
  static const List<DroneModel> drones = [
    // Consumer Drones
    DroneModel(
      id: 'dji_mavic3',
      name: 'DJI Mavic 3',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.consumer,
      size: DroneSize.small,
      description:
          'Professional consumer drone with Hasselblad camera, dual camera system for versatile shooting.',
      characteristics: [
        'Folding design',
        'Hasselblad camera',
        'Omnidirectional obstacle sensing',
        'ActiveTrack 5.0',
      ],
      maxSpeed: 75,
      maxRange: 30,
      maxAltitude: 6000,
      weight: 0.895,
      rfFrequency: '2.4/5.8 GHz OcuSync 3.0',
      silhouette: '⬡',
    ),
    DroneModel(
      id: 'dji_mini3',
      name: 'DJI Mini 3 Pro',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.consumer,
      size: DroneSize.micro,
      description:
          'Ultra-lightweight drone under 250g with professional features.',
      characteristics: [
        'Under 250g',
        'Tri-directional obstacle sensing',
        '4K/60fps video',
        'Vertical shooting',
      ],
      maxSpeed: 57,
      maxRange: 18,
      maxAltitude: 4000,
      weight: 0.249,
      rfFrequency: '2.4/5.8 GHz OcuSync 3.0',
      silhouette: '◇',
    ),
    DroneModel(
      id: 'dji_air3',
      name: 'DJI Air 3',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.consumer,
      size: DroneSize.small,
      description: 'Mid-range drone with dual camera system and long flight time.',
      characteristics: [
        'Dual camera system',
        '46-min flight time',
        'O4 transmission',
        'Omnidirectional sensing',
      ],
      maxSpeed: 75,
      maxRange: 32,
      maxAltitude: 6000,
      weight: 0.720,
      rfFrequency: '2.4/5.8 GHz O4',
      silhouette: '◈',
    ),
    DroneModel(
      id: 'autel_evo2',
      name: 'Autel EVO II Pro',
      manufacturer: 'Autel Robotics',
      origin: 'USA/China',
      category: DroneCategory.consumer,
      size: DroneSize.small,
      description: 'High-end consumer drone with 6K camera and long range.',
      characteristics: [
        '6K video recording',
        '40-min flight time',
        '12 obstacle sensors',
        'Modular design',
      ],
      maxSpeed: 72,
      maxRange: 15,
      maxAltitude: 7000,
      weight: 1.127,
      rfFrequency: '2.4 GHz',
      silhouette: '⬢',
    ),
    DroneModel(
      id: 'parrot_anafi',
      name: 'Parrot ANAFI Ai',
      manufacturer: 'Parrot',
      origin: 'France',
      category: DroneCategory.consumer,
      size: DroneSize.small,
      description: 'European-made drone with 4G connectivity and robotic AI.',
      characteristics: [
        '4G LTE connectivity',
        '32x zoom',
        '48MP camera',
        'Photogrammetry ready',
      ],
      maxSpeed: 61,
      maxRange: 15,
      maxAltitude: 5000,
      weight: 0.898,
      rfFrequency: '2.4/5.8 GHz + 4G LTE',
      silhouette: '▽',
    ),

    // Commercial/Enterprise Drones
    DroneModel(
      id: 'dji_m30',
      name: 'DJI Matrice 30T',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.commercial,
      size: DroneSize.medium,
      description:
          'Enterprise drone with thermal imaging for inspection and emergency response.',
      characteristics: [
        'Thermal + Zoom + Wide camera',
        'IP55 rating',
        '41-min flight time',
        'Hot-swappable battery',
      ],
      maxSpeed: 82,
      maxRange: 15,
      maxAltitude: 7000,
      weight: 3.77,
      rfFrequency: '2.4/5.8 GHz O3',
      silhouette: '▣',
    ),
    DroneModel(
      id: 'dji_m300',
      name: 'DJI Matrice 300 RTK',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.commercial,
      size: DroneSize.large,
      description:
          'Industrial-grade platform for mapping, inspection, and SAR operations.',
      characteristics: [
        '55-min flight time',
        'RTK positioning',
        '3 payload mounts',
        'Hot-swappable batteries',
      ],
      maxSpeed: 82,
      maxRange: 15,
      maxAltitude: 7000,
      weight: 6.3,
      rfFrequency: '2.4/5.8 GHz OcuSync Enterprise',
      silhouette: '▥',
    ),
    DroneModel(
      id: 'skydio_x10',
      name: 'Skydio X10',
      manufacturer: 'Skydio',
      origin: 'USA',
      category: DroneCategory.commercial,
      size: DroneSize.medium,
      description:
          'AI-powered autonomous drone with advanced obstacle avoidance.',
      characteristics: [
        'Autonomy Engine',
        'Night vision',
        'Thermal imaging',
        'Edge computing',
      ],
      maxSpeed: 67,
      maxRange: 12,
      maxAltitude: 4500,
      weight: 2.2,
      rfFrequency: '2.4/5.8 GHz',
      silhouette: '◉',
    ),

    // Military/Tactical Drones
    DroneModel(
      id: 'switchblade_300',
      name: 'Switchblade 300',
      manufacturer: 'AeroVironment',
      origin: 'USA',
      category: DroneCategory.military,
      size: DroneSize.micro,
      description: 'Loitering munition (kamikaze drone) for precision strikes.',
      characteristics: [
        'Tube-launched',
        'Loitering capability',
        'Precision guidance',
        'Abort capability',
      ],
      maxSpeed: 160,
      maxRange: 10,
      maxAltitude: 4600,
      weight: 2.5,
      rfFrequency: 'Encrypted tactical datalink',
      silhouette: '➤',
    ),
    DroneModel(
      id: 'switchblade_600',
      name: 'Switchblade 600',
      manufacturer: 'AeroVironment',
      origin: 'USA',
      category: DroneCategory.military,
      size: DroneSize.small,
      description: 'Anti-armor loitering munition with Javelin warhead.',
      characteristics: [
        'Anti-armor capability',
        'Javelin warhead',
        '40-min loiter time',
        'Wave-off capability',
      ],
      maxSpeed: 185,
      maxRange: 40,
      maxAltitude: 4000,
      weight: 23,
      rfFrequency: 'Encrypted AES-256',
      silhouette: '⇨',
    ),
    DroneModel(
      id: 'rq11_raven',
      name: 'RQ-11 Raven',
      manufacturer: 'AeroVironment',
      origin: 'USA',
      category: DroneCategory.military,
      size: DroneSize.small,
      description: 'Hand-launched reconnaissance UAV for small unit operations.',
      characteristics: [
        'Hand-launched',
        'Electric motor',
        'EO/IR camera',
        'GPS navigation',
      ],
      maxSpeed: 97,
      maxRange: 10,
      maxAltitude: 4600,
      weight: 1.9,
      rfFrequency: '2.4 GHz encrypted',
      silhouette: '✈',
    ),
    DroneModel(
      id: 'bayraktar_tb2',
      name: 'Bayraktar TB2',
      manufacturer: 'Baykar',
      origin: 'Turkey',
      category: DroneCategory.military,
      size: DroneSize.large,
      description:
          'Medium-altitude long-endurance tactical UCAV widely used in modern conflicts.',
      characteristics: [
        '27-hour endurance',
        'MAM-L/MAM-C munitions',
        'Triple redundancy',
        'Laser designator',
      ],
      maxSpeed: 220,
      maxRange: 150,
      maxAltitude: 8200,
      weight: 700,
      rfFrequency: 'C-band + satellite link',
      silhouette: '✇',
    ),
    DroneModel(
      id: 'orlan10',
      name: 'Orlan-10',
      manufacturer: 'Special Technology Center',
      origin: 'Russia',
      category: DroneCategory.military,
      size: DroneSize.small,
      description:
          'Russian reconnaissance UAV widely used for artillery spotting.',
      characteristics: [
        'Catapult launch',
        'Parachute recovery',
        'EO/IR payload',
        'ELINT capability',
      ],
      maxSpeed: 150,
      maxRange: 120,
      maxAltitude: 5000,
      weight: 18,
      rfFrequency: '868 MHz / 900 MHz',
      silhouette: '✪',
    ),
    DroneModel(
      id: 'shahed_136',
      name: 'Shahed-136',
      manufacturer: 'HESA',
      origin: 'Iran',
      category: DroneCategory.military,
      size: DroneSize.medium,
      description:
          'Loitering munition/cruise missile used for long-range strikes.',
      characteristics: [
        'Delta wing design',
        'GPS + INS guidance',
        'Low observable',
        'Cheap manufacturing',
      ],
      maxSpeed: 185,
      maxRange: 2500,
      maxAltitude: 4000,
      weight: 200,
      rfFrequency: 'GPS L1/L2 + INS backup',
      silhouette: '◢',
    ),
    DroneModel(
      id: 'lancet',
      name: 'Lancet',
      manufacturer: 'ZALA Aero',
      origin: 'Russia',
      category: DroneCategory.military,
      size: DroneSize.small,
      description: 'Russian loitering munition for precision strike missions.',
      characteristics: [
        'Cruciform wings',
        'TV guidance',
        'Tandem warhead',
        'ZALA control',
      ],
      maxSpeed: 300,
      maxRange: 40,
      maxAltitude: 5000,
      weight: 12,
      rfFrequency: 'Proprietary encrypted',
      silhouette: '✦',
    ),

    // FPV Racing Drones
    DroneModel(
      id: 'dji_avata2',
      name: 'DJI Avata 2',
      manufacturer: 'DJI',
      origin: 'China',
      category: DroneCategory.fpv,
      size: DroneSize.small,
      description: 'Immersive FPV cinewhoop drone with motion controller.',
      characteristics: [
        'Cinewhoop design',
        'Motion control',
        '4K/60fps',
        'O4 transmission',
      ],
      maxSpeed: 108,
      maxRange: 13,
      maxAltitude: 5000,
      weight: 0.377,
      rfFrequency: '2.4/5.8 GHz O4',
      silhouette: '⊚',
    ),
    DroneModel(
      id: 'fpv_racing',
      name: 'Custom FPV Racing',
      manufacturer: 'Various DIY',
      origin: 'Global',
      category: DroneCategory.fpv,
      size: DroneSize.small,
      description: 'Custom-built high-speed FPV racing drones.',
      characteristics: [
        '5-inch props',
        'Analog/Digital video',
        'Crossfire/ELRS receiver',
        'High thrust-to-weight',
      ],
      maxSpeed: 180,
      maxRange: 2,
      maxAltitude: 1000,
      weight: 0.650,
      rfFrequency: '2.4 GHz (ELRS/Crossfire) + 5.8 GHz video',
      silhouette: '✖',
    ),

    // Fixed Wing
    DroneModel(
      id: 'wingtra_one',
      name: 'WingtraOne',
      manufacturer: 'Wingtra',
      origin: 'Switzerland',
      category: DroneCategory.fixedWing,
      size: DroneSize.medium,
      description: 'VTOL mapping drone for surveying and inspection.',
      characteristics: [
        'VTOL takeoff/landing',
        '59-min flight time',
        '42MP camera',
        'PPK georeferencing',
      ],
      maxSpeed: 90,
      maxRange: 50,
      maxAltitude: 4000,
      weight: 4.5,
      rfFrequency: '2.4 GHz',
      silhouette: '▷',
    ),
    DroneModel(
      id: 'disco_ag',
      name: 'senseFly eBee X',
      manufacturer: 'AgEagle (senseFly)',
      origin: 'Switzerland',
      category: DroneCategory.fixedWing,
      size: DroneSize.small,
      description: 'Professional fixed-wing mapping drone.',
      characteristics: [
        'Hand-launch',
        '90-min endurance',
        'RTK/PPK capable',
        'Modular payloads',
      ],
      maxSpeed: 90,
      maxRange: 40,
      maxAltitude: 4500,
      weight: 1.6,
      rfFrequency: '2.4/5.8 GHz',
      silhouette: '△',
    ),
  ];

  static List<DroneModel> getByCategory(DroneCategory category) {
    return drones.where((d) => d.category == category).toList();
  }

  static DroneModel getById(String id) {
    return drones.firstWhere((d) => d.id == id);
  }

  static List<DroneModel> getRandomSelection(int count) {
    final shuffled = List<DroneModel>.from(drones)..shuffle();
    return shuffled.take(count).toList();
  }
}

// Main Screen
class DroneIdTrainingScreen extends StatefulWidget {
  const DroneIdTrainingScreen({super.key});

  @override
  State<DroneIdTrainingScreen> createState() => _DroneIdTrainingScreenState();
}

class _DroneIdTrainingScreenState extends State<DroneIdTrainingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DroneCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            title: const Text('Drone ID Training'),
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Database', icon: Icon(Icons.storage, size: 20)),
                Tab(text: 'Training', icon: Icon(Icons.school, size: 20)),
                Tab(text: 'Quiz', icon: Icon(Icons.quiz, size: 20)),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDatabaseTab(isDark),
              _buildTrainingTab(isDark),
              _buildQuizTab(isDark),
            ],
          ),
        );
      },
    );
  }

  // Database Tab
  Widget _buildDatabaseTab(bool isDark) {
    return Column(
      children: [
        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _selectedCategory == null,
                onSelected: (_) => setState(() => _selectedCategory = null),
                selectedColor: AppColors.primary.withAlpha(50),
              ),
              const SizedBox(width: 8),
              ...DroneCategory.values.map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat.displayName),
                      selected: _selectedCategory == cat,
                      avatar: Icon(cat.icon, size: 16, color: cat.color),
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      selectedColor: cat.color.withAlpha(50),
                    ),
                  )),
            ],
          ),
        ),
        // Drone List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getFilteredDrones().length,
            itemBuilder: (context, index) {
              final drone = _getFilteredDrones()[index];
              return _buildDroneCard(drone, isDark);
            },
          ),
        ),
      ],
    );
  }

  List<DroneModel> _getFilteredDrones() {
    if (_selectedCategory == null) {
      return DroneDatabase.drones;
    }
    return DroneDatabase.getByCategory(_selectedCategory!);
  }

  Widget _buildDroneCard(DroneModel drone, bool isDark) {
    return Card(
      color: isDark ? AppColors.surface : AppColorsLight.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showDroneDetail(drone),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Silhouette/Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: drone.category.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    drone.silhouette,
                    style: TextStyle(
                      fontSize: 32,
                      color: drone.category.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            drone.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: drone.category.color.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            drone.category.displayName,
                            style: TextStyle(
                              color: drone.category.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${drone.manufacturer} • ${drone.origin}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSpecChip(
                            Icons.speed, '${drone.maxSpeed.toInt()} km/h'),
                        const SizedBox(width: 8),
                        _buildSpecChip(
                            Icons.signal_cellular_alt, drone.rfFrequency.split(' ').first),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _showDroneDetail(DroneModel drone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Header
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: drone.category.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          drone.silhouette,
                          style: TextStyle(
                            fontSize: 48,
                            color: drone.category.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drone.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${drone.manufacturer} • ${drone.origin}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: drone.category.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  drone.category.displayName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                drone.size.displayName,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  drone.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Specifications
                const Text(
                  'Specifications',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSpecRow('Max Speed', '${drone.maxSpeed.toInt()} km/h'),
                _buildSpecRow('Max Range', '${drone.maxRange.toInt()} km'),
                _buildSpecRow(
                    'Max Altitude', '${drone.maxAltitude.toInt()} m'),
                _buildSpecRow('Weight', '${drone.weight} kg'),
                _buildSpecRow('RF Frequency', drone.rfFrequency),
                const SizedBox(height: 24),
                // Characteristics
                const Text(
                  'Key Characteristics',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: drone.characteristics.map((char) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        char,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Training Tab
  Widget _buildTrainingTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Training Modes
        const Text(
          'Training Modes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...TrainingMode.values.map((mode) => _buildTrainingModeCard(mode)),
        const SizedBox(height: 24),
        // Progress
        _buildProgressSection(),
      ],
    );
  }

  Widget _buildTrainingModeCard(TrainingMode mode) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _startTraining(mode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: mode.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(mode.icon, color: mode.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.displayName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mode.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow,
                color: mode.color,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.success, size: 24),
              SizedBox(width: 10),
              Text(
                'Training Progress',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressItem('Drones Learned',
            '${DroneDatabase.drones.length}', DroneDatabase.drones.length, Colors.blue),
          const SizedBox(height: 12),
          _buildProgressItem('Visual ID Accuracy', '0%', 0, Colors.orange),
          const SizedBox(height: 12),
          _buildProgressItem('RF ID Accuracy', '0%', 0, Colors.green),
          const SizedBox(height: 12),
          _buildProgressItem('Quizzes Passed', '0', 0, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, int progress, Color color) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _startTraining(TrainingMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DroneTrainingSession(mode: mode),
      ),
    );
  }

  // Quiz Tab
  Widget _buildQuizTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Quiz
        _buildQuizCard(
          'Quick Quiz',
          '10 questions • 5 minutes',
          Icons.bolt,
          AppColors.warning,
          10,
        ),
        const SizedBox(height: 12),
        // Standard Quiz
        _buildQuizCard(
          'Standard Quiz',
          '20 questions • 10 minutes',
          Icons.assignment,
          AppColors.primary,
          20,
        ),
        const SizedBox(height: 12),
        // Challenge Quiz
        _buildQuizCard(
          'Challenge Quiz',
          '30 questions • 15 minutes • No hints',
          Icons.emoji_events,
          AppColors.danger,
          30,
        ),
        const SizedBox(height: 24),
        // Category Specific
        const Text(
          'Category Quizzes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...DroneCategory.values.map((cat) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildCategoryQuizCard(cat),
            )),
      ],
    );
  }

  Widget _buildQuizCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    int questionCount,
  ) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _startQuiz(questionCount),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryQuizCard(DroneCategory category) {
    final droneCount = DroneDatabase.getByCategory(category).length;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: category.color.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(category.icon, color: category.color, size: 20),
      ),
      title: Text(
        category.displayName,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: Text(
        '$droneCount drones',
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () => _startCategoryQuiz(category),
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _startQuiz(int questionCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DroneQuizSession(questionCount: questionCount),
      ),
    );
  }

  void _startCategoryQuiz(DroneCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DroneQuizSession(
          questionCount: DroneDatabase.getByCategory(category).length,
          category: category,
        ),
      ),
    );
  }
}

// Training Session Screen
class DroneTrainingSession extends StatefulWidget {
  final TrainingMode mode;

  const DroneTrainingSession({super.key, required this.mode});

  @override
  State<DroneTrainingSession> createState() => _DroneTrainingSessionState();
}

class _DroneTrainingSessionState extends State<DroneTrainingSession> {
  late List<DroneModel> _drones;
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _drones = List<DroneModel>.from(DroneDatabase.drones)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final drone = _drones[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.mode.displayName),
        backgroundColor: AppColors.surface,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentIndex + 1}/${_drones.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _drones.length,
              backgroundColor: AppColors.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(widget.mode.color),
            ),
            const SizedBox(height: 24),
            // Content based on mode
            Expanded(
              child: _buildTrainingContent(drone),
            ),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _showAnswer
                        ? () => _previousDrone()
                        : () => setState(() => _showAnswer = true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Text(_showAnswer ? 'Previous' : 'Show Answer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextDrone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.mode.color,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentIndex < _drones.length - 1
                        ? 'Next'
                        : 'Finish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingContent(DroneModel drone) {
    switch (widget.mode) {
      case TrainingMode.visualId:
        return _buildVisualIdContent(drone);
      case TrainingMode.rfSignature:
        return _buildRfSignatureContent(drone);
      case TrainingMode.specifications:
        return _buildSpecificationsContent(drone);
      case TrainingMode.mixedQuiz:
        return _buildMixedContent(drone);
    }
  }

  Widget _buildVisualIdContent(DroneModel drone) {
    return Column(
      children: [
        const Text(
          'Identify this drone:',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 40),
        // Silhouette
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              drone.silhouette,
              style: TextStyle(
                fontSize: 120,
                color: _showAnswer ? drone.category.color : AppColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        // Answer
        if (_showAnswer) ...[
          Text(
            drone.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${drone.manufacturer} • ${drone.origin}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: drone.category.color.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              drone.category.displayName,
              style: TextStyle(
                color: drone.category.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else
          const Text(
            'Tap "Show Answer" to reveal',
            style: TextStyle(color: AppColors.textMuted),
          ),
      ],
    );
  }

  Widget _buildRfSignatureContent(DroneModel drone) {
    return Column(
      children: [
        const Text(
          'Identify drone by RF signature:',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 40),
        // RF Info
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.wifi_tethering,
                color: AppColors.warning,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                drone.rfFrequency,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        // Answer
        if (_showAnswer) ...[
          Text(
            drone.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            drone.category.displayName,
            style: TextStyle(
              color: drone.category.color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else
          const Text(
            'Tap "Show Answer" to reveal',
            style: TextStyle(color: AppColors.textMuted),
          ),
      ],
    );
  }

  Widget _buildSpecificationsContent(DroneModel drone) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Identify drone by specs:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          // Specs
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildSpecItem(
                    Icons.speed, 'Max Speed', '${drone.maxSpeed.toInt()} km/h'),
                const Divider(color: AppColors.border),
                _buildSpecItem(Icons.route, 'Max Range',
                    '${drone.maxRange.toInt()} km'),
                const Divider(color: AppColors.border),
                _buildSpecItem(Icons.height, 'Max Altitude',
                    '${drone.maxAltitude.toInt()} m'),
                const Divider(color: AppColors.border),
                _buildSpecItem(
                    Icons.scale, 'Weight', '${drone.weight} kg'),
                const Divider(color: AppColors.border),
                _buildSpecItem(Icons.public, 'Origin', drone.origin),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Answer
          if (_showAnswer) ...[
            Text(
              drone.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              drone.manufacturer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ] else
            const Text(
              'Tap "Show Answer" to reveal',
              style: TextStyle(color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedContent(DroneModel drone) {
    final modes = [
      TrainingMode.visualId,
      TrainingMode.rfSignature,
      TrainingMode.specifications,
    ];
    final randomMode = modes[_currentIndex % modes.length];

    switch (randomMode) {
      case TrainingMode.visualId:
        return _buildVisualIdContent(drone);
      case TrainingMode.rfSignature:
        return _buildRfSignatureContent(drone);
      case TrainingMode.specifications:
        return _buildSpecificationsContent(drone);
      default:
        return _buildVisualIdContent(drone);
    }
  }

  void _nextDrone() {
    if (_currentIndex < _drones.length - 1) {
      setState(() {
        _currentIndex++;
        _showAnswer = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _previousDrone() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showAnswer = false;
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: 10),
            Text(
              'Training Complete!',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Text(
          'You have reviewed all ${_drones.length} drones.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _drones.shuffle();
                _currentIndex = 0;
                _showAnswer = false;
              });
            },
            child: const Text('Restart'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

// Quiz Session Screen
class DroneQuizSession extends StatefulWidget {
  final int questionCount;
  final DroneCategory? category;

  const DroneQuizSession({
    super.key,
    required this.questionCount,
    this.category,
  });

  @override
  State<DroneQuizSession> createState() => _DroneQuizSessionState();
}

class _DroneQuizSessionState extends State<DroneQuizSession> {
  late List<_QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _answered = false;
  Timer? _timer;
  int _timeRemaining = 30; // seconds per question

  @override
  void initState() {
    super.initState();
    _generateQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _generateQuestions() {
    List<DroneModel> drones;
    if (widget.category != null) {
      drones = DroneDatabase.getByCategory(widget.category!);
    } else {
      drones = List<DroneModel>.from(DroneDatabase.drones);
    }
    drones.shuffle();

    _questions = [];
    final random = Random();
    final questionTypes = ['visual', 'rf', 'spec', 'category', 'origin'];

    for (int i = 0; i < min(widget.questionCount, drones.length); i++) {
      final drone = drones[i];
      final type = questionTypes[random.nextInt(questionTypes.length)];

      List<String> options = [];
      String correctAnswer = '';
      String question = '';

      switch (type) {
        case 'visual':
          question = 'Which drone has this silhouette?\n\n${drone.silhouette}';
          correctAnswer = drone.name;
          options = _generateOptions(drones, drone, (d) => d.name);
          break;
        case 'rf':
          question =
              'Which drone uses this RF frequency?\n\n${drone.rfFrequency}';
          correctAnswer = drone.name;
          options = _generateOptions(drones, drone, (d) => d.name);
          break;
        case 'spec':
          question =
              'Which drone has max speed of ${drone.maxSpeed.toInt()} km/h?';
          correctAnswer = drone.name;
          options = _generateOptions(drones, drone, (d) => d.name);
          break;
        case 'category':
          question = '${drone.name} belongs to which category?';
          correctAnswer = drone.category.displayName;
          options = DroneCategory.values.map((c) => c.displayName).toList();
          break;
        case 'origin':
          question = 'What is the country of origin for ${drone.name}?';
          correctAnswer = drone.origin;
          final origins =
              drones.map((d) => d.origin).toSet().toList()..shuffle();
          options = origins.take(4).toList();
          if (!options.contains(correctAnswer)) {
            options[0] = correctAnswer;
          }
          break;
      }

      options.shuffle();

      _questions.add(_QuizQuestion(
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        drone: drone,
      ));
    }
  }

  List<String> _generateOptions(
    List<DroneModel> drones,
    DroneModel correctDrone,
    String Function(DroneModel) selector,
  ) {
    final options = <String>[selector(correctDrone)];
    final otherDrones = drones.where((d) => d.id != correctDrone.id).toList()
      ..shuffle();

    for (final d in otherDrones) {
      final option = selector(d);
      if (!options.contains(option)) {
        options.add(option);
        if (options.length >= 4) break;
      }
    }

    while (options.length < 4) {
      options.add('Unknown');
    }

    return options;
  }

  void _startTimer() {
    _timeRemaining = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0 && !_answered) {
        setState(() => _timeRemaining--);
      } else if (_timeRemaining == 0 && !_answered) {
        _submitAnswer(null);
      }
    });
  }

  void _submitAnswer(String? answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
    _timer?.cancel();
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
      _startTimer();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final percent = (_score / _questions.length * 100).round();
    final passed = percent >= 70;

    // Award XP
    if (passed) {
      ProgressService.addXp(widget.questionCount * 5);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              color: passed ? AppColors.success : AppColors.danger,
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              passed ? 'Quiz Passed!' : 'Quiz Failed',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: $_score/${_questions.length}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$percent%',
              style: TextStyle(
                color: passed ? AppColors.success : AppColors.danger,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (passed)
              Text(
                '+${widget.questionCount * 5} XP',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _generateQuestions();
                _currentIndex = 0;
                _score = 0;
                _selectedAnswer = null;
                _answered = false;
              });
              _startTimer();
            },
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: passed ? AppColors.success : AppColors.primary,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
            'Quiz ${widget.category?.displayName ?? ''}'),
        backgroundColor: AppColors.surface,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '$_timeRemaining s',
                    style: TextStyle(
                      color: _timeRemaining <= 10
                          ? AppColors.danger
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Correct: ${(_score / (_currentIndex + 1) * 100).round()}%',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Question
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isCorrect = option == question.correctAnswer;
                  final isSelected = option == _selectedAnswer;

                  Color? bgColor;
                  Color? borderColor;

                  if (_answered) {
                    if (isCorrect) {
                      bgColor = AppColors.success.withAlpha(30);
                      borderColor = AppColors.success;
                    } else if (isSelected) {
                      bgColor = AppColors.danger.withAlpha(30);
                      borderColor = AppColors.danger;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: _answered ? null : () => _submitAnswer(option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor ?? AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: borderColor ?? AppColors.border,
                            width: isSelected || (isCorrect && _answered)
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if (_answered && isCorrect)
                              const Icon(Icons.check_circle,
                                  color: AppColors.success),
                            if (_answered && isSelected && !isCorrect)
                              const Icon(Icons.cancel, color: AppColors.danger),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Next button
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_currentIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'See Results'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final DroneModel drone;

  _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.drone,
  });
}
