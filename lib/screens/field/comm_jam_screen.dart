import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../app/constants.dart';

class CommJamScreen extends StatefulWidget {
  const CommJamScreen({super.key});

  @override
  State<CommJamScreen> createState() => _CommJamScreenState();
}

class _CommJamScreenState extends State<CommJamScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  int _currentStep = 0;

  final List<EmergencyStep> _immediateSteps = [
    EmergencyStep(
      number: 1,
      title: 'ยืนยันว่าถูก Jam',
      description: 'ตรวจสอบว่าเป็น Jamming จริงหรือปัญหาอุปกรณ์',
      icon: Icons.fact_check,
      color: const Color(0xFFFF5252),
      details: [
        'ได้ยินเสียง Noise/Static ผิดปกติ',
        'สัญญาณแรงแต่รับ/ส่งไม่ได้',
        'ลองหลายความถี่แล้วมีปัญหาเหมือนกัน',
        'อุปกรณ์หลายเครื่องมีปัญหาพร้อมกัน',
      ],
    ),
    EmergencyStep(
      number: 2,
      title: 'ใช้ PACE Plan',
      description: 'เปลี่ยนไปใช้การสื่อสารสำรอง',
      icon: Icons.swap_horiz,
      color: const Color(0xFFFF9800),
      details: [
        'P - Primary: ความถี่หลัก (ถูก Jam)',
        'A - Alternate: ความถี่สำรอง',
        'C - Contingency: วิธีอื่น (โทรศัพท์/ผู้ส่งสาร)',
        'E - Emergency: สัญญาณมือ/พลุสัญญาณ',
      ],
    ),
    EmergencyStep(
      number: 3,
      title: 'เปิดใช้ EPM',
      description: 'Electronic Protective Measures',
      icon: Icons.security,
      color: const Color(0xFF4CAF50),
      details: [
        'เปิด Frequency Hopping (ถ้ามี)',
        'ลดกำลังส่งเพื่อลด Detection',
        'เปลี่ยนไปใช้ย่านความถี่อื่น',
        'ใช้สายอากาศทิศทาง (Directional)',
      ],
    ),
    EmergencyStep(
      number: 4,
      title: 'เคลื่อนที่ออกจากพื้นที่ Jam',
      description: 'หาตำแหน่งที่สัญญาณดีขึ้น',
      icon: Icons.directions_run,
      color: const Color(0xFF2196F3),
      details: [
        'เคลื่อนที่ไปจุดสูง/โล่ง',
        'หลบสิ่งกีดขวาง (ภูเขา/อาคาร)',
        'ออกจากรัศมี Jammer',
        'รักษาความปลอดภัยขณะเคลื่อนที่',
      ],
    ),
    EmergencyStep(
      number: 5,
      title: 'รายงานและดำเนินการ',
      description: 'แจ้ง ผบ.หน่วย เมื่อสื่อสารได้',
      icon: Icons.campaign,
      color: const Color(0xFF9C27B0),
      details: [
        'รายงาน: พิกัด, เวลา, ความถี่ที่ถูก Jam',
        'ทิศทางที่คาดว่าเป็นแหล่ง Jam',
        'ความรุนแรง (บางส่วน/ทั้งหมด)',
        'ปฏิบัติตามคำสั่ง ผบ.หน่วย',
      ],
    ),
  ];

  final List<FrequencyBand> _frequencyBands = [
    FrequencyBand('HF', '3-30 MHz', 'ระยะไกล', const Color(0xFF9C27B0), 0.3),
    FrequencyBand('VHF', '30-300 MHz', 'ทั่วไป', const Color(0xFF2196F3), 0.6),
    FrequencyBand('UHF', '300 MHz-3 GHz', 'ยุทธวิธี', const Color(0xFF4CAF50), 0.8),
    FrequencyBand('SHF', '3-30 GHz', 'ดาวเทียม', const Color(0xFFFF9800), 0.4),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.warning,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.signal_wifi_off, size: 24, color: Colors.black87),
            SizedBox(width: 8),
            Text(
              'COMM JAMMING',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWarningHeader(),
            const SizedBox(height: 20),
            _buildSignalVisualization(),
            const SizedBox(height: 24),
            _buildImmediateActions(),
            const SizedBox(height: 24),
            _buildPacePlan(),
            const SizedBox(height: 24),
            _buildEpmTechniques(),
            const SizedBox(height: 24),
            _buildJammingTypes(),
            const SizedBox(height: 24),
            _buildFrequencyGuide(),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.warning.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                AppColors.warning.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning, width: 2),
          ),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.0 + _pulseController.value * 0.15,
                child: const Icon(Icons.wifi_off, color: AppColors.warning, size: 40),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMMUNICATIONS JAMMED',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'การสื่อสารถูกรบกวน - ใช้ PACE Plan',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignalVisualization() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B263B)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.waves, color: Color(0xFFFF9800), size: 24),
              SizedBox(width: 8),
              Text(
                'RF SPECTRUM MONITOR',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: SpectrumPainter(
                    progress: _waveController.value,
                    isJammed: true,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChannelStatus('CH1', 'JAMMED', AppColors.danger),
              _buildChannelStatus('CH2', 'JAMMED', AppColors.danger),
              _buildChannelStatus('ALT', 'CLEAR', AppColors.success),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelStatus(String channel, String status, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
          child: Text(
            channel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildImmediateActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.flash_on, color: AppColors.danger, size: 24),
            SizedBox(width: 8),
            Text(
              'IMMEDIATE ACTIONS',
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._immediateSteps.asMap().entries.map((entry) {
          final step = entry.value;
          final isActive = entry.key <= _currentStep;
          return _buildStepCard(step, isActive, () {
            setState(() => _currentStep = entry.key);
          });
        }),
      ],
    );
  }

  Widget _buildStepCard(EmergencyStep step, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? step.color.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? step.color : AppColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: step.color.withValues(alpha: isActive ? 0.3 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${step.number}',
                      style: TextStyle(
                        color: step.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(step.icon, color: step.color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          color: isActive ? step.color : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        step.description,
                        style: TextStyle(
                          color: isActive ? step.color.withValues(alpha: 0.8) : AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isActive ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isActive ? step.color : AppColors.textMuted,
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              ...step.details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_right, color: step.color, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPacePlan() {
    final paceItems = [
      PaceItem('P', 'PRIMARY', 'ความถี่หลักที่กำหนด', Icons.looks_one, const Color(0xFF2196F3)),
      PaceItem('A', 'ALTERNATE', 'ความถี่สำรอง', Icons.looks_two, const Color(0xFF4CAF50)),
      PaceItem('C', 'CONTINGENCY', 'วิธีอื่น (โทรศัพท์/ผู้ส่งสาร)', Icons.looks_3, const Color(0xFFFF9800)),
      PaceItem('E', 'EMERGENCY', 'สัญญาณมือ/พลุ/Visual', Icons.looks_4, const Color(0xFFFF5252)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A237E).withValues(alpha: 0.4),
            const Color(0xFF1A237E).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3949AB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.swap_vert, color: Color(0xFF7986CB), size: 24),
              SizedBox(width: 8),
              Text(
                'PACE PLAN',
                style: TextStyle(
                  color: Color(0xFF7986CB),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'แผนการสื่อสารสำรอง - เปลี่ยนตามลำดับเมื่อถูก Jam',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ...paceItems.map((item) => _buildPaceItem(item)),
        ],
      ),
    );
  }

  Widget _buildPaceItem(PaceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: item.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.letter,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: item.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  item.description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(item.icon, color: item.color, size: 24),
        ],
      ),
    );
  }

  Widget _buildEpmTechniques() {
    final techniques = [
      EpmTechnique(
        name: 'Frequency Hopping',
        description: 'กระโดดความถี่อัตโนมัติ',
        effectiveness: 'สูงมาก',
        icon: Icons.shuffle,
        color: const Color(0xFF4CAF50),
      ),
      EpmTechnique(
        name: 'Power Control',
        description: 'ลด/เพิ่มกำลังส่งตามสถานการณ์',
        effectiveness: 'ปานกลาง',
        icon: Icons.power_settings_new,
        color: const Color(0xFF2196F3),
      ),
      EpmTechnique(
        name: 'Directional Antenna',
        description: 'ใช้สายอากาศทิศทาง',
        effectiveness: 'สูง',
        icon: Icons.cell_tower,
        color: const Color(0xFFFF9800),
      ),
      EpmTechnique(
        name: 'Frequency Change',
        description: 'เปลี่ยนย่านความถี่',
        effectiveness: 'ปานกลาง',
        icon: Icons.compare_arrows,
        color: const Color(0xFF9C27B0),
      ),
    ];

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
              Icon(Icons.shield, color: Color(0xFF4CAF50), size: 24),
              SizedBox(width: 8),
              Text(
                'EPM TECHNIQUES',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Electronic Protective Measures - มาตรการป้องกันอิเล็กทรอนิกส์',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: techniques.map((t) => _buildEpmCard(t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEpmCard(EpmTechnique technique) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: technique.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: technique.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(technique.icon, color: technique.color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  technique.name,
                  style: TextStyle(
                    color: technique.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Text(
                  technique.description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJammingTypes() {
    final types = [
      JammingType(
        name: 'Spot Jamming',
        description: 'รบกวนความถี่เดียว',
        counter: 'เปลี่ยนความถี่',
        icon: Icons.gps_fixed,
        color: const Color(0xFFFF5252),
      ),
      JammingType(
        name: 'Barrage Jamming',
        description: 'รบกวนย่านกว้าง',
        counter: 'เปลี่ยนย่านความถี่',
        icon: Icons.width_wide,
        color: const Color(0xFFFF9800),
      ),
      JammingType(
        name: 'Sweep Jamming',
        description: 'กวาดความถี่',
        counter: 'Frequency Hopping',
        icon: Icons.swap_horiz,
        color: const Color(0xFF9C27B0),
      ),
    ];

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
              Icon(Icons.warning, color: Color(0xFFFF5252), size: 24),
              SizedBox(width: 8),
              Text(
                'JAMMING TYPES',
                style: TextStyle(
                  color: Color(0xFFFF5252),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...types.map((type) => _buildJammingTypeCard(type)),
        ],
      ),
    );
  }

  Widget _buildJammingTypeCard(JammingType type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: type.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(type.icon, color: type.color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name,
                  style: TextStyle(
                    color: type.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  type.description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.shield, color: AppColors.success, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'แก้: ${type.counter}',
                      style: const TextStyle(color: AppColors.success, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyGuide() {
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
              Icon(Icons.radio, color: Color(0xFF00BCD4), size: 24),
              SizedBox(width: 8),
              Text(
                'FREQUENCY BANDS',
                style: TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._frequencyBands.map((band) => _buildFrequencyBar(band)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'HF สะท้อนบรรยากาศได้ไกล แต่คุณภาพต่ำ\nVHF/UHF คุณภาพดี แต่ต้อง Line-of-Sight',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyBar(FrequencyBand band) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: Text(
              band.name,
              style: TextStyle(
                color: band.color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: band.usage,
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [band.color, band.color.withValues(alpha: 0.5)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${band.range} - ${band.purpose}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter
class SpectrumPainter extends CustomPainter {
  final double progress;
  final bool isJammed;

  SpectrumPainter({required this.progress, required this.isJammed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    // Draw spectrum bars
    final barWidth = size.width / 50;
    for (int i = 0; i < 50; i++) {
      final x = i * barWidth;
      final normalHeight = random.nextDouble() * 0.4 + 0.1;

      // Add jamming noise in certain frequencies
      double height = normalHeight;
      if (isJammed && i > 15 && i < 35) {
        height = 0.7 + random.nextDouble() * 0.3 + math.sin(progress * 2 * math.pi + i * 0.5) * 0.2;
      }

      final color = isJammed && i > 15 && i < 35
          ? const Color(0xFFFF5252)
          : const Color(0xFF4CAF50).withValues(alpha: 0.5 + normalHeight * 0.5);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height * (1 - height),
          barWidth - 1,
          size.height * height,
        ),
        paint,
      );
    }

    // Draw noise line if jammed
    if (isJammed) {
      final noisePaint = Paint()
        ..color = const Color(0xFFFF5252).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path();
      path.moveTo(0, size.height / 2);

      for (double x = 0; x < size.width; x += 2) {
        final y = size.height / 2 +
            math.sin(x * 0.1 + progress * 10) * 20 +
            random.nextDouble() * 10 - 5;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, noisePaint);
    }
  }

  @override
  bool shouldRepaint(SpectrumPainter oldDelegate) =>
      progress != oldDelegate.progress || isJammed != oldDelegate.isJammed;
}

// Data classes
class EmergencyStep {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> details;

  EmergencyStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.details,
  });
}

class PaceItem {
  final String letter;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  PaceItem(this.letter, this.name, this.description, this.icon, this.color);
}

class EpmTechnique {
  final String name;
  final String description;
  final String effectiveness;
  final IconData icon;
  final Color color;

  EpmTechnique({
    required this.name,
    required this.description,
    required this.effectiveness,
    required this.icon,
    required this.color,
  });
}

class JammingType {
  final String name;
  final String description;
  final String counter;
  final IconData icon;
  final Color color;

  JammingType({
    required this.name,
    required this.description,
    required this.counter,
    required this.icon,
    required this.color,
  });
}

class FrequencyBand {
  final String name;
  final String range;
  final String purpose;
  final Color color;
  final double usage;

  FrequencyBand(this.name, this.range, this.purpose, this.color, this.usage);
}
