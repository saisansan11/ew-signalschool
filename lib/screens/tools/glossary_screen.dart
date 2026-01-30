import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

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
