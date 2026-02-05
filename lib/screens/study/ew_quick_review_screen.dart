import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../data/ew_study_data.dart';

/// หน้าจอสรุปเนื้อหา EW สำหรับทบทวนก่อนสอบ
class EWQuickReviewScreen extends StatefulWidget {
  const EWQuickReviewScreen({super.key});

  @override
  State<EWQuickReviewScreen> createState() => _EWQuickReviewScreenState();
}

class _EWQuickReviewScreenState extends State<EWQuickReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_ReviewTab> _tabs = [
    _ReviewTab('หลักการ', Icons.lightbulb),
    _ReviewTab('3 เสาหลัก', Icons.account_tree),
    _ReviewTab('ภัยคุกคาม', Icons.warning),
    _ReviewTab('GPS', Icons.gps_fixed),
    _ReviewTab('การอยู่รอด', Icons.shield),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('สรุปก่อนสอบ'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: _tabs.map((tab) => Tab(
            icon: Icon(tab.icon, size: 20),
            text: tab.label,
          )).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrinciplesTab(),
          _buildTriadTab(),
          _buildThreatsTab(),
          _buildGPSTab(),
          _buildSurvivalTab(),
        ],
      ),
    );
  }

  // Tab 1: หลักการสำคัญ
  Widget _buildPrinciplesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📌 นิยาม EW', Colors.blue),
          _buildInfoCard(
            'Electronic Warfare (EW)',
            'การใช้พลังงานแม่เหล็กไฟฟ้า (คลื่นวิทยุ/เรดาร์/เลเซอร์) เพื่อ:\n'
            '• โจมตี (Attack) - ให้ข้าศึกใช้ไม่ได้\n'
            '• ป้องกัน (Protect) - ให้เราใช้ได้ตลอดเวลา\n'
            '• สนับสนุน (Support) - หาว่าข้าศึกอยู่ที่ไหน',
            Colors.blue,
          ),

          const SizedBox(height: 20),
          _buildSectionHeader('🎯 3 ภารกิจหลัก', Colors.amber),
          ...EWKeyConcepts.ewMissions.map((mission) => _buildMissionCard(mission)),

          const SizedBox(height: 20),
          _buildSectionHeader('⚡ ทำไม EW ถึงสำคัญ', Colors.red),
          _buildQuoteCard(
            '"No Spectrum = No Fight"',
            'ใครควบคุมสเปกตรัมได้ คนนั้นชนะ',
          ),
          const SizedBox(height: 12),
          ...EWKeyConcepts.whyEWMatters.map((item) => _buildImpactCard(item)),
        ],
      ),
    );
  }

  // Tab 2: 3 เสาหลัก (ESM, ECM, ECCM)
  Widget _buildTriadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ESM
          _buildSectionHeader('👂 ESM (Electronic Support Measures)', Colors.amber),
          _buildInfoCard(
            'ภารกิจ: ค้นหา ดักรับ ระบุ บันทึก วิเคราะห์',
            'หน้าที่หลัก: รู้ว่าข้าศึกคือใคร อยู่ที่ไหน กำลังคุยอะไรกัน',
            Colors.amber,
          ),
          const SizedBox(height: 12),
          _buildStepsCard('5 ขั้นตอน ESM', EWKeyConcepts.esmSteps, Colors.amber),

          const SizedBox(height: 24),

          // ECM
          _buildSectionHeader('⚡ ECM (Electronic Countermeasures)', Colors.red),
          _buildInfoCard(
            'ภารกิจ: รบกวน หลอกลวง ทำลาย',
            'หน้าที่หลัก: ทำให้จอเรดาร์ข้าศึกบอด หรือวิทยุข้าศึกมีแต่เสียงซ่า',
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildJammingTypesCard(),

          const SizedBox(height: 24),

          // ECCM
          _buildSectionHeader('🛡️ ECCM (Electronic Counter-Countermeasures)', Colors.green),
          _buildInfoCard(
            'ภารกิจ: ป้องกันฝ่ายเราจากการถูกรบกวน',
            'เทคนิค: กระโดดความถี่ (FHSS), ลดกำลังส่ง, ใช้รหัสลับ',
            Colors.green,
          ),
          const SizedBox(height: 12),
          ...EWKeyConcepts.eccmTechniques.map((t) => _buildTechniqueCard(t)),
        ],
      ),
    );
  }

  // Tab 3: ภัยคุกคาม (Russian EW Systems)
  Widget _buildThreatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('🇷🇺 ระบบ EW ของรัสเซีย', Colors.red),
          const Text(
            'ระบบ EW ที่ต้องรู้จักสำหรับการปฏิบัติการ',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),

          ...RussianEWSystems.threatCards.map((card) => _buildThreatCard(card)),

          const SizedBox(height: 24),
          _buildSectionHeader('📊 สถิติสงครามยูเครน', Colors.orange),
          _buildStatCard(
            'โดรนสูญเสียต่อเดือน',
            '~10,000 ลำ',
            'จากระบบ EW ของรัสเซีย (RUSI Report)',
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildLessonsCard(),
        ],
      ),
    );
  }

  // Tab 4: GPS Warfare
  Widget _buildGPSTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('📡 GPS Warfare', Colors.teal),

          // Jamming vs Spoofing comparison
          Row(
            children: [
              Expanded(child: _buildGPSCompareCard('Jamming', GPSWarfareData.jamming, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildGPSCompareCard('Spoofing', GPSWarfareData.spoofing, Colors.orange)),
            ],
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('🔍 วิธีตรวจจับ', Colors.blue),

          _buildDetectionCard(
            'GPS Jamming',
            GPSWarfareData.jamming['indicators'] as List<String>,
            Colors.red,
          ),
          const SizedBox(height: 12),
          _buildDetectionCard(
            'GPS Spoofing',
            GPSWarfareData.spoofing['indicators'] as List<String>,
            Colors.orange,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('✅ สิ่งที่ต้องจำ', Colors.green),
          _buildMemoryCard([
            'GPS L1 (พลเรือน) = 1575.42 MHz',
            'Jamming = ไม่มีสัญญาณ (รู้ทันที)',
            'Spoofing = มีสัญญาณแต่ผิด (อันตรายกว่า)',
            'ใช้เข็มทิศ/แผนที่กระดาษเป็น Backup เสมอ',
          ]),
        ],
      ),
    );
  }

  // Tab 5: การอยู่รอด
  Widget _buildSurvivalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuoteCard(
            '"Discipline is survival. Silence is your shield."',
            'วินัยคือการอยู่รอด ความเงียบคือโล่ป้องกัน',
          ),

          const SizedBox(height: 20),
          _buildSectionHeader('📋 กฎการอยู่รอดในสนาม EW', Colors.green),

          ...SurvivalRules.rules.map((rule) => _buildSurvivalRuleCard(rule)),

          const SizedBox(height: 24),
          _buildSectionHeader('⚠️ Kill Chain', Colors.red),
          _buildKillChainCard(),

          const SizedBox(height: 24),
          _buildWarningCard(
            '📱 คำเตือน: ห้ามใช้มือถือส่วนตัวในพื้นที่ปฏิบัติการ!',
            [
              'GPS ในมือถือเปิดตลอด',
              'สัญญาณมือถือถูกดักได้',
              'ข้าศึกหาตำแหน่งได้ภายใน 3 นาที',
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(String quote, String translation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(30),
            AppColors.primary.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Column(
        children: [
          Text(
            quote,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            translation,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(mission['color'] as int).withAlpha(100)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(mission['color'] as int).withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              mission['icon'] as IconData,
              color: Color(mission['color'] as int),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission['name'] as String,
                  style: TextStyle(
                    color: Color(mission['color'] as int),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  mission['description'] as String,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item['impact'] == 'สูงมาก' ? Colors.red.withAlpha(30) : Colors.orange.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item['impact'] as String,
              style: TextStyle(
                color: item['impact'] == 'สูงมาก' ? Colors.red : Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item['description'] as String,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard(String title, List<Map<String, dynamic>> steps, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...steps.map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${step['step']}',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
                        step['name'] as String,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        step['description'] as String,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildJammingTypesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ประเภท Jamming',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...EWKeyConcepts.jammingTypes.map((type) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.flash_on, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${type['name']}: ',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: type['description'],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard(Map<String, dynamic> technique) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            technique['name'] as String,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            technique['description'] as String,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatCard(ThreatCard card) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: card.threatColor.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.system,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: card.threatColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  card.threatLevel,
                  style: TextStyle(
                    color: card.threatColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.mission,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildChip('ระยะ: ${card.range}', Colors.blue),
              _buildChip(card.mobility, Colors.green),
              ...card.targets.map((t) => _buildChip(t, Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'บทเรียนจากสงครามยูเครน',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...UkraineDroneWarData.lessons.map((lesson) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.arrow_right, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    lesson,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildGPSCompareCard(String title, Map<String, dynamic> data, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data['effect'] as String,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data['description'] as String,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ตรวจจับ: ${data['detection']}',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionCard(String title, List<String> indicators, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สัญญาณบ่งชี้ $title',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...indicators.map((i) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(Icons.warning, size: 14, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    i,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMemoryCard(List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withAlpha(50)),
      ),
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSurvivalRuleCard(Map<String, dynamic> rule) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  rule['icon'] as IconData,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rule['name'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (rule.containsKey('practices'))
            ...(rule['practices'] as List<String>).map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.green)),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildKillChainCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ห่วงโซ่การทำลาย (Kill Chain)',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: KillChainData.steps.map((step) => Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step['icon'] as IconData,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${step['step']}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )).toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            'Detected → Located → Destroyed',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(String title, List<String> reasons) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...reasons.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.dangerous, size: 14, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    r,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _ReviewTab {
  final String label;
  final IconData icon;

  _ReviewTab(this.label, this.icon);
}
