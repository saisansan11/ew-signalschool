import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

// Signal Data Model
enum SignalCategory {
  radar,
  communication,
  navigation,
  drone,
  wifi,
  bluetooth,
  military,
  broadcast,
}

enum ModulationType {
  am,
  fm,
  pulse,
  fsk,
  psk,
  qam,
  ofdm,
  spreadSpectrum,
  fhss,
  dsss,
  cw,
}

enum WaveformType {
  sine,
  square,
  pulse,
  chirp,
  noise,
  fhss,
  burst,
}

class SignalData {
  final String id;
  final String name;
  final String nameThai;
  final String description;
  final double frequencyMin; // MHz
  final double frequencyMax; // MHz
  final SignalCategory category;
  final ModulationType modulation;
  final WaveformType waveform;
  final double? bandwidth; // kHz
  final double? power; // dBm typical
  final String? usage;
  final String? ewNotes;
  final bool isMilitary;
  final List<String> tags;

  const SignalData({
    required this.id,
    required this.name,
    required this.nameThai,
    required this.description,
    required this.frequencyMin,
    required this.frequencyMax,
    required this.category,
    required this.modulation,
    required this.waveform,
    this.bandwidth,
    this.power,
    this.usage,
    this.ewNotes,
    this.isMilitary = false,
    this.tags = const [],
  });

  String get frequencyRange {
    if (frequencyMin == frequencyMax) {
      return _formatFreq(frequencyMin);
    }
    return '${_formatFreq(frequencyMin)} - ${_formatFreq(frequencyMax)}';
  }

  String _formatFreq(double mhz) {
    if (mhz >= 1000) {
      return '${(mhz / 1000).toStringAsFixed(mhz % 1000 == 0 ? 0 : 2)} GHz';
    } else if (mhz < 1) {
      return '${(mhz * 1000).toStringAsFixed(0)} kHz';
    }
    return '${mhz.toStringAsFixed(mhz == mhz.roundToDouble() ? 0 : 2)} MHz';
  }
}

class SignalLibraryScreen extends StatefulWidget {
  const SignalLibraryScreen({super.key});

  @override
  State<SignalLibraryScreen> createState() => _SignalLibraryScreenState();
}

class _SignalLibraryScreenState extends State<SignalLibraryScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  SignalCategory? _selectedCategory;
  late TabController _tabController;

  final List<String> _tabs = [
    'ทั้งหมด',
    'ทหาร',
    'พลเรือน',
    'Radar',
    'Drone',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SignalData> get _filteredSignals {
    var signals = _signalDatabase;

    // Filter by tab
    switch (_tabController.index) {
      case 1: // ทหาร
        signals = signals.where((s) => s.isMilitary).toList();
        break;
      case 2: // พลเรือน
        signals = signals.where((s) => !s.isMilitary).toList();
        break;
      case 3: // Radar
        signals = signals.where((s) => s.category == SignalCategory.radar).toList();
        break;
      case 4: // Drone
        signals = signals.where((s) => s.category == SignalCategory.drone).toList();
        break;
    }

    // Filter by category
    if (_selectedCategory != null) {
      signals = signals.where((s) => s.category == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      signals = signals.where((s) =>
          s.name.toLowerCase().contains(query) ||
          s.nameThai.toLowerCase().contains(query) ||
          s.description.toLowerCase().contains(query) ||
          s.tags.any((t) => t.toLowerCase().contains(query))).toList();
    }

    return signals;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        final filtered = _filteredSignals;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.waves,
                  size: 20,
                  color: isDark ? AppColors.primary : AppColorsLight.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'SIGNAL LIBRARY',
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
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
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: isDark ? AppColors.primary : AppColorsLight.primary,
              labelColor: isDark ? AppColors.primary : AppColorsLight.primary,
              unselectedLabelColor: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          body: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? AppColors.surface : AppColorsLight.surface,
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ค้นหาสัญญาณ...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? AppColors.background : AppColorsLight.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              // Category Filter Chips
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: SignalCategory.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: FilterChip(
                        label: Text(
                          _getCategoryName(cat),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                            fontSize: 12,
                          ),
                        ),
                        avatar: Icon(
                          _getCategoryIcon(cat),
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : _getCategoryColor(cat),
                        ),
                        selected: isSelected,
                        onSelected: (_) => setState(() {
                          _selectedCategory = isSelected ? null : cat;
                        }),
                        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
                        selectedColor: _getCategoryColor(cat),
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? _getCategoryColor(cat)
                              : (isDark ? AppColors.border : AppColorsLight.border),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Results Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt,
                      size: 14,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'พบ ${filtered.length} สัญญาณ',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Signal List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final signal = filtered[index];
                    return _buildSignalCard(signal, isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignalCard(SignalData signal, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor(signal.category).withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getCategoryIcon(signal.category),
            color: _getCategoryColor(signal.category),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                signal.name,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            if (signal.isMilitary)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.danger.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'MIL',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              signal.nameThai,
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.radio, size: 12,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted),
                const SizedBox(width: 4),
                Text(
                  signal.frequencyRange,
                  style: TextStyle(
                    color: isDark ? AppColors.primary : AppColorsLight.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          _buildSignalDetails(signal, isDark),
        ],
      ),
    );
  }

  Widget _buildSignalDetails(SignalData signal, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waveform Visualization
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? AppColors.background : AppColorsLight.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.border : AppColorsLight.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomPaint(
                size: const Size(double.infinity, 80),
                painter: WaveformPainter(
                  waveformType: signal.waveform,
                  color: _getCategoryColor(signal.category),
                  isDark: isDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            signal.description,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Technical Details Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDetailChip('Frequency', signal.frequencyRange, Icons.waves, isDark),
              if (signal.bandwidth != null)
                _buildDetailChip(
                  'Bandwidth',
                  signal.bandwidth! >= 1000
                      ? '${(signal.bandwidth! / 1000).toStringAsFixed(1)} MHz'
                      : '${signal.bandwidth!.toStringAsFixed(0)} kHz',
                  Icons.straighten,
                  isDark,
                ),
              _buildDetailChip('Modulation', _getModulationName(signal.modulation), Icons.graphic_eq, isDark),
              _buildDetailChip('Category', _getCategoryName(signal.category), Icons.category, isDark),
              if (signal.power != null)
                _buildDetailChip('Power', '${signal.power} dBm', Icons.power, isDark),
            ],
          ),

          // Usage
          if (signal.usage != null) ...[
            const SizedBox(height: 16),
            Text(
              'การใช้งาน',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              signal.usage!,
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                fontSize: 13,
              ),
            ),
          ],

          // EW Notes
          if (signal.ewNotes != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.warning.withAlpha(30)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, size: 16, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EW NOTES',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          signal.ewNotes!,
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Tags
          if (signal.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: signal.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.background : AppColorsLight.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.border : AppColorsLight.border,
                  ),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    fontSize: 10,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.background : AppColorsLight.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isDark ? AppColors.textMuted : AppColorsLight.textMuted),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  fontSize: 9,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryName(SignalCategory category) {
    switch (category) {
      case SignalCategory.radar:
        return 'Radar';
      case SignalCategory.communication:
        return 'Communication';
      case SignalCategory.navigation:
        return 'Navigation';
      case SignalCategory.drone:
        return 'Drone/UAV';
      case SignalCategory.wifi:
        return 'WiFi';
      case SignalCategory.bluetooth:
        return 'Bluetooth';
      case SignalCategory.military:
        return 'Military';
      case SignalCategory.broadcast:
        return 'Broadcast';
    }
  }

  IconData _getCategoryIcon(SignalCategory category) {
    switch (category) {
      case SignalCategory.radar:
        return Icons.radar;
      case SignalCategory.communication:
        return Icons.cell_tower;
      case SignalCategory.navigation:
        return Icons.gps_fixed;
      case SignalCategory.drone:
        return Icons.flight;
      case SignalCategory.wifi:
        return Icons.wifi;
      case SignalCategory.bluetooth:
        return Icons.bluetooth;
      case SignalCategory.military:
        return Icons.shield;
      case SignalCategory.broadcast:
        return Icons.radio;
    }
  }

  Color _getCategoryColor(SignalCategory category) {
    switch (category) {
      case SignalCategory.radar:
        return AppColors.radar;
      case SignalCategory.communication:
        return AppColors.primary;
      case SignalCategory.navigation:
        return Colors.cyan;
      case SignalCategory.drone:
        return AppColors.danger;
      case SignalCategory.wifi:
        return Colors.purple;
      case SignalCategory.bluetooth:
        return Colors.blue;
      case SignalCategory.military:
        return AppColors.warning;
      case SignalCategory.broadcast:
        return Colors.orange;
    }
  }

  String _getModulationName(ModulationType mod) {
    switch (mod) {
      case ModulationType.am:
        return 'AM';
      case ModulationType.fm:
        return 'FM';
      case ModulationType.pulse:
        return 'Pulse';
      case ModulationType.fsk:
        return 'FSK';
      case ModulationType.psk:
        return 'PSK';
      case ModulationType.qam:
        return 'QAM';
      case ModulationType.ofdm:
        return 'OFDM';
      case ModulationType.spreadSpectrum:
        return 'Spread Spectrum';
      case ModulationType.fhss:
        return 'FHSS';
      case ModulationType.dsss:
        return 'DSSS';
      case ModulationType.cw:
        return 'CW';
    }
  }

  // Signal Database
  final List<SignalData> _signalDatabase = [
    // Military Radars
    const SignalData(
      id: 'radar_apg77',
      name: 'AN/APG-77',
      nameThai: 'เรดาร์ F-22 Raptor',
      description: 'Active Electronically Scanned Array (AESA) radar ของ F-22 ใช้ X-Band มีความสามารถ LPI สูง',
      frequencyMin: 8000,
      frequencyMax: 12000,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.chirp,
      bandwidth: 1000000,
      isMilitary: true,
      usage: 'Air-to-Air, Air-to-Ground, Electronic Attack',
      ewNotes: 'ใช้ LPI waveforms ยากต่อการตรวจจับด้วย ESM ทั่วไป ต้องใช้ Digital ESM',
      tags: ['AESA', 'LPI', 'Stealth', 'Fighter'],
    ),
    const SignalData(
      id: 'radar_spydar',
      name: 'AN/SPY-1',
      nameThai: 'เรดาร์ Aegis',
      description: 'เรดาร์เฟสอาร์เรย์ S-Band ของระบบ Aegis ใช้บนเรือพิฆาต สามารถติดตามเป้าหมายได้มากกว่า 100 เป้าพร้อมกัน',
      frequencyMin: 2000,
      frequencyMax: 4000,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.pulse,
      bandwidth: 10000,
      isMilitary: true,
      usage: 'Air Defense, Ballistic Missile Defense',
      ewNotes: 'High PRF mode สำหรับ track, Low PRF สำหรับ search',
      tags: ['PESA', 'Naval', 'BMD', 'Multi-function'],
    ),
    const SignalData(
      id: 'radar_awacs',
      name: 'AN/APY-2',
      nameThai: 'เรดาร์ AWACS E-3',
      description: 'เรดาร์ตรวจการณ์ทางอากาศ S-Band บน E-3 Sentry มีระยะตรวจจับมากกว่า 400 km',
      frequencyMin: 2000,
      frequencyMax: 4000,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.pulse,
      bandwidth: 5000,
      power: 70,
      isMilitary: true,
      usage: 'Airborne Early Warning & Control',
      ewNotes: 'เป้าหมายหลักของ Stand-off Jammers',
      tags: ['AEW', 'Surveillance', 'C2'],
    ),
    const SignalData(
      id: 'radar_groundbased',
      name: 'AN/TPS-80 G/ATOR',
      nameThai: 'เรดาร์ภาคพื้น USMC',
      description: 'เรดาร์หลายหน้าที่ของนาวิกโยธินสหรัฐ ใช้ S-Band AESA',
      frequencyMin: 2000,
      frequencyMax: 4000,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.chirp,
      bandwidth: 50000,
      isMilitary: true,
      usage: 'Air Defense, Air Traffic Control, Counter-Fire',
      ewNotes: 'AESA radar มี ECCM ที่ดีมาก ยากต่อการ Jam',
      tags: ['AESA', 'Multi-role', 'Ground-based'],
    ),

    // Navigation Signals
    const SignalData(
      id: 'gps_l1',
      name: 'GPS L1 C/A',
      nameThai: 'สัญญาณ GPS พลเรือน',
      description: 'สัญญาณนำทาง GPS L1 ใช้ DSSS modulation ที่ 1575.42 MHz',
      frequencyMin: 1575.42,
      frequencyMax: 1575.42,
      category: SignalCategory.navigation,
      modulation: ModulationType.dsss,
      waveform: WaveformType.noise,
      bandwidth: 2046,
      power: -130,
      usage: 'การนำทาง, การระบุตำแหน่ง, การอ้างอิงเวลา',
      ewNotes: 'สัญญาณอ่อนมาก (-130 dBm) ง่ายต่อการ Jam ด้วยกำลังต่ำ',
      tags: ['GNSS', 'PNT', 'Civil'],
    ),
    const SignalData(
      id: 'gps_l2',
      name: 'GPS L2 P(Y)',
      nameThai: 'สัญญาณ GPS ทหาร',
      description: 'สัญญาณนำทาง GPS L2 encrypted สำหรับทหาร ที่ 1227.60 MHz',
      frequencyMin: 1227.60,
      frequencyMax: 1227.60,
      category: SignalCategory.navigation,
      modulation: ModulationType.dsss,
      waveform: WaveformType.noise,
      bandwidth: 20460,
      power: -130,
      isMilitary: true,
      usage: 'การนำทางทหาร, อาวุธนำวิถี',
      ewNotes: 'Encrypted และมี Anti-Jam ดีกว่า L1 แต่ยังคง Jam ได้',
      tags: ['GNSS', 'Military', 'Encrypted'],
    ),
    const SignalData(
      id: 'glonass',
      name: 'GLONASS L1',
      nameThai: 'ระบบนำทางรัสเซีย',
      description: 'ระบบดาวเทียมนำทางของรัสเซีย ใช้ FDMA ที่ 1602 MHz',
      frequencyMin: 1598.0625,
      frequencyMax: 1605.375,
      category: SignalCategory.navigation,
      modulation: ModulationType.dsss,
      waveform: WaveformType.noise,
      bandwidth: 511,
      power: -131,
      usage: 'การนำทาง, ระบุตำแหน่ง',
      ewNotes: 'ใช้ FDMA ต่างจาก GPS ทำให้การ Jam ซับซ้อนกว่า',
      tags: ['GNSS', 'Russia', 'FDMA'],
    ),

    // Drone Control
    const SignalData(
      id: 'drone_dji',
      name: 'DJI OcuSync',
      nameThai: 'ลิงค์ควบคุม DJI',
      description: 'ระบบควบคุมโดรน DJI ใช้ 2.4 GHz และ 5.8 GHz พร้อม FHSS',
      frequencyMin: 2400,
      frequencyMax: 2483,
      category: SignalCategory.drone,
      modulation: ModulationType.fhss,
      waveform: WaveformType.fhss,
      bandwidth: 20000,
      power: 20,
      usage: 'ควบคุมโดรน, ส่งภาพ Video Downlink',
      ewNotes: 'FHSS ทำให้ต้องใช้ Barrage Jamming กำลังสูง หรือ Protocol-aware Jamming',
      tags: ['Consumer', 'FHSS', 'Video Link'],
    ),
    const SignalData(
      id: 'drone_5g',
      name: 'DJI 5.8 GHz Link',
      nameThai: 'ลิงค์ 5.8 GHz DJI',
      description: 'ช่องสัญญาณ 5.8 GHz ของโดรน DJI สำหรับ Video Downlink',
      frequencyMin: 5725,
      frequencyMax: 5850,
      category: SignalCategory.drone,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 40000,
      power: 25,
      usage: 'HD Video Transmission',
      ewNotes: 'ระยะสั้นกว่า 2.4 GHz แต่ Bandwidth สูงกว่า',
      tags: ['Video', 'ISM Band', 'High Bandwidth'],
    ),
    const SignalData(
      id: 'drone_military',
      name: 'Military UAV C2',
      nameThai: 'ลิงค์ควบคุม UAV ทหาร',
      description: 'สัญญาณควบคุม UAV ทหาร ใช้ S-Band encrypted',
      frequencyMin: 2200,
      frequencyMax: 2400,
      category: SignalCategory.drone,
      modulation: ModulationType.fhss,
      waveform: WaveformType.fhss,
      bandwidth: 50000,
      isMilitary: true,
      usage: 'UAV Command & Control',
      ewNotes: 'Encrypted, FHSS, มี Anti-Jam ที่ดี ต้องใช้ High-power Jamming',
      tags: ['Encrypted', 'Military', 'FHSS'],
    ),
    const SignalData(
      id: 'fpv_analog',
      name: 'FPV Analog Video',
      nameThai: 'FPV วิดีโออนาล็อก',
      description: 'สัญญาณวิดีโออนาล็อกสำหรับ FPV Racing Drone ใช้ 5.8 GHz',
      frequencyMin: 5658,
      frequencyMax: 5917,
      category: SignalCategory.drone,
      modulation: ModulationType.fm,
      waveform: WaveformType.sine,
      bandwidth: 18000,
      power: 25,
      usage: 'FPV Racing, Hobby Drones',
      ewNotes: 'อนาล็อก FM ง่ายต่อการ Jam ด้วย FM Noise Jamming',
      tags: ['Analog', 'FPV', 'Racing'],
    ),

    // WiFi
    const SignalData(
      id: 'wifi_24',
      name: 'WiFi 2.4 GHz',
      nameThai: 'ไวไฟ 2.4 GHz',
      description: 'มาตรฐาน IEEE 802.11 b/g/n/ax ที่ 2.4 GHz',
      frequencyMin: 2400,
      frequencyMax: 2483.5,
      category: SignalCategory.wifi,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 20000,
      power: 20,
      usage: 'Internet, IoT Devices',
      ewNotes: 'แชร์ความถี่กับ Bluetooth และ Drone Control',
      tags: ['ISM', '802.11', 'Consumer'],
    ),
    const SignalData(
      id: 'wifi_5',
      name: 'WiFi 5 GHz',
      nameThai: 'ไวไฟ 5 GHz',
      description: 'มาตรฐาน IEEE 802.11 a/n/ac/ax ที่ 5 GHz',
      frequencyMin: 5150,
      frequencyMax: 5850,
      category: SignalCategory.wifi,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 160000,
      power: 23,
      usage: 'High-speed Internet',
      ewNotes: 'ระยะสั้นกว่า 2.4 GHz แต่มี Channel มากกว่า',
      tags: ['UNII', '802.11ac', 'High Speed'],
    ),

    // Bluetooth
    const SignalData(
      id: 'bluetooth',
      name: 'Bluetooth Classic',
      nameThai: 'บลูทูธ',
      description: 'Bluetooth Classic (BR/EDR) ใช้ FHSS ที่ 2.4 GHz',
      frequencyMin: 2402,
      frequencyMax: 2480,
      category: SignalCategory.bluetooth,
      modulation: ModulationType.fhss,
      waveform: WaveformType.fhss,
      bandwidth: 1000,
      power: 4,
      usage: 'Audio, File Transfer, HID',
      ewNotes: 'FHSS 1600 hops/sec ทำให้ยากต่อการ Jam แบบ Spot',
      tags: ['ISM', 'FHSS', 'Short Range'],
    ),
    const SignalData(
      id: 'ble',
      name: 'Bluetooth Low Energy',
      nameThai: 'บลูทูธประหยัดพลังงาน',
      description: 'BLE (Bluetooth 4.0+) ใช้ 40 channels ที่ 2.4 GHz',
      frequencyMin: 2402,
      frequencyMax: 2480,
      category: SignalCategory.bluetooth,
      modulation: ModulationType.fsk,
      waveform: WaveformType.burst,
      bandwidth: 2000,
      power: 0,
      usage: 'IoT, Beacons, Wearables',
      ewNotes: 'กำลังต่ำมาก มักใช้กับ IoT และ Location Beacons',
      tags: ['IoT', 'Low Power', 'Beacons'],
    ),

    // Communication
    const SignalData(
      id: 'lte',
      name: 'LTE/4G',
      nameThai: 'แอลทีอี/4G',
      description: 'Long Term Evolution มาตรฐาน 4G หลายย่านความถี่',
      frequencyMin: 700,
      frequencyMax: 2600,
      category: SignalCategory.communication,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 20000,
      usage: 'Mobile Internet, Voice',
      ewNotes: 'ใช้หลายย่านความถี่ ต้อง Jam หลาย Band พร้อมกัน',
      tags: ['4G', 'OFDM', 'Mobile'],
    ),
    const SignalData(
      id: '5g_nr',
      name: '5G NR',
      nameThai: '5G New Radio',
      description: '5G New Radio ทั้ง Sub-6 GHz และ mmWave',
      frequencyMin: 600,
      frequencyMax: 39000,
      category: SignalCategory.communication,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 400000,
      usage: 'Enhanced Mobile Broadband, IoT, Low Latency',
      ewNotes: 'mmWave ระยะสั้นมาก Sub-6 มีการใช้งานกว้างกว่า',
      tags: ['5G', 'mmWave', 'Beamforming'],
    ),
    const SignalData(
      id: 'vhf_military',
      name: 'VHF CNR',
      nameThai: 'วิทยุ VHF ทหาร',
      description: 'Combat Net Radio ทหาร 30-88 MHz ใช้ FM และ ECCM',
      frequencyMin: 30,
      frequencyMax: 88,
      category: SignalCategory.military,
      modulation: ModulationType.fm,
      waveform: WaveformType.sine,
      bandwidth: 25,
      power: 43,
      isMilitary: true,
      usage: 'Tactical Communications',
      ewNotes: 'ย่านความถี่หลักของการสื่อสารทางยุทธวิธี มักเป็นเป้าหมาย Jamming',
      tags: ['CNR', 'Tactical', 'FM'],
    ),
    const SignalData(
      id: 'uhf_satcom',
      name: 'UHF SATCOM',
      nameThai: 'สื่อสารดาวเทียม UHF',
      description: 'ระบบสื่อสารดาวเทียมทหาร UHF 225-400 MHz',
      frequencyMin: 225,
      frequencyMax: 400,
      category: SignalCategory.military,
      modulation: ModulationType.fhss,
      waveform: WaveformType.fhss,
      bandwidth: 5000,
      isMilitary: true,
      usage: 'Beyond Line-of-Sight Communications',
      ewNotes: 'ใช้ FHSS และ Spread Spectrum สำหรับ Anti-Jam',
      tags: ['SATCOM', 'BLOS', 'Encrypted'],
    ),
    const SignalData(
      id: 'hf_military',
      name: 'HF ALE',
      nameThai: 'HF อัตโนมัติ',
      description: 'High Frequency Automatic Link Establishment 2-30 MHz',
      frequencyMin: 2,
      frequencyMax: 30,
      category: SignalCategory.military,
      modulation: ModulationType.fsk,
      waveform: WaveformType.burst,
      bandwidth: 3,
      power: 40,
      isMilitary: true,
      usage: 'Long Range Communications, BLOS Backup',
      ewNotes: 'ใช้ Skywave propagation ระยะไกลมาก แต่คุณภาพไม่แน่นอน',
      tags: ['HF', 'Skywave', 'Strategic'],
    ),

    // Broadcast
    const SignalData(
      id: 'fm_broadcast',
      name: 'FM Broadcast',
      nameThai: 'วิทยุ FM',
      description: 'วิทยุกระจายเสียง FM 88-108 MHz',
      frequencyMin: 88,
      frequencyMax: 108,
      category: SignalCategory.broadcast,
      modulation: ModulationType.fm,
      waveform: WaveformType.sine,
      bandwidth: 200,
      power: 50,
      usage: 'Entertainment, Public Broadcasting',
      ewNotes: 'กำลังส่งสูงมาก ใช้เป็น reference สำหรับ location',
      tags: ['Broadcast', 'Entertainment', 'High Power'],
    ),
    const SignalData(
      id: 'tv_digital',
      name: 'DVB-T2',
      nameThai: 'ทีวีดิจิตอล',
      description: 'Digital Video Broadcasting Terrestrial 470-694 MHz',
      frequencyMin: 470,
      frequencyMax: 694,
      category: SignalCategory.broadcast,
      modulation: ModulationType.ofdm,
      waveform: WaveformType.burst,
      bandwidth: 8000,
      power: 60,
      usage: 'Digital TV Broadcasting',
      ewNotes: 'High power transmitters ใช้เป็น passive radar illuminators',
      tags: ['DTV', 'OFDM', 'UHF'],
    ),

    // Radar - Weather
    const SignalData(
      id: 'weather_radar',
      name: 'Weather Radar',
      nameThai: 'เรดาร์อากาศ',
      description: 'เรดาร์ตรวจอากาศ S-Band และ C-Band',
      frequencyMin: 2700,
      frequencyMax: 5600,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.pulse,
      bandwidth: 1000,
      power: 65,
      usage: 'Weather Monitoring, Storm Tracking',
      ewNotes: 'ไม่ใช่เป้าหมาย EW แต่สามารถใช้ระบุ terrain clutter',
      tags: ['Weather', 'Doppler', 'Civil'],
    ),
    const SignalData(
      id: 'asr_radar',
      name: 'Airport Surveillance Radar',
      nameThai: 'เรดาร์สนามบิน',
      description: 'ASR เรดาร์ตรวจการณ์สนามบิน S-Band',
      frequencyMin: 2700,
      frequencyMax: 2900,
      category: SignalCategory.radar,
      modulation: ModulationType.pulse,
      waveform: WaveformType.pulse,
      bandwidth: 1000,
      usage: 'Air Traffic Control, Airport Surveillance',
      ewNotes: 'Civil radar มีความสำคัญต่อความปลอดภัยการบิน',
      tags: ['ATC', 'Civil', 'Surveillance'],
    ),

    // Link-16
    const SignalData(
      id: 'link16',
      name: 'Link-16 (TADIL-J)',
      nameThai: 'ลิงค์-16',
      description: 'Tactical Data Link ทหาร NATO L-Band 960-1215 MHz',
      frequencyMin: 960,
      frequencyMax: 1215,
      category: SignalCategory.military,
      modulation: ModulationType.fhss,
      waveform: WaveformType.fhss,
      bandwidth: 3000,
      isMilitary: true,
      usage: 'Tactical Data Exchange, Situational Awareness',
      ewNotes: 'FHSS + TDMA มี Anti-Jam ที่ดีมาก เป็น Critical Asset',
      tags: ['Data Link', 'TDMA', 'NATO'],
    ),
  ];
}

// Waveform Painter
class WaveformPainter extends CustomPainter {
  final WaveformType waveformType;
  final Color color;
  final bool isDark;

  WaveformPainter({
    required this.waveformType,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = (isDark ? AppColors.border : AppColorsLight.border).withAlpha(80)
      ..strokeWidth = 0.5;

    // Draw grid
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (int i = 0; i <= 8; i++) {
      final x = size.width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final path = Path();
    final centerY = size.height / 2;
    final amplitude = size.height * 0.35;
    final random = Random(42); // Fixed seed for consistency

    switch (waveformType) {
      case WaveformType.sine:
        _drawSineWave(path, size, centerY, amplitude);
        break;
      case WaveformType.square:
        _drawSquareWave(path, size, centerY, amplitude);
        break;
      case WaveformType.pulse:
        _drawPulseWave(path, size, centerY, amplitude);
        break;
      case WaveformType.chirp:
        _drawChirpWave(path, size, centerY, amplitude);
        break;
      case WaveformType.noise:
        _drawNoiseWave(path, size, centerY, amplitude, random);
        break;
      case WaveformType.fhss:
        _drawFHSSWave(path, size, centerY, amplitude, random);
        break;
      case WaveformType.burst:
        _drawBurstWave(path, size, centerY, amplitude);
        break;
    }

    // Draw glow effect
    final glowPaint = Paint()
      ..color = color.withAlpha(50)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);

    canvas.drawPath(path, paint);
  }

  void _drawSineWave(Path path, Size size, double centerY, double amplitude) {
    path.moveTo(0, centerY);
    for (double x = 0; x <= size.width; x++) {
      final y = centerY + amplitude * sin(x * 0.05);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
  }

  void _drawSquareWave(Path path, Size size, double centerY, double amplitude) {
    path.moveTo(0, centerY - amplitude);
    final period = size.width / 4;
    for (int i = 0; i < 4; i++) {
      final x = i * period;
      if (i % 2 == 0) {
        path.lineTo(x + period, centerY - amplitude);
        path.lineTo(x + period, centerY + amplitude);
      } else {
        path.lineTo(x + period, centerY + amplitude);
        path.lineTo(x + period, centerY - amplitude);
      }
    }
  }

  void _drawPulseWave(Path path, Size size, double centerY, double amplitude) {
    path.moveTo(0, centerY);
    final pulseWidth = size.width / 8;
    final spacing = size.width / 4;
    for (int i = 0; i < 4; i++) {
      final x = i * spacing;
      path.lineTo(x, centerY);
      path.lineTo(x, centerY - amplitude);
      path.lineTo(x + pulseWidth, centerY - amplitude);
      path.lineTo(x + pulseWidth, centerY);
    }
    path.lineTo(size.width, centerY);
  }

  void _drawChirpWave(Path path, Size size, double centerY, double amplitude) {
    path.moveTo(0, centerY);
    for (double x = 0; x <= size.width; x++) {
      final freq = 0.02 + x / size.width * 0.15;
      final y = centerY + amplitude * sin(x * freq * x / 10);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
  }

  void _drawNoiseWave(Path path, Size size, double centerY, double amplitude, Random random) {
    path.moveTo(0, centerY);
    for (double x = 0; x <= size.width; x += 2) {
      final y = centerY + (random.nextDouble() - 0.5) * amplitude * 2;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
  }

  void _drawFHSSWave(Path path, Size size, double centerY, double amplitude, Random random) {
    path.moveTo(0, centerY);
    final hopWidth = size.width / 8;
    for (int i = 0; i < 8; i++) {
      final x = i * hopWidth;
      final freq = 0.1 + random.nextDouble() * 0.2;
      for (double dx = 0; dx < hopWidth; dx += 2) {
        final y = centerY + amplitude * 0.7 * sin((x + dx) * freq);
        if (x == 0 && dx == 0) {
          path.moveTo(x + dx, y);
        } else {
          path.lineTo(x + dx, y);
        }
      }
    }
  }

  void _drawBurstWave(Path path, Size size, double centerY, double amplitude) {
    path.moveTo(0, centerY);
    final burstWidth = size.width / 6;
    final gapWidth = size.width / 12;
    double x = 0;
    while (x < size.width) {
      // Gap
      path.lineTo(x + gapWidth, centerY);
      x += gapWidth;
      // Burst
      for (double dx = 0; dx < burstWidth && x + dx < size.width; dx += 2) {
        final y = centerY + amplitude * sin((dx) * 0.3);
        path.lineTo(x + dx, y);
      }
      x += burstWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
