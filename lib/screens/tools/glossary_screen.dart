import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/bookmark_button.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';

  final List<String> _categories = [
    'ทั้งหมด',
    'EW พื้นฐาน',
    'ESM/ELINT',
    'ECM/Jamming',
    'ECCM/EP',
    'Radar',
    'Communications',
    'Anti-Drone/C-UAS',
    'Cyber EW',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        final filteredTerms = _glossaryTerms.where((term) {
          final matchesSearch = term.term.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              term.definition.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              term.thaiTerm.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCategory = _selectedCategory == 'ทั้งหมด' || term.category == _selectedCategory;
          return matchesSearch && matchesCategory;
        }).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'EW GLOSSARY',
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
                    hintText: 'ค้นหาคำศัพท์...',
                    hintStyle: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    ),
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
              // Category Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
                            fontSize: 12,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = category),
                        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
                        selectedColor: AppColors.primary,
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.border : AppColorsLight.border),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Terms Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'พบ ${filteredTerms.length} คำ',
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Terms List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredTerms.length,
                  itemBuilder: (context, index) {
                    final term = filteredTerms[index];
                    return _buildTermCard(term, isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTermCard(_GlossaryTerm term, bool isDark) {
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getCategoryColor(term.category).withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              term.term.substring(0, 1),
              style: TextStyle(
                color: _getCategoryColor(term.category),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          term.term,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          term.thaiTerm,
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookmarkButton(
              itemId: 'glossary_${term.term.replaceAll(' ', '_').toLowerCase()}',
              type: BookmarkType.glossaryTerm,
              title: term.term,
              subtitle: term.thaiTerm,
              category: term.category,
              size: 22,
              activeColor: _getCategoryColor(term.category),
            ),
            Icon(
              Icons.expand_more,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.definition,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(term.category).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    term.category,
                    style: TextStyle(
                      color: _getCategoryColor(term.category),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (term.relatedTerms.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'คำที่เกี่ยวข้อง:',
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: term.relatedTerms.map((related) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.background : AppColorsLight.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          related,
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'EW พื้นฐาน':
        return Colors.blue;
      case 'ESM/ELINT':
        return Colors.purple;
      case 'ECM/Jamming':
        return Colors.red;
      case 'ECCM/EP':
        return Colors.green;
      case 'Radar':
        return Colors.orange;
      case 'Communications':
        return Colors.cyan;
      case 'Cyber EW':
        return Colors.pink;
      case 'Anti-Drone/C-UAS':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  final List<_GlossaryTerm> _glossaryTerms = [
    // EW พื้นฐาน
    _GlossaryTerm(
      term: 'Electronic Warfare (EW)',
      thaiTerm: 'สงครามอิเล็กทรอนิกส์',
      definition: 'การปฏิบัติการทางทหารที่ใช้พลังงานแม่เหล็กไฟฟ้าและพลังงานนำวิถีเพื่อควบคุมสเปกตรัมแม่เหล็กไฟฟ้า หรือโจมตีศัตรู ประกอบด้วย 3 ส่วนหลัก: EA, ES, EP',
      category: 'EW พื้นฐาน',
      relatedTerms: ['EA', 'ES', 'EP', 'EMSO'],
    ),
    _GlossaryTerm(
      term: 'Electronic Attack (EA)',
      thaiTerm: 'การโจมตีอิเล็กทรอนิกส์',
      definition: 'การใช้พลังงานแม่เหล็กไฟฟ้า พลังงานนำวิถี หรืออาวุธต่อต้านรังสี เพื่อโจมตีบุคลากร สิ่งอุปกรณ์ หรืออุปกรณ์ของศัตรู โดยมีเป้าหมายเพื่อทำลาย ทำให้เป็นกลาง หรือลดขีดความสามารถในการรบ',
      category: 'EW พื้นฐาน',
      relatedTerms: ['Jamming', 'SEAD', 'ARM'],
    ),
    _GlossaryTerm(
      term: 'Electronic Support (ES)',
      thaiTerm: 'การสนับสนุนอิเล็กทรอนิกส์',
      definition: 'การค้นหา ดักรับ ระบุตำแหน่ง บันทึก และวิเคราะห์แหล่งกำเนิดพลังงานแม่เหล็กไฟฟ้าที่แผ่ออกมา เพื่อสนับสนุนการวางแผนและปฏิบัติการในอนาคต',
      category: 'EW พื้นฐาน',
      relatedTerms: ['ESM', 'ELINT', 'SIGINT'],
    ),
    _GlossaryTerm(
      term: 'Electronic Protection (EP)',
      thaiTerm: 'การป้องกันอิเล็กทรอนิกส์',
      definition: 'การดำเนินการเพื่อป้องกันบุคลากร สิ่งอุปกรณ์ และอุปกรณ์จากผลกระทบของ EW ทั้งฝ่ายเราและฝ่ายศัตรู ที่อาจทำให้ขีดความสามารถในการรบลดลง',
      category: 'EW พื้นฐาน',
      relatedTerms: ['ECCM', 'Hardening', 'EMCON'],
    ),
    _GlossaryTerm(
      term: 'Electromagnetic Spectrum (EMS)',
      thaiTerm: 'สเปกตรัมแม่เหล็กไฟฟ้า',
      definition: 'ช่วงความถี่ทั้งหมดของคลื่นแม่เหล็กไฟฟ้า ตั้งแต่คลื่นวิทยุ ไมโครเวฟ อินฟราเรด แสงที่ตามองเห็น อัลตราไวโอเลต รังสีเอกซ์ จนถึงรังสีแกมมา',
      category: 'EW พื้นฐาน',
      relatedTerms: ['RF', 'Frequency', 'Wavelength'],
    ),
    _GlossaryTerm(
      term: 'Electromagnetic Spectrum Operations (EMSO)',
      thaiTerm: 'การปฏิบัติการสเปกตรัมแม่เหล็กไฟฟ้า',
      definition: 'การประสานงานและบูรณาการระหว่าง EW, Spectrum Management และ SIGINT เพื่อให้ได้เปรียบในการใช้สเปกตรัมแม่เหล็กไฟฟ้า',
      category: 'EW พื้นฐาน',
      relatedTerms: ['EW', 'EMS', 'CEMA'],
    ),
    _GlossaryTerm(
      term: 'Radio Frequency (RF)',
      thaiTerm: 'คลื่นความถี่วิทยุ',
      definition: 'ย่านความถี่ของสเปกตรัมแม่เหล็กไฟฟ้าตั้งแต่ 3 kHz ถึง 300 GHz ใช้ในการสื่อสาร เรดาร์ และระบบ EW ต่างๆ',
      category: 'EW พื้นฐาน',
      relatedTerms: ['EMS', 'Microwave', 'VHF', 'UHF'],
    ),
    _GlossaryTerm(
      term: 'Decibel (dB)',
      thaiTerm: 'เดซิเบล',
      definition: 'หน่วยวัดอัตราส่วนแบบลอการิทึม ใช้วัดกำลังสัญญาณ ความแรงสนาม และอัตราขยาย 3 dB = เพิ่ม 2 เท่า, 10 dB = เพิ่ม 10 เท่า',
      category: 'EW พื้นฐาน',
      relatedTerms: ['dBm', 'dBi', 'dBW', 'Signal Strength'],
    ),
    _GlossaryTerm(
      term: 'Signal-to-Noise Ratio (SNR)',
      thaiTerm: 'อัตราส่วนสัญญาณต่อสัญญาณรบกวน',
      definition: 'อัตราส่วนระหว่างกำลังสัญญาณที่ต้องการกับกำลังสัญญาณรบกวนพื้นหลัง SNR สูงหมายถึงสัญญาณชัดเจน',
      category: 'EW พื้นฐาน',
      relatedTerms: ['J/S Ratio', 'Noise Floor', 'Sensitivity'],
    ),
    _GlossaryTerm(
      term: 'Effective Radiated Power (ERP)',
      thaiTerm: 'กำลังแผ่รังสีประสิทธิผล',
      definition: 'กำลังส่งของเครื่องส่งคูณกับอัตราขยายของเสาอากาศ เป็นตัววัดความสามารถในการส่งสัญญาณไปยังทิศทางที่ต้องการ',
      category: 'EW พื้นฐาน',
      relatedTerms: ['EIRP', 'Antenna Gain', 'Transmit Power'],
    ),
    _GlossaryTerm(
      term: 'Bandwidth',
      thaiTerm: 'แบนด์วิดท์',
      definition: 'ช่วงความถี่ที่สัญญาณครอบคลุม วัดเป็น Hz, kHz หรือ MHz มีผลต่อปริมาณข้อมูลที่ส่งได้และความละเอียดของระบบ',
      category: 'EW พื้นฐาน',
      relatedTerms: ['Frequency', 'Data Rate', 'Resolution'],
    ),

    // ESM/ELINT
    _GlossaryTerm(
      term: 'Electronic Support Measures (ESM)',
      thaiTerm: 'มาตรการสนับสนุนอิเล็กทรอนิกส์',
      definition: 'ระบบและกระบวนการในการตรวจจับ ดักรับ และวิเคราะห์สัญญาณแม่เหล็กไฟฟ้าของศัตรูแบบ passive โดยไม่แผ่คลื่นออกไป',
      category: 'ESM/ELINT',
      relatedTerms: ['RWR', 'ELINT', 'COMINT'],
    ),
    _GlossaryTerm(
      term: 'Electronic Intelligence (ELINT)',
      thaiTerm: 'ข่าวกรองอิเล็กทรอนิกส์',
      definition: 'ข่าวกรองทางเทคนิคที่ได้จากการรวบรวมและประมวลผลข้อมูลจากการแผ่คลื่นแม่เหล็กไฟฟ้าที่ไม่ใช่การสื่อสาร โดยเฉพาะระบบเรดาร์',
      category: 'ESM/ELINT',
      relatedTerms: ['SIGINT', 'COMINT', 'FISINT'],
    ),
    _GlossaryTerm(
      term: 'Radar Warning Receiver (RWR)',
      thaiTerm: 'เครื่องเตือนเรดาร์',
      definition: 'อุปกรณ์ที่ติดตั้งบนอากาศยานหรือยานพาหนะเพื่อตรวจจับและเตือนลูกเรือเมื่อถูกเรดาร์ของศัตรูจับ แสดงประเภทภัยคุกคามและทิศทาง',
      category: 'ESM/ELINT',
      relatedTerms: ['ESM', 'Threat Library', 'SPO'],
    ),
    _GlossaryTerm(
      term: 'Direction Finding (DF)',
      thaiTerm: 'การหาทิศทาง',
      definition: 'เทคนิคการหาทิศทางของแหล่งกำเนิดสัญญาณแม่เหล็กไฟฟ้าโดยใช้เสาอากาศแบบทิศทางหรืออาร์เรย์',
      category: 'ESM/ELINT',
      relatedTerms: ['AOA', 'Triangulation', 'Geolocation'],
    ),
    _GlossaryTerm(
      term: 'Communications Intelligence (COMINT)',
      thaiTerm: 'ข่าวกรองการสื่อสาร',
      definition: 'ข่าวกรองที่ได้จากการดักรับและวิเคราะห์การสื่อสารของศัตรู รวมถึงเนื้อหาข้อความและข้อมูลการจราจร',
      category: 'ESM/ELINT',
      relatedTerms: ['SIGINT', 'ELINT', 'Traffic Analysis'],
    ),
    _GlossaryTerm(
      term: 'Signals Intelligence (SIGINT)',
      thaiTerm: 'ข่าวกรองสัญญาณ',
      definition: 'ข่าวกรองที่ได้จากการดักรับสัญญาณแม่เหล็กไฟฟ้า ครอบคลุมทั้ง COMINT (การสื่อสาร) และ ELINT (อิเล็กทรอนิกส์ที่ไม่ใช่การสื่อสาร)',
      category: 'ESM/ELINT',
      relatedTerms: ['COMINT', 'ELINT', 'FISINT'],
    ),
    _GlossaryTerm(
      term: 'Angle of Arrival (AOA)',
      thaiTerm: 'มุมตกกระทบ',
      definition: 'ทิศทางที่สัญญาณแม่เหล็กไฟฟ้ามาถึงเครื่องรับ ใช้ในการหาตำแหน่งแหล่งกำเนิดสัญญาณร่วมกับเทคนิค DF',
      category: 'ESM/ELINT',
      relatedTerms: ['DF', 'Triangulation', 'Bearing'],
    ),
    _GlossaryTerm(
      term: 'Electronic Order of Battle (EOB)',
      thaiTerm: 'ลำดับการรบอิเล็กทรอนิกส์',
      definition: 'ฐานข้อมูลที่รวบรวมข้อมูลเกี่ยวกับระบบ EW และเรดาร์ของศัตรู รวมถึงตำแหน่ง ประเภท และลักษณะทางเทคนิค',
      category: 'ESM/ELINT',
      relatedTerms: ['Threat Library', 'ELINT', 'Emitter'],
    ),
    _GlossaryTerm(
      term: 'Threat Library',
      thaiTerm: 'คลังข้อมูลภัยคุกคาม',
      definition: 'ฐานข้อมูลที่เก็บข้อมูลลักษณะเฉพาะของสัญญาณภัยคุกคาม เช่น เรดาร์ ขีปนาวุธ ใช้ในการระบุตัวตนและจัดประเภทภัยคุกคาม',
      category: 'ESM/ELINT',
      relatedTerms: ['EOB', 'RWR', 'Emitter ID'],
    ),
    _GlossaryTerm(
      term: 'Passive Detection',
      thaiTerm: 'การตรวจจับแบบพาสซีฟ',
      definition: 'การตรวจจับสัญญาณโดยไม่แผ่คลื่นออกไป รับฟังเฉพาะสัญญาณที่มีอยู่ ทำให้ยากต่อการถูกตรวจจับกลับ',
      category: 'ESM/ELINT',
      relatedTerms: ['ESM', 'ELINT', 'Silent Operation'],
    ),
    _GlossaryTerm(
      term: 'Sensitivity',
      thaiTerm: 'ความไว',
      definition: 'ความสามารถของเครื่องรับในการตรวจจับสัญญาณอ่อน วัดเป็น dBm เครื่องรับที่มี sensitivity -90 dBm ไวกว่า -70 dBm',
      category: 'ESM/ELINT',
      relatedTerms: ['Noise Floor', 'SNR', 'MDS'],
    ),

    // ECM/Jamming
    _GlossaryTerm(
      term: 'Jamming',
      thaiTerm: 'การรบกวนสัญญาณ',
      definition: 'การแผ่พลังงานแม่เหล็กไฟฟ้าโดยเจตนาเพื่อรบกวนหรือทำลายการทำงานของระบบอิเล็กทรอนิกส์ของศัตรู เช่น เรดาร์ การสื่อสาร หรือระบบนำวิถี',
      category: 'ECM/Jamming',
      relatedTerms: ['Noise Jamming', 'Deception Jamming', 'J/S Ratio'],
    ),
    _GlossaryTerm(
      term: 'Noise Jamming',
      thaiTerm: 'การรบกวนแบบสัญญาณรบกวน',
      definition: 'การแผ่สัญญาณรบกวนแบบสุ่มหรือกึ่งสุ่มเพื่อบดบังสัญญาณเป้าหมายที่แท้จริง ทำให้เรดาร์หรือเครื่องรับไม่สามารถแยกสัญญาณได้',
      category: 'ECM/Jamming',
      relatedTerms: ['Barrage', 'Spot', 'Sweep'],
    ),
    _GlossaryTerm(
      term: 'Deception Jamming',
      thaiTerm: 'การรบกวนแบบหลอกลวง',
      definition: 'การแผ่สัญญาณที่เลียนแบบสัญญาณเป้าหมายจริงเพื่อหลอกระบบอิเล็กทรอนิกส์ของศัตรู ให้แสดงข้อมูลผิดพลาดเกี่ยวกับตำแหน่ง ความเร็ว หรือจำนวนเป้าหมาย',
      category: 'ECM/Jamming',
      relatedTerms: ['Range Gate Pull-Off', 'Velocity Gate Steal', 'False Target'],
    ),
    _GlossaryTerm(
      term: 'GPS Jamming',
      thaiTerm: 'การรบกวน GPS',
      definition: 'การแผ่สัญญาณรบกวนในย่านความถี่ GPS (L1: 1575.42 MHz, L2: 1227.60 MHz) เพื่อทำให้เครื่องรับ GPS ไม่สามารถระบุตำแหน่งได้',
      category: 'ECM/Jamming',
      relatedTerms: ['GPS Spoofing', 'GNSS', 'PNT'],
    ),
    _GlossaryTerm(
      term: 'GPS Spoofing',
      thaiTerm: 'การหลอก GPS',
      definition: 'การแผ่สัญญาณ GPS ปลอมที่แรงกว่าสัญญาณจริง เพื่อหลอกเครื่องรับให้คำนวณตำแหน่งผิดพลาด ใช้ในการหลอกล่อ UAV หรือขีปนาวุธ',
      category: 'ECM/Jamming',
      relatedTerms: ['GPS Jamming', 'Meaconing', 'Time Spoofing'],
    ),
    _GlossaryTerm(
      term: 'Drone Jammer',
      thaiTerm: 'เครื่องรบกวนโดรน',
      definition: 'อุปกรณ์ที่ออกแบบมาเพื่อรบกวนการสื่อสารระหว่างโดรนกับผู้ควบคุม และ/หรือ สัญญาณ GPS ทำให้โดรนสูญเสียการควบคุมหรือกลับฐาน',
      category: 'ECM/Jamming',
      relatedTerms: ['Counter-UAS', 'C-sUAS', 'Anti-Drone'],
    ),
    _GlossaryTerm(
      term: 'J/S Ratio (Jamming-to-Signal)',
      thaiTerm: 'อัตราส่วนการรบกวนต่อสัญญาณ',
      definition: 'อัตราส่วนระหว่างกำลังสัญญาณรบกวนกับกำลังสัญญาณเป้าหมายที่เครื่องรับ J/S > 0 dB หมายความว่าการรบกวนมีประสิทธิภาพ',
      category: 'ECM/Jamming',
      relatedTerms: ['Burn-through', 'ERP', 'Jamming'],
    ),
    _GlossaryTerm(
      term: 'Burn-through Range',
      thaiTerm: 'ระยะเจาะทะลุ',
      definition: 'ระยะที่สัญญาณเป้าหมายแรงพอที่จะเอาชนะการรบกวนและตรวจจับได้ เป็นข้อจำกัดของการรบกวนระยะไกล',
      category: 'ECM/Jamming',
      relatedTerms: ['J/S Ratio', 'ERP', 'Stand-off Jamming'],
    ),
    _GlossaryTerm(
      term: 'Stand-off Jamming (SOJ)',
      thaiTerm: 'การรบกวนระยะไกล',
      definition: 'การรบกวนจากระยะนอกเขตอาวุธของศัตรู ใช้เครื่องบิน EW หรือ UAV ที่ติดตั้งเครื่องรบกวนกำลังสูง',
      category: 'ECM/Jamming',
      relatedTerms: ['Escort Jamming', 'Self-Protection', 'EA-18G'],
    ),
    _GlossaryTerm(
      term: 'Self-Protection Jamming',
      thaiTerm: 'การรบกวนป้องกันตัวเอง',
      definition: 'การรบกวนจากอากาศยานเพื่อป้องกันตัวเองจากการถูกติดตามโดยเรดาร์หรือขีปนาวุธนำวิถี',
      category: 'ECM/Jamming',
      relatedTerms: ['SOJ', 'RWR', 'Chaff'],
    ),
    _GlossaryTerm(
      term: 'Barrage Jamming',
      thaiTerm: 'การรบกวนแบบปูพรม',
      definition: 'การแผ่สัญญาณรบกวนครอบคลุมย่านความถี่กว้าง ได้ผลกับหลายความถี่พร้อมกัน แต่กำลังต่อความถี่น้อยกว่า Spot Jamming',
      category: 'ECM/Jamming',
      relatedTerms: ['Spot Jamming', 'Sweep Jamming', 'Noise Jamming'],
    ),
    _GlossaryTerm(
      term: 'Spot Jamming',
      thaiTerm: 'การรบกวนแบบจุด',
      definition: 'การรบกวนที่มุ่งเป้าไปที่ความถี่เดียวหรือช่วงความถี่แคบ ให้กำลังรบกวนสูงแต่ต้องทราบความถี่เป้าหมายที่แน่นอน',
      category: 'ECM/Jamming',
      relatedTerms: ['Barrage Jamming', 'Sweep Jamming', 'DRFM'],
    ),
    _GlossaryTerm(
      term: 'Range Gate Pull-Off (RGPO)',
      thaiTerm: 'การดึงประตูระยะ',
      definition: 'เทคนิคการรบกวนแบบหลอกลวง โดยส่งพัลส์ปลอมที่เลื่อนเวลาค่อยๆ ทำให้เรดาร์ติดตามเป้าหมายผิดพลาดและสูญเสียการติดตาม',
      category: 'ECM/Jamming',
      relatedTerms: ['VGPO', 'Deception Jamming', 'DRFM'],
    ),
    _GlossaryTerm(
      term: 'Velocity Gate Pull-Off (VGPO)',
      thaiTerm: 'การดึงประตูความเร็ว',
      definition: 'เทคนิคการรบกวนแบบหลอกลวงที่มุ่งเป้าไปที่การติดตาม Doppler ของเรดาร์ ทำให้เรดาร์วัดความเร็วเป้าหมายผิดพลาด',
      category: 'ECM/Jamming',
      relatedTerms: ['RGPO', 'Doppler', 'Deception Jamming'],
    ),
    _GlossaryTerm(
      term: 'Digital RF Memory (DRFM)',
      thaiTerm: 'หน่วยความจำ RF ดิจิทัล',
      definition: 'เทคโนโลยีที่บันทึกสัญญาณเรดาร์แล้วส่งกลับไปในรูปแบบที่ดัดแปลง ใช้สร้างเป้าหมายปลอมหรือการรบกวนแบบหลอกลวงที่แม่นยำ',
      category: 'ECM/Jamming',
      relatedTerms: ['RGPO', 'VGPO', 'Coherent Jamming'],
    ),
    _GlossaryTerm(
      term: 'Chaff',
      thaiTerm: 'แช็ฟ',
      definition: 'แถบโลหะบางขนาดเล็กที่ปล่อยออกมาเพื่อสร้างสัญญาณสะท้อนเรดาร์ปลอม ใช้หลอกล่อขีปนาวุธนำวิถีด้วยเรดาร์',
      category: 'ECM/Jamming',
      relatedTerms: ['Flare', 'Decoy', 'RCS'],
    ),
    _GlossaryTerm(
      term: 'Flare',
      thaiTerm: 'แฟลร์',
      definition: 'พลุความร้อนที่ปล่อยออกมาเพื่อหลอกล่อขีปนาวุธนำวิถีด้วยความร้อน (IR) ให้ติดตามแฟลร์แทนเครื่องบิน',
      category: 'ECM/Jamming',
      relatedTerms: ['Chaff', 'IRCM', 'Decoy'],
    ),

    // ECCM/EP
    _GlossaryTerm(
      term: 'Electronic Counter-Countermeasures (ECCM)',
      thaiTerm: 'มาตรการต่อต้านการรบกวน',
      definition: 'เทคนิคและกระบวนการที่ใช้เพื่อลดผลกระทบของ ECM ของศัตรู ทำให้ระบบอิเล็กทรอนิกส์ทำงานได้ในสภาพแวดล้อมที่มีการรบกวน',
      category: 'ECCM/EP',
      relatedTerms: ['EP', 'FHSS', 'DSSS'],
    ),
    _GlossaryTerm(
      term: 'Frequency Hopping (FHSS)',
      thaiTerm: 'การกระโดดความถี่',
      definition: 'เทคนิคการเปลี่ยนความถี่ส่งอย่างรวดเร็วตามรูปแบบที่กำหนด ทำให้ยากต่อการดักฟังและรบกวน เนื่องจากผู้รบกวนไม่ทราบลำดับความถี่',
      category: 'ECCM/EP',
      relatedTerms: ['Spread Spectrum', 'DSSS', 'LPI'],
    ),
    _GlossaryTerm(
      term: 'Low Probability of Intercept (LPI)',
      thaiTerm: 'ความน่าจะเป็นต่ำในการถูกดักรับ',
      definition: 'คุณสมบัติของระบบส่งสัญญาณที่ออกแบบให้ยากต่อการตรวจจับโดย ESM ของศัตรู โดยใช้เทคนิคเช่น กำลังส่งต่ำ สเปรดสเปกตรัม หรือรูปคลื่นพิเศษ',
      category: 'ECCM/EP',
      relatedTerms: ['LPD', 'Spread Spectrum', 'Stealth'],
    ),
    _GlossaryTerm(
      term: 'Emission Control (EMCON)',
      thaiTerm: 'การควบคุมการแผ่คลื่น',
      definition: 'การควบคุมหรือจำกัดการแผ่คลื่นแม่เหล็กไฟฟ้าเพื่อป้องกันการตรวจจับโดยศัตรู หรือหลีกเลี่ยงการรบกวนกับระบบของฝ่ายเรา',
      category: 'ECCM/EP',
      relatedTerms: ['COMSEC', 'OPSEC', 'Passive'],
    ),
    _GlossaryTerm(
      term: 'Direct Sequence Spread Spectrum (DSSS)',
      thaiTerm: 'การกระจายสเปกตรัมแบบลำดับตรง',
      definition: 'เทคนิคการกระจายสัญญาณโดยใช้รหัสที่มีอัตราสูงกว่าข้อมูล ทำให้สัญญาณกว้างและยากต่อการตรวจจับและรบกวน',
      category: 'ECCM/EP',
      relatedTerms: ['FHSS', 'Spread Spectrum', 'LPI'],
    ),
    _GlossaryTerm(
      term: 'Sidelobe Blanking (SLB)',
      thaiTerm: 'การตัด Sidelobe',
      definition: 'เทคนิค ECCM ที่ใช้เสาอากาศเสริมเพื่อตรวจจับและตัดสัญญาณรบกวนที่เข้ามาทาง Sidelobe ของเสาอากาศหลัก',
      category: 'ECCM/EP',
      relatedTerms: ['SLC', 'ECCM', 'Antenna Pattern'],
    ),
    _GlossaryTerm(
      term: 'Sidelobe Canceller (SLC)',
      thaiTerm: 'ตัวยกเลิก Sidelobe',
      definition: 'เทคนิคที่ใช้เสาอากาศเสริมในการยกเลิกสัญญาณรบกวนที่เข้าทาง Sidelobe โดยการหักล้างสัญญาณ',
      category: 'ECCM/EP',
      relatedTerms: ['SLB', 'ECCM', 'Adaptive Processing'],
    ),
    _GlossaryTerm(
      term: 'Pulse Compression',
      thaiTerm: 'การบีบอัดพัลส์',
      definition: 'เทคนิคที่ส่งพัลส์ยาวเพื่อพลังงานสูง แล้วบีบอัดในเครื่องรับเพื่อความละเอียดสูง ให้ทั้งระยะไกลและความละเอียดดี',
      category: 'ECCM/EP',
      relatedTerms: ['Chirp', 'Range Resolution', 'LFM'],
    ),
    _GlossaryTerm(
      term: 'Frequency Agility',
      thaiTerm: 'ความคล่องตัวทางความถี่',
      definition: 'ความสามารถในการเปลี่ยนความถี่ทำงานอย่างรวดเร็วระหว่างพัลส์หรือระหว่าง burst ทำให้ยากต่อการรบกวนแบบ Spot',
      category: 'ECCM/EP',
      relatedTerms: ['FHSS', 'ECCM', 'Adaptive'],
    ),
    _GlossaryTerm(
      term: 'Anti-jam (AJ)',
      thaiTerm: 'ต้านการรบกวน',
      definition: 'คุณสมบัติหรือเทคนิคที่ออกแบบมาเพื่อให้ระบบทำงานได้แม้ในสภาวะที่มีการรบกวนอิเล็กทรอนิกส์',
      category: 'ECCM/EP',
      relatedTerms: ['ECCM', 'FHSS', 'DSSS'],
    ),

    // Radar
    _GlossaryTerm(
      term: 'Pulse Repetition Frequency (PRF)',
      thaiTerm: 'ความถี่ซ้ำของพัลส์',
      definition: 'จำนวนพัลส์เรดาร์ที่ส่งออกไปต่อวินาที มีผลต่อระยะตรวจจับสูงสุดและความสามารถในการวัดความเร็ว PRF สูงให้ความละเอียดความเร็วดีแต่ระยะสั้น',
      category: 'Radar',
      relatedTerms: ['PRI', 'Duty Cycle', 'Range Ambiguity'],
    ),
    _GlossaryTerm(
      term: 'Pulse Width (PW)',
      thaiTerm: 'ความกว้างพัลส์',
      definition: 'ระยะเวลาของพัลส์เรดาร์แต่ละลูก มีผลต่อความละเอียดในการแยกเป้าหมายและพลังงานที่ส่งออกไป พัลส์แคบให้ความละเอียดระยะดี',
      category: 'Radar',
      relatedTerms: ['PRF', 'Duty Cycle', 'Range Resolution'],
    ),
    _GlossaryTerm(
      term: 'Doppler Effect',
      thaiTerm: 'ปรากฏการณ์ดอปเปลอร์',
      definition: 'การเปลี่ยนแปลงความถี่ของคลื่นที่สะท้อนกลับเนื่องจากการเคลื่อนที่สัมพัทธ์ระหว่างเรดาร์และเป้าหมาย ใช้วัดความเร็วเป้าหมาย',
      category: 'Radar',
      relatedTerms: ['MTI', 'Pulse-Doppler', 'Clutter'],
    ),
    _GlossaryTerm(
      term: 'Phased Array',
      thaiTerm: 'เฟสอาร์เรย์',
      definition: 'เทคโนโลยีเรดาร์ที่ใช้องค์ประกอบเสาอากาศจำนวนมากและควบคุมเฟสของแต่ละองค์ประกอบด้วยอิเล็กทรอนิกส์ ทำให้สามารถกวาดลำคลื่นได้โดยไม่ต้องหมุนเสาอากาศ',
      category: 'Radar',
      relatedTerms: ['AESA', 'PESA', 'Beam Steering'],
    ),
    _GlossaryTerm(
      term: 'Active Electronically Scanned Array (AESA)',
      thaiTerm: 'เรดาร์แบบสแกนอิเล็กทรอนิกส์แอ็คทีฟ',
      definition: 'เรดาร์เฟสอาร์เรย์ที่แต่ละองค์ประกอบมีโมดูลส่ง-รับ (T/R Module) ของตัวเอง ให้ความน่าเชื่อถือสูง กำลังส่งมาก และความสามารถ LPI',
      category: 'Radar',
      relatedTerms: ['PESA', 'T/R Module', 'Phased Array'],
    ),
    _GlossaryTerm(
      term: 'Pulse Repetition Interval (PRI)',
      thaiTerm: 'ช่วงเวลาระหว่างพัลส์',
      definition: 'ระยะเวลาระหว่างพัลส์เรดาร์ที่ส่งติดต่อกัน เป็นส่วนกลับของ PRF (PRI = 1/PRF) มีผลต่อระยะตรวจจับสูงสุด',
      category: 'Radar',
      relatedTerms: ['PRF', 'Duty Cycle', 'Range Ambiguity'],
    ),
    _GlossaryTerm(
      term: 'Radar Cross Section (RCS)',
      thaiTerm: 'พื้นที่หน้าตัดเรดาร์',
      definition: 'ตัววัดขนาดของเป้าหมายที่เรดาร์มองเห็น วัดเป็นตารางเมตร RCS ขึ้นอยู่กับรูปร่าง วัสดุ และมุมมองของเป้าหมาย',
      category: 'Radar',
      relatedTerms: ['Stealth', 'Target Detection', 'Clutter'],
    ),
    _GlossaryTerm(
      term: 'Moving Target Indicator (MTI)',
      thaiTerm: 'ตัวระบุเป้าหมายเคลื่อนที่',
      definition: 'เทคนิคการประมวลผลเรดาร์ที่แยกเป้าหมายที่เคลื่อนที่ออกจาก Clutter ที่อยู่กับที่โดยใช้การเปลี่ยนแปลงเฟสระหว่างพัลส์',
      category: 'Radar',
      relatedTerms: ['Doppler', 'Clutter', 'Pulse-Doppler'],
    ),
    _GlossaryTerm(
      term: 'Clutter',
      thaiTerm: 'สัญญาณรบกวนจากพื้นผิว',
      definition: 'สัญญาณสะท้อนที่ไม่ต้องการจากพื้นดิน ทะเล หรือสภาพอากาศ ทำให้ยากต่อการตรวจจับเป้าหมายที่ต้องการ',
      category: 'Radar',
      relatedTerms: ['MTI', 'Sea Clutter', 'Ground Clutter'],
    ),
    _GlossaryTerm(
      term: 'Synthetic Aperture Radar (SAR)',
      thaiTerm: 'เรดาร์แบบช่องรับสังเคราะห์',
      definition: 'เรดาร์ที่สร้างภาพความละเอียดสูงโดยใช้การเคลื่อนที่ของแพลตฟอร์มเพื่อสังเคราะห์เสาอากาศขนาดใหญ่เสมือน',
      category: 'Radar',
      relatedTerms: ['ISAR', 'Imaging Radar', 'Resolution'],
    ),
    _GlossaryTerm(
      term: 'Track While Scan (TWS)',
      thaiTerm: 'ติดตามขณะกวาด',
      definition: 'โหมดการทำงานเรดาร์ที่สามารถกวาดค้นหาและติดตามเป้าหมายหลายตัวพร้อมกัน โดยไม่ต้องล็อคเป้าหมายเดียว',
      category: 'Radar',
      relatedTerms: ['STT', 'Multi-target', 'Scan Pattern'],
    ),
    _GlossaryTerm(
      term: 'Side-Looking Airborne Radar (SLAR)',
      thaiTerm: 'เรดาร์ทางอากาศมองด้านข้าง',
      definition: 'เรดาร์ที่ติดตั้งบนอากาศยานโดยหันเสาอากาศไปด้านข้าง ใช้สำหรับการสำรวจและถ่ายภาพภาคพื้น',
      category: 'Radar',
      relatedTerms: ['SAR', 'Reconnaissance', 'Imaging'],
    ),
    _GlossaryTerm(
      term: 'Over-The-Horizon Radar (OTHR)',
      thaiTerm: 'เรดาร์ข้ามขอบฟ้า',
      definition: 'เรดาร์ที่ใช้การสะท้อนจากชั้นบรรยากาศเพื่อตรวจจับเป้าหมายที่อยู่ไกลเกินขอบฟ้า สามารถตรวจจับได้ไกลหลายพันกิโลเมตร',
      category: 'Radar',
      relatedTerms: ['HF Radar', 'Sky Wave', 'JORN'],
    ),

    // Communications
    _GlossaryTerm(
      term: 'Software Defined Radio (SDR)',
      thaiTerm: 'วิทยุที่กำหนดด้วยซอฟต์แวร์',
      definition: 'ระบบวิทยุสื่อสารที่ส่วนประกอบฮาร์ดแวร์แบบดั้งเดิม (มิกเซอร์ ฟิลเตอร์ โมดูเลเตอร์) ถูกทดแทนด้วยซอฟต์แวร์ ทำให้ปรับเปลี่ยนรูปคลื่นและความถี่ได้ง่าย',
      category: 'Communications',
      relatedTerms: ['Cognitive Radio', 'Waveform', 'JTRS'],
    ),
    _GlossaryTerm(
      term: 'Link-16',
      thaiTerm: 'ลิงค์-16',
      definition: 'ระบบดาต้าลิงค์ทางทหารมาตรฐาน NATO ใช้ในการแลกเปลี่ยนข้อมูลทางยุทธวิธีระหว่างหน่วยต่างๆ แบบเรียลไทม์ ใช้ TDMA และ frequency hopping',
      category: 'Communications',
      relatedTerms: ['TADIL-J', 'MIDS', 'Data Link'],
    ),
    _GlossaryTerm(
      term: 'SATCOM',
      thaiTerm: 'การสื่อสารผ่านดาวเทียม',
      definition: 'การสื่อสารโดยใช้ดาวเทียมเป็นตัวกลางในการถ่ายทอดสัญญาณ ครอบคลุมพื้นที่กว้าง ใช้ในการสื่อสารระยะไกลและพื้นที่ห่างไกล',
      category: 'Communications',
      relatedTerms: ['GEO', 'LEO', 'Uplink', 'Downlink'],
    ),
    _GlossaryTerm(
      term: 'Time Division Multiple Access (TDMA)',
      thaiTerm: 'การเข้าถึงหลายผู้ใช้แบบแบ่งเวลา',
      definition: 'เทคนิคการแบ่งช่องสัญญาณโดยให้แต่ละผู้ใช้ส่งในช่วงเวลา (Time Slot) ที่กำหนด ใช้ใน Link-16 และระบบสื่อสารทางทหาร',
      category: 'Communications',
      relatedTerms: ['FDMA', 'CDMA', 'Link-16'],
    ),
    _GlossaryTerm(
      term: 'High Frequency (HF)',
      thaiTerm: 'ความถี่สูง',
      definition: 'ย่านความถี่ 3-30 MHz สามารถสะท้อนจากชั้นบรรยากาศได้ ใช้ในการสื่อสารระยะไกลโดยไม่ต้องใช้ดาวเทียม',
      category: 'Communications',
      relatedTerms: ['VHF', 'UHF', 'Sky Wave', 'NVIS'],
    ),
    _GlossaryTerm(
      term: 'Very High Frequency (VHF)',
      thaiTerm: 'ความถี่สูงมาก',
      definition: 'ย่านความถี่ 30-300 MHz ใช้ในการสื่อสารทางอากาศ-ภาคพื้น วิทยุ FM และโทรทัศน์ เป็นการส่งแบบ Line-of-Sight',
      category: 'Communications',
      relatedTerms: ['HF', 'UHF', 'FM Radio'],
    ),
    _GlossaryTerm(
      term: 'Ultra High Frequency (UHF)',
      thaiTerm: 'ความถี่สูงพิเศษ',
      definition: 'ย่านความถี่ 300 MHz - 3 GHz ใช้ในการสื่อสารทางทหาร SATCOM และระบบ GPS มีการทะลุทะลวงดีกว่า VHF',
      category: 'Communications',
      relatedTerms: ['VHF', 'SHF', 'SATCOM'],
    ),
    _GlossaryTerm(
      term: 'COMSEC (Communications Security)',
      thaiTerm: 'การรักษาความปลอดภัยการสื่อสาร',
      definition: 'มาตรการป้องกันการสื่อสารจากการดักฟัง รวมถึงการเข้ารหัส การจัดการกุญแจ และความปลอดภัยทางกายภาพ',
      category: 'Communications',
      relatedTerms: ['TRANSEC', 'CRYPTO', 'EMCON'],
    ),
    _GlossaryTerm(
      term: 'TRANSEC (Transmission Security)',
      thaiTerm: 'การรักษาความปลอดภัยการส่ง',
      definition: 'มาตรการป้องกันการดักรับการส่งสัญญาณ รวมถึง Frequency Hopping และ Spread Spectrum',
      category: 'Communications',
      relatedTerms: ['COMSEC', 'FHSS', 'DSSS'],
    ),
    _GlossaryTerm(
      term: 'Near Vertical Incidence Skywave (NVIS)',
      thaiTerm: 'คลื่นฟ้าตกกระทบใกล้แนวดิ่ง',
      definition: 'เทคนิคการสื่อสาร HF ที่ยิงสัญญาณขึ้นไปเกือบแนวดิ่งให้สะท้อนกลับมา ครอบคลุมพื้นที่รัศมี 0-400 km โดยไม่มี Dead Zone',
      category: 'Communications',
      relatedTerms: ['HF', 'Sky Wave', 'Ionosphere'],
    ),

    // Anti-Drone/C-UAS
    _GlossaryTerm(
      term: 'Counter-Unmanned Aircraft Systems (C-UAS)',
      thaiTerm: 'ระบบต่อต้านอากาศยานไร้คนขับ',
      definition: 'ระบบและเทคนิคที่ใช้ในการตรวจจับ ติดตาม ระบุ และทำลายหรือปิดกั้นอากาศยานไร้คนขับ (โดรน)',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['C-sUAS', 'Drone Jammer', 'Anti-Drone'],
    ),
    _GlossaryTerm(
      term: 'RF Detection',
      thaiTerm: 'การตรวจจับด้วยคลื่นวิทยุ',
      definition: 'การตรวจจับโดรนโดยการดักรับสัญญาณควบคุมหรือสัญญาณ video link ระหว่างโดรนกับผู้ควบคุม',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['ESM', 'DF', 'Passive Detection'],
    ),
    _GlossaryTerm(
      term: 'Acoustic Detection',
      thaiTerm: 'การตรวจจับด้วยเสียง',
      definition: 'การตรวจจับโดรนโดยใช้ไมโครโฟนจับเสียงใบพัดและมอเตอร์ เหมาะกับโดรนขนาดเล็กที่เรดาร์ตรวจจับยาก',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Sensor Fusion', 'Detection', 'Multi-sensor'],
    ),
    _GlossaryTerm(
      term: 'Electro-Optical/Infrared (EO/IR)',
      thaiTerm: 'อิเล็กโทรออปติก/อินฟราเรด',
      definition: 'ระบบเซนเซอร์ที่ใช้กล้องแสงที่ตามองเห็นและอินฟราเรดในการตรวจจับ ติดตาม และระบุโดรน',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Sensor Fusion', 'Tracking', 'Identification'],
    ),
    _GlossaryTerm(
      term: 'Drone Spoofing',
      thaiTerm: 'การหลอกโดรน',
      definition: 'การส่งสัญญาณควบคุมหรือ GPS ปลอมเพื่อเข้าควบคุมโดรนหรือทำให้โดรนบินไปยังตำแหน่งที่ผิด',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['GPS Spoofing', 'Takeover', 'Cyber Attack'],
    ),
    _GlossaryTerm(
      term: 'Drone Takeover',
      thaiTerm: 'การยึดครองโดรน',
      definition: 'การเข้าควบคุมโดรนของศัตรูโดยการหลอกระบบสื่อสารหรือใช้ช่องโหว่ในซอฟต์แวร์',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Spoofing', 'Hacking', 'Cyber Attack'],
    ),
    _GlossaryTerm(
      term: 'Drone Swarm',
      thaiTerm: 'ฝูงโดรน',
      definition: 'กลุ่มโดรนจำนวนมากที่ทำงานร่วมกันอย่างประสานงาน อาจใช้ AI ควบคุม เป็นภัยคุกคามที่ยากต่อการรับมือ',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Autonomous', 'AI', 'Mass Attack'],
    ),
    _GlossaryTerm(
      term: 'Kinetic Countermeasure',
      thaiTerm: 'มาตรการต่อต้านแบบจลนศาสตร์',
      definition: 'การทำลายโดรนด้วยอาวุธกายภาพ เช่น ปืน ขีปนาวุธ เลเซอร์ หรือ nets',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Non-kinetic', 'Laser', 'Interceptor'],
    ),
    _GlossaryTerm(
      term: 'Non-Kinetic Countermeasure',
      thaiTerm: 'มาตรการต่อต้านแบบไม่ใช้แรงจลน์',
      definition: 'การปิดกั้นโดรนโดยไม่ทำลายทางกายภาพ เช่น การรบกวนสัญญาณ GPS Spoofing หรือ Cyber Attack',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Kinetic', 'Jamming', 'Spoofing'],
    ),
    _GlossaryTerm(
      term: 'Return to Home (RTH)',
      thaiTerm: 'กลับฐาน',
      definition: 'ฟังก์ชันอัตโนมัติของโดรนที่จะบินกลับจุดปล่อยเมื่อสูญเสียสัญญาณควบคุมหรือ GPS ถูกรบกวน',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['Failsafe', 'GPS Jamming', 'Autonomous'],
    ),
    _GlossaryTerm(
      term: 'Geofencing',
      thaiTerm: 'รั้วเสมือน',
      definition: 'ระบบซอฟต์แวร์ที่ป้องกันโดรนจากการบินเข้าพื้นที่หวงห้าม ฝังอยู่ในเฟิร์มแวร์ของโดรนเชิงพาณิชย์ส่วนใหญ่',
      category: 'Anti-Drone/C-UAS',
      relatedTerms: ['No-fly Zone', 'NFZ', 'Software'],
    ),

    // Cyber EW
    _GlossaryTerm(
      term: 'Cyber Electromagnetic Activities (CEMA)',
      thaiTerm: 'กิจกรรมไซเบอร์แม่เหล็กไฟฟ้า',
      definition: 'การบูรณาการปฏิบัติการไซเบอร์ สงครามอิเล็กทรอนิกส์ และการจัดการสเปกตรัม เพื่อให้ได้เปรียบในโดเมนไซเบอร์และแม่เหล็กไฟฟ้า',
      category: 'Cyber EW',
      relatedTerms: ['CO', 'EW', 'SMO'],
    ),
    _GlossaryTerm(
      term: 'Spectrum Warfare',
      thaiTerm: 'สงครามสเปกตรัม',
      definition: 'แนวคิดในการมองสเปกตรัมแม่เหล็กไฟฟ้าเป็นโดเมนในการทำสงคราม โดยรวม EW และ Cyber เข้าด้วยกัน เพื่อครองความเหนือกว่าในสเปกตรัม',
      category: 'Cyber EW',
      relatedTerms: ['EMS', 'EMSO', 'CEMA'],
    ),
    _GlossaryTerm(
      term: 'Electromagnetic Maneuver Warfare (EMW)',
      thaiTerm: 'สงครามการเคลื่อนไหวแม่เหล็กไฟฟ้า',
      definition: 'แนวคิดการผสมผสาน EW กับการเคลื่อนไหวทางยุทธวิธี ใช้สเปกตรัมเป็นเครื่องมือในการสร้างความได้เปรียบ',
      category: 'Cyber EW',
      relatedTerms: ['EMSO', 'Maneuver', 'EW'],
    ),
    _GlossaryTerm(
      term: 'Cognitive Electronic Warfare',
      thaiTerm: 'สงครามอิเล็กทรอนิกส์แบบรู้คิด',
      definition: 'ระบบ EW ที่ใช้ AI และ Machine Learning ในการวิเคราะห์และตอบสนองต่อภัยคุกคามอัตโนมัติและปรับตัวแบบเรียลไทม์',
      category: 'Cyber EW',
      relatedTerms: ['AI', 'Adaptive', 'Machine Learning'],
    ),
    _GlossaryTerm(
      term: 'Software-Defined EW',
      thaiTerm: 'EW ที่กำหนดด้วยซอฟต์แวร์',
      definition: 'ระบบ EW ที่ใช้ซอฟต์แวร์ในการกำหนดฟังก์ชันการทำงาน ทำให้สามารถอัปเกรดและปรับเปลี่ยนได้ง่าย',
      category: 'Cyber EW',
      relatedTerms: ['SDR', 'Reprogrammable', 'FPGA'],
    ),
    _GlossaryTerm(
      term: 'Cyber Attack on EW Systems',
      thaiTerm: 'การโจมตีไซเบอร์ต่อระบบ EW',
      definition: 'การโจมตีระบบ EW ผ่านช่องทางไซเบอร์ เช่น การแฮกซอฟต์แวร์ การฉีดข้อมูลปลอม หรือการปิดกั้นการทำงาน',
      category: 'Cyber EW',
      relatedTerms: ['CEMA', 'Hacking', 'Vulnerability'],
    ),
    _GlossaryTerm(
      term: 'Electronic Signature',
      thaiTerm: 'ลายเซ็นอิเล็กทรอนิกส์',
      definition: 'ลักษณะเฉพาะของสัญญาณที่แผ่ออกมาจากระบบอิเล็กทรอนิกส์ ใช้ในการระบุตัวตนและจำแนกประเภทอุปกรณ์',
      category: 'Cyber EW',
      relatedTerms: ['ELINT', 'Fingerprinting', 'Emitter ID'],
    ),
    _GlossaryTerm(
      term: 'Electromagnetic Pulse (EMP)',
      thaiTerm: 'พัลส์แม่เหล็กไฟฟ้า',
      definition: 'การแผ่คลื่นแม่เหล็กไฟฟ้าเป็นพัลส์สั้นแรงมาก สามารถทำลายหรือรบกวนอุปกรณ์อิเล็กทรอนิกส์ในวงกว้าง',
      category: 'Cyber EW',
      relatedTerms: ['NNEMP', 'HEMP', 'HPM'],
    ),
    _GlossaryTerm(
      term: 'High-Power Microwave (HPM)',
      thaiTerm: 'ไมโครเวฟกำลังสูง',
      definition: 'อาวุธที่ใช้พลังงานไมโครเวฟกำลังสูงในการทำลายหรือรบกวนอุปกรณ์อิเล็กทรอนิกส์ เป็นอาวุธพลังงานนำวิถี (DEW)',
      category: 'Cyber EW',
      relatedTerms: ['EMP', 'DEW', 'Directed Energy'],
    ),
    _GlossaryTerm(
      term: 'Network-Centric Warfare',
      thaiTerm: 'สงครามเครือข่ายเป็นศูนย์กลาง',
      definition: 'หลักนิยมการรบที่ใช้เครือข่ายข้อมูลเชื่อมโยงเซนเซอร์ ผู้ตัดสินใจ และผู้ปฏิบัติเข้าด้วยกัน เพื่อความได้เปรียบด้านข้อมูล',
      category: 'Cyber EW',
      relatedTerms: ['C4ISR', 'Data Link', 'Information Warfare'],
    ),
    _GlossaryTerm(
      term: 'Integrated Air Defense System (IADS)',
      thaiTerm: 'ระบบป้องกันภัยทางอากาศแบบบูรณาการ',
      definition: 'ระบบที่รวมเรดาร์ ขีปนาวุธ และปืนต่อสู้อากาศยานเข้าด้วยกันผ่านเครือข่าย เป็นเป้าหมายหลักของ SEAD/DEAD',
      category: 'Cyber EW',
      relatedTerms: ['SEAD', 'DEAD', 'SAM'],
    ),
    _GlossaryTerm(
      term: 'Suppression of Enemy Air Defenses (SEAD)',
      thaiTerm: 'การกดการป้องกันภัยทางอากาศของศัตรู',
      definition: 'ปฏิบัติการที่มุ่งลดประสิทธิภาพระบบป้องกันภัยทางอากาศของศัตรู รวมถึงการรบกวนและทำลาย',
      category: 'Cyber EW',
      relatedTerms: ['DEAD', 'ARM', 'Wild Weasel'],
    ),
  ];
}

class _GlossaryTerm {
  final String term;
  final String thaiTerm;
  final String definition;
  final String category;
  final List<String> relatedTerms;

  _GlossaryTerm({
    required this.term,
    required this.thaiTerm,
    required this.definition,
    required this.category,
    this.relatedTerms = const [],
  });
}
