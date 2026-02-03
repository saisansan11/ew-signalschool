import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

class QuickReferenceScreen extends StatefulWidget {
  const QuickReferenceScreen({super.key});

  @override
  State<QuickReferenceScreen> createState() => _QuickReferenceScreenState();
}

class _QuickReferenceScreenState extends State<QuickReferenceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<ReferenceCategory> _categories = [
    ReferenceCategory(
      name: 'สูตร EW',
      icon: Icons.functions,
      color: Colors.blue,
      cards: [
        ReferenceCard(
          title: 'Radar Range Equation',
          titleThai: 'สมการระยะเรดาร์',
          content: '''R = ⁴√[(Pt × G² × λ² × σ) / ((4π)³ × Pr_min)]

โดยที่:
• R = ระยะตรวจจับ (m)
• Pt = กำลังส่ง (W)
• G = Antenna Gain
• λ = ความยาวคลื่น (m)
• σ = Radar Cross Section (m²)
• Pr_min = ความไวรับขั้นต่ำ (W)''',
          tags: ['Radar', 'Detection', 'Formula'],
        ),
        ReferenceCard(
          title: 'Free Space Path Loss',
          titleThai: 'การสูญเสียในอากาศ',
          content: '''FSPL (dB) = 20×log₁₀(d) + 20×log₁₀(f) + 32.45

โดยที่:
• d = ระยะทาง (km)
• f = ความถี่ (MHz)

ตัวอย่าง: 10 km @ 1 GHz
FSPL = 20×log(10) + 20×log(1000) + 32.45
     = 20 + 60 + 32.45 = 112.45 dB''',
          tags: ['Path Loss', 'RF', 'Link Budget'],
        ),
        ReferenceCard(
          title: 'J/S Ratio',
          titleThai: 'อัตราส่วน Jamming-to-Signal',
          content: '''J/S = (Pj × Gj × Gr × Rt²) / (Pt × Gt × Rj²)

โดยที่:
• Pj = กำลังส่ง Jammer (W)
• Gj = Gain ของ Jammer
• Gr = Gain ของเรดาร์ทิศรับ
• Pt = กำลังส่งเรดาร์ (W)
• Gt = Gain ของเรดาร์ทิศส่ง
• Rt = ระยะเป้าหมาย (m)
• Rj = ระยะ Jammer (m)

ต้องการ J/S > 0 dB เพื่อ Jam สำเร็จ''',
          tags: ['Jamming', 'ECM', 'Formula'],
        ),
        ReferenceCard(
          title: 'Burn-through Range',
          titleThai: 'ระยะทะลุ Jamming',
          content: '''Rb = ⁴√[(Pt × Gt × σ × Bj) / (Pj × Gj × 4π × Br)]

เมื่อเป้าหมายเข้าใกล้กว่า Burn-through Range
เรดาร์จะสามารถตรวจจับได้แม้ถูก Jam

ปัจจัยสำคัญ:
• กำลังส่งเรดาร์สูง = Rb ไกลขึ้น
• RCS เป้าหมายใหญ่ = Rb ไกลขึ้น
• กำลัง Jammer สูง = Rb ใกล้ลง''',
          tags: ['Jamming', 'Radar', 'ECM'],
        ),
        ReferenceCard(
          title: 'Link Budget',
          titleThai: 'งบประมาณลิงก์',
          content: '''Pr = Pt + Gt - FSPL + Gr - Lmisc

โดยที่:
• Pr = กำลังรับ (dBm)
• Pt = กำลังส่ง (dBm)
• Gt = Gain เสาอากาศส่ง (dBi)
• Gr = Gain เสาอากาศรับ (dBi)
• FSPL = Free Space Path Loss (dB)
• Lmisc = การสูญเสียอื่นๆ (dB)

Link Margin = Pr - Sensitivity''',
          tags: ['Link Budget', 'RF', 'Communication'],
        ),
        ReferenceCard(
          title: 'Wavelength-Frequency',
          titleThai: 'ความยาวคลื่น-ความถี่',
          content: '''λ = c / f

โดยที่:
• λ = ความยาวคลื่น (m)
• c = 3×10⁸ m/s (ความเร็วแสง)
• f = ความถี่ (Hz)

ตัวอย่าง:
• 100 MHz → λ = 3 m
• 1 GHz → λ = 30 cm
• 10 GHz → λ = 3 cm
• 30 GHz → λ = 1 cm''',
          tags: ['Basic', 'RF', 'Formula'],
        ),
      ],
    ),
    ReferenceCategory(
      name: 'ย่านความถี่',
      icon: Icons.waves,
      color: Colors.green,
      cards: [
        ReferenceCard(
          title: 'NATO Frequency Bands',
          titleThai: 'ย่านความถี่ NATO',
          content: '''Band   Frequency        Usage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HF     3-30 MHz        Long-range Comms
VHF    30-300 MHz      Tactical Radio
UHF    300-1000 MHz    SATCOM, Tactical
L      1-2 GHz         GPS, ATC Radar
S      2-4 GHz         Air Search Radar
C      4-8 GHz         Weather Radar
X      8-12 GHz        Fire Control
Ku     12-18 GHz       SATCOM, SAR
K      18-27 GHz       Limited use
Ka     27-40 GHz       High-res SAR''',
          tags: ['Frequency', 'NATO', 'Bands'],
        ),
        ReferenceCard(
          title: 'Tactical Radio Frequencies',
          titleThai: 'ความถี่วิทยุยุทธวิธี',
          content: '''VHF Low Band (30-88 MHz)
• ระยะไกล, ทะลุอาคาร
• ใช้ SINCGARS

VHF High Band (136-174 MHz)
• Public Safety, Aviation
• FM analog

UHF (225-400 MHz)
• SATCOM uplink
• Air-Ground

UHF SATCOM (290-320 MHz)
• MILSATCOM uplink''',
          tags: ['Tactical', 'Radio', 'Military'],
        ),
        ReferenceCard(
          title: 'Drone Control Frequencies',
          titleThai: 'ความถี่ควบคุมโดรน',
          content: '''Common Drone Frequencies:
━━━━━━━━━━━━━━━━━━━━━━━━━
433 MHz    - EU ISM Band
900 MHz    - US ISM Band
2.4 GHz    - Wi-Fi, FPV
5.8 GHz    - FPV Video
1.2 GHz    - Long Range FPV

DJI Specific:
• 2.4 GHz - Control Link
• 5.8 GHz - Video Link
• OcuSync: 2.4/5.8 GHz dual''',
          tags: ['Drone', 'UAS', 'Control'],
        ),
        ReferenceCard(
          title: 'GNSS Frequencies',
          titleThai: 'ความถี่ระบบนำทาง',
          content: '''GPS (USA):
• L1: 1575.42 MHz (C/A code)
• L2: 1227.60 MHz (P code)
• L5: 1176.45 MHz (Safety)

GLONASS (Russia):
• L1: 1598-1605 MHz
• L2: 1242-1249 MHz

Galileo (EU):
• E1: 1575.42 MHz
• E5: 1176.45 MHz

BeiDou (China):
• B1: 1561.098 MHz
• B2: 1207.14 MHz''',
          tags: ['GPS', 'GNSS', 'Navigation'],
        ),
      ],
    ),
    ReferenceCategory(
      name: 'เทคนิค Jamming',
      icon: Icons.flash_on,
      color: Colors.red,
      cards: [
        ReferenceCard(
          title: 'Jamming Types',
          titleThai: 'ประเภทการรบกวน',
          content: '''1. SPOT JAMMING
   • เน้นความถี่เดียว
   • พลังงานสูงสุด
   • ต้องรู้ความถี่เป้าหมาย

2. BARRAGE JAMMING
   • ครอบคลุมหลายความถี่
   • พลังงานกระจาย
   • ไม่ต้องรู้ความถี่แน่นอน

3. SWEEP JAMMING
   • กวาดข้ามย่านความถี่
   • ประหยัดพลังงาน
   • เหมาะกับ FHSS''',
          tags: ['Jamming', 'ECM', 'Types'],
        ),
        ReferenceCard(
          title: 'Jamming Effectiveness',
          titleThai: 'ประสิทธิภาพการรบกวน',
          content: '''ปัจจัยที่มีผล:
━━━━━━━━━━━━━━━━━━
• J/S Ratio (ต้อง > 0 dB)
• ความตรงความถี่
• ทิศทาง Antenna
• ระยะห่าง
• ภูมิประเทศ

ความต้องการ J/S ขั้นต่ำ:
• AM Voice: 10 dB
• FM Voice: 6 dB
• Digital Data: 3-10 dB
• Spread Spectrum: 0 dB (at despreading)''',
          tags: ['Jamming', 'Effectiveness', 'ECM'],
        ),
        ReferenceCard(
          title: 'Anti-Jam Techniques (ECCM)',
          titleThai: 'เทคนิคต้านการรบกวน',
          content: '''1. FREQUENCY HOPPING (FHSS)
   • กระโดดความถี่เร็ว
   • SINCGARS: 100 hops/sec

2. SPREAD SPECTRUM (DSSS)
   • กระจายสัญญาณในแบนด์กว้าง
   • ต้องรู้ spreading code

3. POWER INCREASE
   • เพิ่มกำลังส่งชั่วคราว
   • Burn-through jamming

4. DIRECTIONAL ANTENNA
   • ลด sidelobe gain
   • เพิ่ม main beam gain''',
          tags: ['ECCM', 'Anti-Jam', 'Protection'],
        ),
        ReferenceCard(
          title: 'GPS Jamming/Spoofing',
          titleThai: 'การรบกวน/หลอก GPS',
          content: '''GPS JAMMING:
• ส่งสัญญาณรบกวน L1/L2
• ผลลัพธ์: No GPS Fix
• ตรวจจับได้ง่าย

GPS SPOOFING:
• ส่งสัญญาณ GPS ปลอม
• ผลลัพธ์: ตำแหน่งผิด
• ตรวจจับยากกว่า

การป้องกัน:
• Multi-GNSS (GPS+GLONASS)
• Antenna null steering
• INS integration
• Crypto GPS (M-code)''',
          tags: ['GPS', 'Spoofing', 'Navigation'],
        ),
      ],
    ),
    ReferenceCategory(
      name: 'ESM/SIGINT',
      icon: Icons.radar,
      color: Colors.purple,
      cards: [
        ReferenceCard(
          title: 'Signal Parameters',
          titleThai: 'พารามิเตอร์สัญญาณ',
          content: '''พารามิเตอร์พื้นฐาน:
━━━━━━━━━━━━━━━━━━━━
• RF (Frequency)
• PRI/PRF (Pulse timing)
• PW (Pulse Width)
• Amplitude/Power
• AOA (Angle of Arrival)

พารามิเตอร์เพิ่มเติม:
• Modulation type
• Scan pattern
• Polarization
• Antenna pattern''',
          tags: ['ESM', 'Signal', 'Parameters'],
        ),
        ReferenceCard(
          title: 'Radar Classifications',
          titleThai: 'การจำแนกเรดาร์',
          content: '''ตามหน้าที่:
• Search Radar (ค้นหา)
• Track Radar (ติดตาม)
• Fire Control (ควบคุมยิง)
• Weather (อากาศ)

ตาม Waveform:
• Pulse Radar
• CW Radar
• Pulse-Doppler
• FMCW

ตาม Platform:
• Ground-based
• Airborne (AWACS)
• Naval
• Space-based''',
          tags: ['Radar', 'Classification', 'ESM'],
        ),
        ReferenceCard(
          title: 'Direction Finding',
          titleThai: 'การหาทิศทาง',
          content: '''เทคนิค DF:
━━━━━━━━━━━━━━━━━━
1. Amplitude Comparison
   • เปรียบเทียบความแรง
   • ความแม่นยำ: 5-10°

2. Phase Interferometer
   • วัด phase difference
   • ความแม่นยำ: 1-2°

3. Time Difference of Arrival
   • วัดเวลาถึงแต่ละ antenna
   • ความแม่นยำ: <1°

4. Doppler DF
   • ใช้ rotating antenna
   • เหมาะกับ CW signals''',
          tags: ['DF', 'Direction Finding', 'ESM'],
        ),
        ReferenceCard(
          title: 'Emitter Database',
          titleThai: 'ฐานข้อมูล Emitter',
          content: '''ข้อมูลที่ต้องเก็บ:
━━━━━━━━━━━━━━━━━━━━
• Emitter ID/Name
• Frequency range
• PRF/PRI range
• Pulse width range
• Scan type
• Associated platform
• Threat level

การใช้งาน:
• Real-time identification
• EOB development
• Threat warning
• Mission planning''',
          tags: ['Database', 'EOB', 'ESM'],
        ),
      ],
    ),
    ReferenceCategory(
      name: 'Unit Conversion',
      icon: Icons.swap_horiz,
      color: Colors.teal,
      cards: [
        ReferenceCard(
          title: 'Power Conversions',
          titleThai: 'แปลงหน่วยกำลัง',
          content: '''dBm ↔ Watts:
━━━━━━━━━━━━━━━━━━━━━
dBm = 10 × log₁₀(P_mW)
P_mW = 10^(dBm/10)

Quick Reference:
• 0 dBm = 1 mW
• 10 dBm = 10 mW
• 20 dBm = 100 mW
• 30 dBm = 1 W
• 40 dBm = 10 W
• 50 dBm = 100 W
• 60 dBm = 1 kW

dBW = dBm - 30''',
          tags: ['Power', 'Conversion', 'dBm'],
        ),
        ReferenceCard(
          title: 'Distance & Speed',
          titleThai: 'ระยะทางและความเร็ว',
          content: '''Distance:
• 1 NM = 1.852 km
• 1 km = 0.54 NM
• 1 mile = 1.609 km

Speed:
• 1 knot = 1.852 km/h
• 1 knot = 0.514 m/s
• Mach 1 ≈ 343 m/s (at sea level)

Light/Radio:
• c = 299,792 km/s
• c ≈ 300,000 km/s
• 1 light-μs = 300 m''',
          tags: ['Distance', 'Speed', 'Conversion'],
        ),
        ReferenceCard(
          title: 'Antenna Gain',
          titleThai: 'อัตราขยายเสาอากาศ',
          content: '''Linear ↔ dB:
━━━━━━━━━━━━━━━━━
G_dB = 10 × log₁₀(G_linear)
G_linear = 10^(G_dB/10)

Quick Reference:
• 0 dB = 1x
• 3 dB = 2x
• 6 dB = 4x
• 10 dB = 10x
• 20 dB = 100x
• 30 dB = 1000x

dBi vs dBd:
• dBi = dBd + 2.15''',
          tags: ['Antenna', 'Gain', 'dB'],
        ),
        ReferenceCard(
          title: 'Time & Frequency',
          titleThai: 'เวลาและความถี่',
          content: '''Period ↔ Frequency:
━━━━━━━━━━━━━━━━━━━
f = 1/T
T = 1/f

Quick Reference:
• 1 Hz = 1 s period
• 1 kHz = 1 ms period
• 1 MHz = 1 μs period
• 1 GHz = 1 ns period

PRF ↔ PRI:
• PRF (Hz) = 1/PRI (s)
• PRF = 1000 Hz → PRI = 1 ms''',
          tags: ['Time', 'Frequency', 'PRF'],
        ),
      ],
    ),
    ReferenceCategory(
      name: 'Threat Tables',
      icon: Icons.warning,
      color: Colors.orange,
      cards: [
        ReferenceCard(
          title: 'SAM Threat Parameters',
          titleThai: 'พารามิเตอร์ภัยคุกคาม SAM',
          content: '''System         Freq      Range
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SA-2 Guideline  E/F      45 km
SA-3 Goa        G/H      25 km
SA-6 Gainful    G/H      24 km
SA-8 Gecko      J        15 km
SA-10 Grumble   C/X      150 km
SA-11 Gadfly    G/H      35 km
SA-15 Gauntlet  J/K      12 km
SA-17 Grizzly   G/H      50 km

ข้อควรระวัง:
• SA-10/17 มี ECCM สูง
• SA-6/11 เคลื่อนที่เร็ว''',
          tags: ['SAM', 'Threat', 'Missile'],
        ),
        ReferenceCard(
          title: 'Fighter Radar Modes',
          titleThai: 'โหมดเรดาร์เครื่องบินรบ',
          content: '''Search Modes:
━━━━━━━━━━━━━━━━━
• RWS (Range While Search)
• TWS (Track While Scan)
• VS (Velocity Search)

Track Modes:
• STT (Single Target Track)
• DTT (Dual Target Track)

Attack Modes:
• ACM (Air Combat Mode)
• Gun/Missile boresight

สัญญาณเตือน:
• Search → พื้นหลัง
• STT → กำลังถูกล็อค!''',
          tags: ['Fighter', 'Radar', 'Air'],
        ),
        ReferenceCard(
          title: 'EW Threat Priority',
          titleThai: 'ลำดับความสำคัญภัยคุกคาม',
          content: '''Priority 1 (CRITICAL):
• Fire Control Radar lock
• Missile guidance
• Active AAM seeker

Priority 2 (HIGH):
• Target Track Radar
• Fighter in attack mode
• SAM acquisition

Priority 3 (MEDIUM):
• Search Radar track
• Fighter search mode
• Early Warning

Priority 4 (LOW):
• Long-range search
• Navigation radar
• Weather radar''',
          tags: ['Threat', 'Priority', 'Warning'],
        ),
      ],
    ),
  ];

  List<ReferenceCard> get _filteredCards {
    if (_searchQuery.isEmpty) {
      return _categories.expand((c) => c.cards).toList();
    }
    final query = _searchQuery.toLowerCase();
    return _categories.expand((c) => c.cards).where((card) {
      return card.title.toLowerCase().contains(query) ||
          card.titleThai.toLowerCase().contains(query) ||
          card.content.toLowerCase().contains(query) ||
          card.tags.any((t) => t.toLowerCase().contains(query));
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length + 1, vsync: this);
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
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: const Text('EW Quick Reference'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
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
                        hintText: 'ค้นหาสูตร, ความถี่, เทคนิค...',
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  // Category Tabs
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: isDark ? AppColors.primary : AppColorsLight.primary,
                    labelColor: isDark ? AppColors.primary : AppColorsLight.primary,
                    unselectedLabelColor: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    tabs: [
                      const Tab(text: 'ทั้งหมด'),
                      ..._categories.map((c) => Tab(
                            icon: Icon(c.icon, size: 18),
                            text: c.name,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // All cards tab
              _buildCardList(_filteredCards, isDark),
              // Category tabs
              ..._categories.map((category) {
                final cards = _searchQuery.isEmpty
                    ? category.cards
                    : category.cards.where((card) {
                        final query = _searchQuery.toLowerCase();
                        return card.title.toLowerCase().contains(query) ||
                            card.titleThai.toLowerCase().contains(query) ||
                            card.content.toLowerCase().contains(query) ||
                            card.tags.any((t) => t.toLowerCase().contains(query));
                      }).toList();
                return _buildCardList(cards, isDark, category.color);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardList(List<ReferenceCard> cards, bool isDark, [Color? categoryColor]) {
    if (cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่พบข้อมูลที่ค้นหา',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildReferenceCard(card, isDark, categoryColor),
        );
      },
    );
  }

  Widget _buildReferenceCard(ReferenceCard card, bool isDark, [Color? categoryColor]) {
    final color = categoryColor ?? _getCategoryColor(card);

    return GestureDetector(
      onTap: () => _showCardDetail(card, isDark, color),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? color.withAlpha(60) : color.withAlpha(100),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCardIcon(card),
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: TextStyle(
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        card.titleThai,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: card.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetail(ReferenceCard card, bool isDark, Color color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surface : AppColorsLight.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.border : AppColorsLight.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withAlpha(30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_getCardIcon(card), color: color, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.title,
                                style: TextStyle(
                                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                card.titleThai,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceLight
                                  : AppColorsLight.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SelectableText(
                              card.content,
                              style: TextStyle(
                                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                                fontSize: 14,
                                height: 1.6,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: card.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: color.withAlpha(20),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: color.withAlpha(50)),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(ReferenceCard card) {
    for (final category in _categories) {
      if (category.cards.contains(card)) {
        return category.color;
      }
    }
    return AppColors.primary;
  }

  IconData _getCardIcon(ReferenceCard card) {
    if (card.tags.contains('Formula') || card.tags.contains('Basic')) {
      return Icons.functions;
    } else if (card.tags.contains('Frequency') || card.tags.contains('Bands')) {
      return Icons.waves;
    } else if (card.tags.contains('Jamming') || card.tags.contains('ECM')) {
      return Icons.flash_on;
    } else if (card.tags.contains('Radar') || card.tags.contains('ESM')) {
      return Icons.radar;
    } else if (card.tags.contains('Conversion')) {
      return Icons.swap_horiz;
    } else if (card.tags.contains('Threat') || card.tags.contains('SAM')) {
      return Icons.warning;
    } else if (card.tags.contains('GPS') || card.tags.contains('Navigation')) {
      return Icons.gps_fixed;
    } else if (card.tags.contains('Drone')) {
      return Icons.flight;
    }
    return Icons.description;
  }
}

// Data Classes
class ReferenceCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<ReferenceCard> cards;

  const ReferenceCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.cards,
  });
}

class ReferenceCard {
  final String title;
  final String titleThai;
  final String content;
  final List<String> tags;

  const ReferenceCard({
    required this.title,
    required this.titleThai,
    required this.content,
    required this.tags,
  });
}
