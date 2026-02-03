import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import 'tactical_simulator.dart';

// ==========================================
// INTERACTIVE SCENARIOS HUB
// ศูนย์รวมสถานการณ์จำลอง EW Training
// ==========================================

enum ScenarioDifficulty { beginner, intermediate, advanced }

enum ScenarioCategory { antiDrone, sigint, gpsWarfare, commJamming, radarOps }

class ScenarioData {
  final String id;
  final String title;
  final String titleThai;
  final String description;
  final ScenarioCategory category;
  final ScenarioDifficulty difficulty;
  final int estimatedMinutes;
  final List<String> objectives;
  final List<String> skills;
  final int xpReward;
  final String missionType;
  final bool isNew;
  final bool isLocked;

  const ScenarioData({
    required this.id,
    required this.title,
    required this.titleThai,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.objectives,
    required this.skills,
    required this.xpReward,
    required this.missionType,
    this.isNew = false,
    this.isLocked = false,
  });
}

class InteractiveScenariosScreen extends StatefulWidget {
  const InteractiveScenariosScreen({super.key});

  @override
  State<InteractiveScenariosScreen> createState() =>
      _InteractiveScenariosScreenState();
}

class _InteractiveScenariosScreenState
    extends State<InteractiveScenariosScreen> {
  ScenarioCategory? _selectedCategory;
  ScenarioDifficulty? _selectedDifficulty;

  final List<ScenarioData> _scenarios = [
    // Anti-Drone Scenarios
    const ScenarioData(
      id: 'ad_basic',
      title: 'Counter-UAS Basic',
      titleThai: 'ต่อต้านโดรนเบื้องต้น',
      description:
          'เรียนรู้พื้นฐานการตรวจจับและรบกวนโดรนพลเรือน ฝึกการใช้ Spot Jamming',
      category: ScenarioCategory.antiDrone,
      difficulty: ScenarioDifficulty.beginner,
      estimatedMinutes: 10,
      objectives: [
        'ตรวจจับโดรน DJI',
        'ปรับความถี่ให้ตรงกับ Control Link',
        'ทำลายโดรน 3 ลำ',
      ],
      skills: ['Signal Detection', 'Frequency Tuning', 'Spot Jamming'],
      xpReward: 100,
      missionType: 'anti_drone',
      isNew: true,
    ),
    const ScenarioData(
      id: 'ad_swarm',
      title: 'Drone Swarm Defense',
      titleThai: 'ป้องกันฝูงโดรน',
      description:
          'ต่อต้านการโจมตีจากโดรนหลายลำพร้อมกัน ใช้ Barrage Jamming',
      category: ScenarioCategory.antiDrone,
      difficulty: ScenarioDifficulty.intermediate,
      estimatedMinutes: 15,
      objectives: [
        'ป้องกันพื้นที่จากโดรน 5 ลำ',
        'ใช้ Barrage Jamming อย่างมีประสิทธิภาพ',
        'บริหารพลังงานให้เพียงพอ',
      ],
      skills: ['Barrage Jamming', 'Power Management', 'Multi-Target'],
      xpReward: 200,
      missionType: 'anti_drone',
    ),
    const ScenarioData(
      id: 'ad_fpv',
      title: 'FPV Combat Drone',
      titleThai: 'โดรน FPV โจมตี',
      description:
          'ต่อต้านโดรน FPV ที่เคลื่อนที่เร็ว ต้องใช้ Directional Antenna',
      category: ScenarioCategory.antiDrone,
      difficulty: ScenarioDifficulty.advanced,
      estimatedMinutes: 20,
      objectives: [
        'ทำลายโดรน FPV ความเร็วสูง',
        'ใช้ Directional Antenna เล็งเป้า',
        'ป้องกันพื้นที่ภายใน 3 นาที',
      ],
      skills: ['Directional Jamming', 'Target Tracking', 'Quick Response'],
      xpReward: 350,
      missionType: 'anti_drone',
    ),

    // SIGINT Scenarios
    const ScenarioData(
      id: 'si_basic',
      title: 'Signal Intelligence 101',
      titleThai: 'SIGINT เบื้องต้น',
      description: 'เรียนรู้การสแกนและระบุสัญญาณ ฝึกใช้เครื่อง ESM',
      category: ScenarioCategory.sigint,
      difficulty: ScenarioDifficulty.beginner,
      estimatedMinutes: 10,
      objectives: [
        'สแกนหาสัญญาณในพื้นที่',
        'ระบุประเภทสัญญาณ 5 สัญญาณ',
        'บันทึกข้อมูลความถี่และทิศทาง',
      ],
      skills: ['Spectrum Scanning', 'Signal Classification', 'Data Recording'],
      xpReward: 100,
      missionType: 'sigint',
    ),
    const ScenarioData(
      id: 'si_direction',
      title: 'Direction Finding',
      titleThai: 'หาตำแหน่งแหล่งกำเนิด',
      description: 'ฝึกการหาทิศทางและตำแหน่งของแหล่งกำเนิดสัญญาณ',
      category: ScenarioCategory.sigint,
      difficulty: ScenarioDifficulty.intermediate,
      estimatedMinutes: 15,
      objectives: [
        'หาทิศทางสัญญาณ 3 แหล่ง',
        'ใช้ Triangulation หาตำแหน่ง',
        'รายงานผลอย่างถูกต้อง',
      ],
      skills: ['Direction Finding', 'Triangulation', 'Geolocation'],
      xpReward: 200,
      missionType: 'sigint',
    ),
    const ScenarioData(
      id: 'si_eob',
      title: 'Electronic Order of Battle',
      titleThai: 'สร้าง EOB',
      description:
          'รวบรวมข้อมูล ELINT และ COMINT เพื่อสร้าง Electronic Order of Battle',
      category: ScenarioCategory.sigint,
      difficulty: ScenarioDifficulty.advanced,
      estimatedMinutes: 25,
      objectives: [
        'ระบุระบบเรดาร์ 3 ชนิด',
        'ระบุเครือข่ายการสื่อสาร',
        'สร้าง EOB ที่สมบูรณ์',
      ],
      skills: ['ELINT', 'COMINT', 'EOB Creation', 'Analysis'],
      xpReward: 400,
      missionType: 'sigint',
      isLocked: true,
    ),

    // GPS Warfare Scenarios
    const ScenarioData(
      id: 'gps_jam',
      title: 'GPS Jamming Basics',
      titleThai: 'รบกวน GPS เบื้องต้น',
      description: 'เรียนรู้หลักการรบกวน GPS และผลกระทบต่อเป้าหมาย',
      category: ScenarioCategory.gpsWarfare,
      difficulty: ScenarioDifficulty.beginner,
      estimatedMinutes: 10,
      objectives: [
        'เข้าใจย่านความถี่ GPS',
        'ใช้ GPS Jammer อย่างถูกต้อง',
        'สังเกตผลกระทบต่อโดรน',
      ],
      skills: ['GPS Frequencies', 'Jamming Technique', 'Effect Assessment'],
      xpReward: 100,
      missionType: 'anti_drone',
    ),
    const ScenarioData(
      id: 'gps_spoof',
      title: 'GPS Spoofing',
      titleThai: 'หลอก GPS',
      description: 'ฝึกเทคนิคการหลอก GPS เพื่อเบี่ยงเบนเส้นทางเป้าหมาย',
      category: ScenarioCategory.gpsWarfare,
      difficulty: ScenarioDifficulty.advanced,
      estimatedMinutes: 20,
      objectives: [
        'สร้างสัญญาณ GPS ปลอม',
        'เบี่ยงเบนโดรนออกจากพื้นที่',
        'ควบคุมตำแหน่งที่โดรนรับรู้',
      ],
      skills: ['GPS Spoofing', 'Signal Generation', 'Navigation Deception'],
      xpReward: 350,
      missionType: 'anti_drone',
      isLocked: true,
    ),

    // Comm Jamming Scenarios
    const ScenarioData(
      id: 'cj_basic',
      title: 'Communication Jamming',
      titleThai: 'รบกวนการสื่อสาร',
      description: 'เรียนรู้การรบกวนการสื่อสารวิทยุ VHF/UHF',
      category: ScenarioCategory.commJamming,
      difficulty: ScenarioDifficulty.beginner,
      estimatedMinutes: 10,
      objectives: [
        'ระบุช่องสื่อสารของเป้าหมาย',
        'ปรับ Jammer ให้ตรงความถี่',
        'ประเมินผลการรบกวน',
      ],
      skills: ['Radio Jamming', 'Frequency Identification', 'Effect Assessment'],
      xpReward: 100,
      missionType: 'convoy_protection',
    ),
    const ScenarioData(
      id: 'cj_fhss',
      title: 'FHSS Jamming',
      titleThai: 'รบกวนระบบ Frequency Hopping',
      description: 'ท้าทายการรบกวนระบบที่ใช้ Frequency Hopping',
      category: ScenarioCategory.commJamming,
      difficulty: ScenarioDifficulty.intermediate,
      estimatedMinutes: 15,
      objectives: [
        'ตรวจจับรูปแบบ Hopping',
        'ใช้ Barrage Jamming คลุมย่าน',
        'บริหารพลังงานอย่างมีประสิทธิภาพ',
      ],
      skills: ['FHSS Detection', 'Barrage Jamming', 'Power Management'],
      xpReward: 250,
      missionType: 'convoy_protection',
    ),

    // Convoy Protection
    const ScenarioData(
      id: 'cp_basic',
      title: 'Convoy Protection',
      titleThai: 'ป้องกันขบวน',
      description: 'ป้องกันขบวนยานพาหนะจากภัยคุกคาม IED และโดรน',
      category: ScenarioCategory.antiDrone,
      difficulty: ScenarioDifficulty.intermediate,
      estimatedMinutes: 15,
      objectives: [
        'รบกวน Remote Detonation',
        'ป้องกันโดรนตลอดเส้นทาง',
        'รักษาการสื่อสารของฝ่ายเรา',
      ],
      skills: ['IED Jamming', 'Counter-UAS', 'Friendly Comms Protection'],
      xpReward: 250,
      missionType: 'convoy_protection',
    ),

    // Radar Operations
    const ScenarioData(
      id: 'ro_basic',
      title: 'Radar Operations',
      titleThai: 'ปฏิบัติการเรดาร์',
      description: 'เรียนรู้การใช้งานเรดาร์ตรวจจับและติดตามเป้าหมาย',
      category: ScenarioCategory.radarOps,
      difficulty: ScenarioDifficulty.beginner,
      estimatedMinutes: 15,
      objectives: [
        'เข้าใจหลักการทำงานเรดาร์',
        'ตรวจจับและติดตามเป้าหมาย',
        'แยกแยะเป้าหมายจริงจาก Clutter',
      ],
      skills: ['Radar Operation', 'Target Detection', 'Clutter Rejection'],
      xpReward: 150,
      missionType: 'sigint',
    ),
    const ScenarioData(
      id: 'ro_eccm',
      title: 'ECCM Operations',
      titleThai: 'มาตรการต่อต้านการรบกวน',
      description: 'ฝึกการใช้ ECCM เมื่อเรดาร์ถูกรบกวน',
      category: ScenarioCategory.radarOps,
      difficulty: ScenarioDifficulty.advanced,
      estimatedMinutes: 20,
      objectives: [
        'ระบุประเภทการรบกวน',
        'เลือกใช้ ECCM ที่เหมาะสม',
        'รักษาการติดตามเป้าหมาย',
      ],
      skills: ['ECCM Techniques', 'Jamming Recognition', 'Adaptive Response'],
      xpReward: 350,
      missionType: 'sigint',
      isLocked: true,
    ),
  ];

  List<ScenarioData> get _filteredScenarios {
    var filtered = _scenarios;

    if (_selectedCategory != null) {
      filtered = filtered.where((s) => s.category == _selectedCategory).toList();
    }

    if (_selectedDifficulty != null) {
      filtered =
          filtered.where((s) => s.difficulty == _selectedDifficulty).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        final filtered = _filteredScenarios;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sports_esports,
                  size: 20,
                  color: isDark ? AppColors.warning : AppColorsLight.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  'SCENARIOS',
                  style: TextStyle(
                    color:
                        isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          body: Column(
            children: [
              // Header Stats
              _buildHeaderStats(isDark),

              // Category Filter
              _buildCategoryFilter(isDark),

              // Difficulty Filter
              _buildDifficultyFilter(isDark),

              // Results Count
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.videogame_asset,
                      size: 14,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${filtered.length} สถานการณ์',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedCategory = null;
                          _selectedDifficulty = null;
                        });
                      },
                      icon: const Icon(Icons.clear_all, size: 16),
                      label: const Text('ล้างตัวกรอง'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDark
                            ? AppColors.textSecondary
                            : AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Scenario List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildScenarioCard(filtered[index], isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderStats(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning.withAlpha(30),
            AppColors.primary.withAlpha(20),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withAlpha(50),
        ),
      ),
      child: Row(
        children: [
          _buildStatItem(
            icon: Icons.check_circle,
            value: '3',
            label: 'สำเร็จ',
            color: AppColors.success,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.star,
            value: '850',
            label: 'XP รวม',
            color: AppColors.warning,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.timer,
            value: '45m',
            label: 'เวลาฝึก',
            color: AppColors.primary,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.emoji_events,
            value: 'B+',
            label: 'อันดับ',
            color: AppColors.tabLearning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.border,
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip(null, 'ทั้งหมด', Icons.apps, isDark),
          _buildCategoryChip(
              ScenarioCategory.antiDrone, 'Anti-Drone', Icons.flight, isDark),
          _buildCategoryChip(
              ScenarioCategory.sigint, 'SIGINT', Icons.radar, isDark),
          _buildCategoryChip(
              ScenarioCategory.gpsWarfare, 'GPS', Icons.gps_fixed, isDark),
          _buildCategoryChip(
              ScenarioCategory.commJamming, 'Comm Jam', Icons.wifi_off, isDark),
          _buildCategoryChip(
              ScenarioCategory.radarOps, 'Radar', Icons.track_changes, isDark),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      ScenarioCategory? category, String label, IconData icon, bool isDark) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textSecondary
                        : AppColorsLight.textSecondary),
                fontSize: 11,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => setState(() {
          _selectedCategory = category == _selectedCategory ? null : category;
        }),
        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        side: BorderSide(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.border : AppColorsLight.border),
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter(bool isDark) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'ระดับ:',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          _buildDifficultyChip(ScenarioDifficulty.beginner, 'เริ่มต้น', isDark),
          _buildDifficultyChip(
              ScenarioDifficulty.intermediate, 'กลาง', isDark),
          _buildDifficultyChip(ScenarioDifficulty.advanced, 'สูง', isDark),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(
      ScenarioDifficulty difficulty, String label, bool isDark) {
    final isSelected = _selectedDifficulty == difficulty;
    final color = _getDifficultyColor(difficulty);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedDifficulty =
              difficulty == _selectedDifficulty ? null : difficulty;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioCard(ScenarioData scenario, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: scenario.isLocked
              ? null
              : () => _showScenarioDetail(scenario, isDark),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(scenario.category).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(scenario.category),
                        color: _getCategoryColor(scenario.category),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  scenario.title,
                                  style: TextStyle(
                                    color: scenario.isLocked
                                        ? (isDark
                                            ? AppColors.textMuted
                                            : AppColorsLight.textMuted)
                                        : (isDark
                                            ? AppColors.textPrimary
                                            : AppColorsLight.textPrimary),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (scenario.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withAlpha(30),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (scenario.isLocked)
                                const Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                            ],
                          ),
                          Text(
                            scenario.titleThai,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColorsLight.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  scenario.description,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColorsLight.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Tags Row
                Row(
                  children: [
                    _buildTag(
                      _getDifficultyName(scenario.difficulty),
                      _getDifficultyColor(scenario.difficulty),
                    ),
                    const SizedBox(width: 8),
                    _buildTag(
                      '${scenario.estimatedMinutes} นาที',
                      AppColors.textMuted,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '+${scenario.xpReward} XP',
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showScenarioDetail(ScenarioData scenario, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(scenario.category)
                                .withAlpha(30),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getCategoryIcon(scenario.category),
                            color: _getCategoryColor(scenario.category),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scenario.title,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : AppColorsLight.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                scenario.titleThai,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondary
                                      : AppColorsLight.textSecondary,
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
                    Text(
                      scenario.description,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondary
                            : AppColorsLight.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Row
                    Row(
                      children: [
                        _buildInfoCard(
                          icon: Icons.speed,
                          label: 'ระดับ',
                          value: _getDifficultyName(scenario.difficulty),
                          color: _getDifficultyColor(scenario.difficulty),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoCard(
                          icon: Icons.timer,
                          label: 'เวลา',
                          value: '${scenario.estimatedMinutes} นาที',
                          color: AppColors.primary,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoCard(
                          icon: Icons.star,
                          label: 'รางวัล',
                          value: '+${scenario.xpReward} XP',
                          color: AppColors.warning,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Objectives
                    Text(
                      'วัตถุประสงค์',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColorsLight.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...scenario.objectives.map((obj) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  obj,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : AppColorsLight.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),

                    // Skills
                    Text(
                      'ทักษะที่จะได้รับ',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColorsLight.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: scenario.skills.map((skill) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primary.withAlpha(50),
                              ),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Start Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.background : AppColorsLight.background,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.border : AppColorsLight.border,
                  ),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TacticalSimulator(
                            missionType: scenario.missionType,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('เริ่มภารกิจ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.background : AppColorsLight.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(ScenarioCategory category) {
    switch (category) {
      case ScenarioCategory.antiDrone:
        return AppColors.danger;
      case ScenarioCategory.sigint:
        return AppColors.primary;
      case ScenarioCategory.gpsWarfare:
        return Colors.cyan;
      case ScenarioCategory.commJamming:
        return AppColors.warning;
      case ScenarioCategory.radarOps:
        return AppColors.radar;
    }
  }

  IconData _getCategoryIcon(ScenarioCategory category) {
    switch (category) {
      case ScenarioCategory.antiDrone:
        return Icons.flight;
      case ScenarioCategory.sigint:
        return Icons.radar;
      case ScenarioCategory.gpsWarfare:
        return Icons.gps_fixed;
      case ScenarioCategory.commJamming:
        return Icons.wifi_off;
      case ScenarioCategory.radarOps:
        return Icons.track_changes;
    }
  }

  String _getDifficultyName(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.beginner:
        return 'เริ่มต้น';
      case ScenarioDifficulty.intermediate:
        return 'ปานกลาง';
      case ScenarioDifficulty.advanced:
        return 'ขั้นสูง';
    }
  }

  Color _getDifficultyColor(ScenarioDifficulty difficulty) {
    switch (difficulty) {
      case ScenarioDifficulty.beginner:
        return AppColors.success;
      case ScenarioDifficulty.intermediate:
        return AppColors.warning;
      case ScenarioDifficulty.advanced:
        return AppColors.danger;
    }
  }
}
