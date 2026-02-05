/// EW Study Data - เนื้อหาสำหรับนักเรียนศึกษาก่อนสอบ
/// ข้อมูลจากหลักสูตร "สงครามอิเล็กทรอนิกส์ V.2" โรงเรียนทหารสื่อสาร

import 'package:flutter/material.dart';

// ==========================================
// 1. COURSE INFORMATION
// ==========================================
class EWCourseInfo {
  static const String title = 'สงครามอิเล็กทรอนิกส์ (Electronic Warfare)';
  static const String version = '2.5';
  static const int totalModules = 9;
  static const int totalPages = 180;
  static const String author = 'ร.ต. วสันต์ ธาตุนามล';
  static const String institution = 'โรงเรียนทหารสื่อสาร';
  static const String description =
      'หลักสูตรสงครามอิเล็กทรอนิกส์สำหรับนายสิบ - ศาสตร์แห่งการรบในสนามรบที่มองไม่เห็น';
}

// ==========================================
// 2. KEY CONCEPTS - หลักการสำคัญ
// ==========================================
class EWKeyConcepts {
  /// 3 ภารกิจหลักของ EW
  static const List<Map<String, dynamic>> ewMissions = [
    {
      'name': 'Control (ควบคุม)',
      'description': 'ใช้คลื่นแม่เหล็กไฟฟ้าให้เกิดความได้เปรียบ',
      'icon': Icons.gamepad,
      'color': 0xFF4CAF50,
    },
    {
      'name': 'Degrade (ลดทอน)',
      'description': 'ขัดขวางหรือลดประสิทธิผลการใช้คลื่นของข้าศึก',
      'icon': Icons.flash_on,
      'color': 0xFFFF9800,
    },
    {
      'name': 'Protect (ป้องกัน)',
      'description': 'ป้องกันไม่ให้ข้าศึกทำเช่นเดียวกับเรา',
      'icon': Icons.shield,
      'color': 0xFF2196F3,
    },
  ];

  /// 5 ขั้นตอนของ ESM
  static const List<Map<String, dynamic>> esmSteps = [
    {
      'step': 1,
      'name': 'ค้นหา (Search)',
      'description': 'สแกนหาสัญญาณในบริเวณปฏิบัติการ',
      'icon': Icons.search,
    },
    {
      'step': 2,
      'name': 'ดักรับ (Intercept)',
      'description': 'จับสัญญาณที่พบ',
      'icon': Icons.wifi_tethering,
    },
    {
      'step': 3,
      'name': 'ระบุตัวตน (Identify)',
      'description': 'วิเคราะห์ว่าสัญญาณมาจากอะไร',
      'icon': Icons.fingerprint,
    },
    {
      'step': 4,
      'name': 'บันทึก (Record)',
      'description': 'เก็บข้อมูลสัญญาณ',
      'icon': Icons.save,
    },
    {
      'step': 5,
      'name': 'วิเคราะห์ (Analyze)',
      'description': 'ประมวลผลเพื่อหาแหล่งกำเนิด',
      'icon': Icons.analytics,
    },
  ];

  /// ประเภท Jamming
  static const List<Map<String, String>> jammingTypes = [
    {
      'name': 'Spot Jamming',
      'description': 'รบกวนความถี่เฉพาะจุด (แรงแต่แคบ)',
    },
    {
      'name': 'Barrage Jamming',
      'description': 'รบกวนช่วงกว้าง (อ่อนแต่กว้าง)',
    },
    {
      'name': 'Sweep Jamming',
      'description': 'กวาดรบกวนทีละช่วง',
    },
    {
      'name': 'Deceptive Jamming',
      'description': 'รบกวนพร้อมหลอกลวง',
    },
  ];

  /// เทคนิค ECCM
  static const List<Map<String, dynamic>> eccmTechniques = [
    {
      'name': 'Frequency Hopping',
      'description': 'การกระโดดความถี่อย่างรวดเร็ว',
      'example': '100 MHz → 150 MHz → 85 MHz (ทุก 0.01 วินาที)',
    },
    {
      'name': 'EMCON',
      'description': 'วินัยการงดแพร่กระจายคลื่น',
      'rules': ['เงียบคือชีวิต', 'ส่งสัญญาณเฉพาะจำเป็น', 'ใช้กำลังส่งต่ำสุด'],
    },
    {
      'name': 'Anti-Jamming',
      'description': 'เทคโนโลยีต้าน Jamming',
      'techniques': ['Adaptive Filters', 'Directional Antennas', 'Spread Spectrum'],
    },
  ];

  /// ความสำคัญของ EW: "No Spectrum = No Fight"
  static const List<Map<String, dynamic>> whyEWMatters = [
    {
      'name': 'Dependency (การพึ่งพา)',
      'description': 'กองทัพยุคใหม่ใช้ GPS, Data Links 100%',
      'impact': 'สูงมาก',
    },
    {
      'name': 'Paralysis (ความเป็นอัมพาต)',
      'description': 'ติดสัญญาณ = อึ้งทั้งกองทัพ',
      'impact': 'สูงมาก',
    },
    {
      'name': 'Asymmetric (ความคุ้มค่า)',
      'description': 'Jammer หลักแสน ทำลายหมื่นล้าน',
      'impact': 'สูง',
    },
    {
      'name': 'Victory (ชัยชนะ)',
      'description': 'ผู้ชนะใน EW = ชนะสงคราม',
      'impact': 'สูงมาก',
    },
    {
      'name': 'First Strike',
      'description': 'สงครามเริ่มด้วยการโจมตีสัญญาณก่อนเสมอ',
      'impact': 'สูงมาก',
    },
  ];
}

// ==========================================
// 3. THREAT CARDS - ระบบ EW ของรัสเซีย
// ==========================================
class ThreatCard {
  final String system;
  final String mission;
  final String effectiveness;
  final String threatLevel;
  final String range;
  final List<String> targets;
  final String mobility;

  const ThreatCard({
    required this.system,
    required this.mission,
    required this.effectiveness,
    required this.threatLevel,
    required this.range,
    required this.targets,
    required this.mobility,
  });

  Color get threatColor {
    switch (threatLevel) {
      case 'สูงมาก':
        return const Color(0xFFB71C1C);
      case 'สูง':
        return Colors.red;
      case 'กลาง':
        return Colors.orange;
      case 'ต่ำ':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class RussianEWSystems {
  static const List<ThreatCard> threatCards = [
    ThreatCard(
      system: 'Borisoglebsk-2',
      mission: 'Jamming สัญญาณวิทยุและ GPS',
      effectiveness: 'แบบครบวงจร',
      threatLevel: 'สูงมาก',
      range: '100+ km',
      targets: ['GPS', 'VHF', 'UHF'],
      mobility: 'Mobile',
    ),
    ThreatCard(
      system: 'Zhitel (R-330Zh)',
      mission: 'เชี่ยวชาญติดสัญญาณดาวเทียม',
      effectiveness: 'โจมตีเฉพาะจุด',
      threatLevel: 'สูง',
      range: '80 km',
      targets: ['Satcom', 'Data Links'],
      mobility: 'Mobile',
    ),
    ThreatCard(
      system: 'Palantin',
      mission: 'Spoofing (หลอกพิกัด) วงกว้าง',
      effectiveness: 'โจมตีแบบหลอกลวง',
      threatLevel: 'สูงมาก',
      range: '150+ km',
      targets: ['GPS', 'GLONASS'],
      mobility: 'Mobile',
    ),
    ThreatCard(
      system: 'Krasukha-4',
      mission: 'รบกวนเรดาร์และดาวเทียม',
      effectiveness: 'ครอบคลุมกว้าง',
      threatLevel: 'สูงมาก',
      range: '300 km',
      targets: ['AWACS', 'Radar', 'Satellite'],
      mobility: 'Mobile',
    ),
    ThreatCard(
      system: 'Leer-3',
      mission: 'Jamming โทรศัพท์มือถือ + ส่ง SMS ปลอม',
      effectiveness: 'สงครามข้อมูล',
      threatLevel: 'กลาง',
      range: '6 km',
      targets: ['GSM', 'Cellular'],
      mobility: 'Drone-based',
    ),
  ];
}

// ==========================================
// 4. GPS WARFARE - Jamming vs Spoofing
// ==========================================
class GPSWarfareData {
  static const Map<String, dynamic> jamming = {
    'description': 'ทำให้รับสัญญาณไม่ได้',
    'effect': 'NO SIGNAL',
    'impact': 'Denial of Service',
    'detection': 'ง่าย - รู้ทันทีว่าถูกรบกวน',
    'indicators': [
      'หน้าจอแสดง "No GPS Signal"',
      'ระบบนำทางหยุดทำงาน',
      'ไม่สามารถระบุพิกัดได้',
    ],
  };

  static const Map<String, dynamic> spoofing = {
    'description': 'ส่งค่าพิกัดปลอม',
    'effect': 'แสดงตำแหน่งผิด',
    'impact': 'บินผิดทิศ, ตกผิดเป้าหมาย',
    'detection': 'ยาก - ดูปกติแต่พิกัดผิด',
    'indicators': [
      'GPS ทำงานปกติแต่พิกัดเพี้ยน',
      'ตำแหน่งไม่ตรงกับเข็มทิศ/แผนที่',
      'ยานพาหนะหรือโดรนเคลื่อนที่ผิดทิศ',
    ],
  };
}

// ==========================================
// 5. KILL CHAIN PROCESS
// ==========================================
class KillChainData {
  static const List<Map<String, dynamic>> steps = [
    {
      'step': 1,
      'name': 'Order of Battle',
      'description': 'ข่าวกรองยุทธศาสตร์/คำสั่งรบ',
      'icon': Icons.description,
    },
    {
      'step': 2,
      'name': 'SIGINT (COMINT + ELINT)',
      'description': 'รวบรวมข่าวกรองสัญญาณ',
      'icon': Icons.hearing,
    },
    {
      'step': 3,
      'name': 'ESM',
      'description': 'ค้นหา, ดักรับ, หาทิศ, วิเคราะห์',
      'icon': Icons.radar,
    },
    {
      'step': 4,
      'name': 'Targeting & Action',
      'description': 'Detected → Located → Destroyed',
      'icon': Icons.gps_fixed,
    },
  ];

  static const String principle =
      'Intelligence drives effective operations. Secure the advantage.';
}

// ==========================================
// 6. SURVIVAL RULES - กฎการอยู่รอด
// ==========================================
class SurvivalRules {
  static const List<Map<String, dynamic>> rules = [
    {
      'rule': 1,
      'name': 'วินัยการสื่อสาร (Comms Discipline)',
      'practices': [
        'พูดสั้น ชัดเจน ใช้รหัส',
        'ไม่ส่งข้อความที่ไม่จำเป็น',
        'ระมัดระวังการพูดคุยส่วนตัว',
      ],
      'icon': Icons.mic,
    },
    {
      'rule': 2,
      'name': 'EMCON (Emission Control)',
      'practices': [
        'ห้ามส่งสัญญาณไม่จำเป็น',
        'การเงียบคือการซ่อนตัว',
        'ลดพลังส่งให้น้อยที่สุด',
      ],
      'icon': Icons.signal_wifi_off,
    },
    {
      'rule': 3,
      'name': 'การสังเกตการณ์ (Observation)',
      'practices': [
        'หาก GPS เพี้ยน หรือวิทยุผิดปกติ',
        'ให้สงสัยว่าถูก Jam',
        'รายงานผู้บังคับบัญชาทันที',
      ],
      'icon': Icons.visibility,
    },
    {
      'rule': 4,
      'name': 'Smartphone Warning',
      'warning': 'ห้ามใช้มือถือส่วนตัวในพื้นที่ปฏิบัติการ',
      'reasons': [
        'GPS ในมือถือเปิดตลอด',
        'สัญญาณมือถือถูกดักได้',
        'ข้าศึกหาตำแหน่งได้ภายใน 3 นาที',
      ],
      'icon': Icons.phone_android,
    },
  ];

  static const String motto = 'Discipline is survival. Silence is your shield.';
}

// ==========================================
// 7. GLOSSARY - คำศัพท์ EW
// ==========================================
class GlossaryTerm {
  final String term;
  final String definition;
  final String category;
  final String? fullForm;

  const GlossaryTerm({
    required this.term,
    required this.definition,
    required this.category,
    this.fullForm,
  });
}

class EWGlossary {
  static const List<GlossaryTerm> terms = [
    // พื้นฐาน
    GlossaryTerm(
      term: 'EW',
      fullForm: 'Electronic Warfare',
      definition: 'สงครามอิเล็กทรอนิกส์ - การใช้พลังงานแม่เหล็กไฟฟ้าในการรบ',
      category: 'พื้นฐาน',
    ),
    GlossaryTerm(
      term: 'EMS',
      fullForm: 'Electromagnetic Spectrum',
      definition: 'สเปกตรัมแม่เหล็กไฟฟ้า - ช่วงคลื่นทั้งหมดที่ใช้ในการสื่อสารและตรวจจับ',
      category: 'พื้นฐาน',
    ),

    // 3 เสาหลัก
    GlossaryTerm(
      term: 'ESM',
      fullForm: 'Electronic Support Measures',
      definition: 'การสนับสนุนทางอิเล็กทรอนิกส์ - ค้นหา ดักรับ ระบุ บันทึก วิเคราะห์สัญญาณ',
      category: '3 เสาหลัก',
    ),
    GlossaryTerm(
      term: 'ECM',
      fullForm: 'Electronic Countermeasures',
      definition: 'มาตรการต่อต้านทางอิเล็กทรอนิกส์ - รบกวน หลอกลวง ทำลายระบบข้าศึก',
      category: '3 เสาหลัก',
    ),
    GlossaryTerm(
      term: 'ECCM',
      fullForm: 'Electronic Counter-Countermeasures',
      definition: 'มาตรการป้องกันการต่อต้าน - ป้องกันระบบเราจากการถูกรบกวน',
      category: '3 เสาหลัก',
    ),

    // การป้องกัน
    GlossaryTerm(
      term: 'EMCON',
      fullForm: 'Emission Control',
      definition: 'วินัยการงดแพร่กระจายคลื่น - การควบคุมการส่งสัญญาณเพื่อหลีกเลี่ยงการถูกตรวจจับ',
      category: 'การป้องกัน',
    ),
    GlossaryTerm(
      term: 'FHSS',
      fullForm: 'Frequency Hopping Spread Spectrum',
      definition: 'การกระโดดความถี่ - เปลี่ยนความถี่อย่างรวดเร็วเพื่อหลบการรบกวน',
      category: 'การป้องกัน',
    ),
    GlossaryTerm(
      term: 'COMSEC',
      fullForm: 'Communications Security',
      definition: 'ความปลอดภัยการสื่อสาร - การป้องกันข้อมูลการสื่อสาร',
      category: 'การป้องกัน',
    ),
    GlossaryTerm(
      term: 'TRANSEC',
      fullForm: 'Transmission Security',
      definition: 'ความปลอดภัยการส่ง - การป้องกันการดักรับสัญญาณ',
      category: 'การป้องกัน',
    ),

    // ECM
    GlossaryTerm(
      term: 'Jamming',
      definition: 'การรบกวนสัญญาณ - ส่งสัญญาณรบกวนเพื่อทำให้ข้าศึกใช้สัญญาณไม่ได้',
      category: 'ECM',
    ),
    GlossaryTerm(
      term: 'Spoofing',
      definition: 'การหลอกลวง - สร้างสัญญาณปลอมเพื่อหลอกระบบข้าศึก',
      category: 'ECM',
    ),
    GlossaryTerm(
      term: 'J/S Ratio',
      fullForm: 'Jamming to Signal Ratio',
      definition: 'อัตราส่วนกำลังรบกวนต่อกำลังสัญญาณ - ค่ายิ่งสูงยิ่ง Jam ได้ผล',
      category: 'ECM',
    ),

    // ข่าวกรอง
    GlossaryTerm(
      term: 'SIGINT',
      fullForm: 'Signals Intelligence',
      definition: 'ข่าวกรองสัญญาณ - การรวบรวมข่าวกรองจากสัญญาณต่างๆ',
      category: 'ข่าวกรอง',
    ),
    GlossaryTerm(
      term: 'COMINT',
      fullForm: 'Communications Intelligence',
      definition: 'ข่าวกรองการสื่อสาร - ข้อมูลจากการดักฟังการสื่อสาร',
      category: 'ข่าวกรอง',
    ),
    GlossaryTerm(
      term: 'ELINT',
      fullForm: 'Electronic Intelligence',
      definition: 'ข่าวกรองอิเล็กทรอนิกส์ - ข้อมูลจากเรดาร์และระบบอิเล็กทรอนิกส์',
      category: 'ข่าวกรอง',
    ),
    GlossaryTerm(
      term: 'DF',
      fullForm: 'Direction Finding',
      definition: 'การหาทิศทาง - การหาทิศทางของแหล่งกำเนิดสัญญาณ',
      category: 'ข่าวกรอง',
    ),

    // ยุทธวิธี
    GlossaryTerm(
      term: 'Kill Chain',
      definition: 'ห่วงโซ่การทำลายเป้าหมาย - กระบวนการตั้งแต่ตรวจจับจนถึงทำลาย',
      category: 'ยุทธวิธี',
    ),
    GlossaryTerm(
      term: 'EOB',
      fullForm: 'Electronic Order of Battle',
      definition: 'ลำดับข้าศึกทางอิเล็กทรอนิกส์ - ฐานข้อมูลระบบอิเล็กทรอนิกส์ของข้าศึก',
      category: 'ยุทธวิธี',
    ),
    GlossaryTerm(
      term: 'C-UAS',
      fullForm: 'Counter-Unmanned Aerial Systems',
      definition: 'การต่อต้านระบบอากาศยานไร้คนขับ - มาตรการต่อต้านโดรน',
      category: 'ยุทธวิธี',
    ),

    // ความถี่
    GlossaryTerm(
      term: 'HF',
      fullForm: 'High Frequency',
      definition: '3-30 MHz - สื่อสารระยะไกลโดยสะท้อนชั้นบรรยากาศ',
      category: 'ความถี่',
    ),
    GlossaryTerm(
      term: 'VHF',
      fullForm: 'Very High Frequency',
      definition: '30-300 MHz - วิทยุยุทธวิธีหลัก (Tactical Radio)',
      category: 'ความถี่',
    ),
    GlossaryTerm(
      term: 'UHF',
      fullForm: 'Ultra High Frequency',
      definition: '300 MHz - 3 GHz - Data Link, สื่อสารอากาศยาน',
      category: 'ความถี่',
    ),
    GlossaryTerm(
      term: 'SHF',
      fullForm: 'Super High Frequency',
      definition: '3-30 GHz - เรดาร์, ดาวเทียม, Microwave',
      category: 'ความถี่',
    ),
  ];

  /// Get terms by category
  static List<GlossaryTerm> getByCategory(String category) {
    return terms.where((t) => t.category == category).toList();
  }

  /// Get all categories
  static List<String> get categories {
    return terms.map((t) => t.category).toSet().toList();
  }

  /// Search terms
  static List<GlossaryTerm> search(String query) {
    final lowerQuery = query.toLowerCase();
    return terms.where((t) {
      return t.term.toLowerCase().contains(lowerQuery) ||
          t.definition.toLowerCase().contains(lowerQuery) ||
          (t.fullForm?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}

// ==========================================
// 8. STUDY SCENARIOS - สถานการณ์จำลอง
// ==========================================
class StudyScenario {
  final String id;
  final String title;
  final String situation;
  final List<String> questions;
  final List<String> hints;
  final Map<String, String> answers;
  final String difficulty;

  const StudyScenario({
    required this.id,
    required this.title,
    required this.situation,
    required this.questions,
    required this.hints,
    required this.answers,
    required this.difficulty,
  });
}

class EWStudyScenarios {
  static const List<StudyScenario> scenarios = [
    StudyScenario(
      id: 'scenario_1',
      title: 'โดรนถูก Jam',
      situation:
          'คุณกำลังควบคุมโดรน Recon\nGPS แสดงผล "NO SIGNAL"\nวิทยุควบคุมสูญเสียสัญญาณเป็นระยะๆ',
      questions: [
        'เกิดอะไรขึ้น?',
        'คุณควรทำอย่างไร?',
        'เทคนิค ECCM ใดที่ช่วยได้?',
      ],
      hints: [
        'สังเกตว่าสัญญาณหายหมดหรือแค่ผิดปกติ',
        'ถ้าหายหมดมักเป็น Jamming ถ้าผิดปกติอาจเป็น Spoofing',
        'FHSS และ Directional Antenna ช่วยลดผลกระทบได้',
      ],
      answers: {
        'q1': 'ถูก Jamming - สัญญาณหายหมดเป็นลักษณะของ Jamming',
        'q2': 'หยุดภารกิจ กลับฐาน หรือสลับเป็นโหมด Autonomous',
        'q3': 'Frequency Hopping (FHSS) และเสาอากาศทิศทาง (Directional Antenna)',
      },
      difficulty: 'กลาง',
    ),
    StudyScenario(
      id: 'scenario_2',
      title: 'GPS เพี้ยน',
      situation:
          'หน่วยของคุณเคลื่อนกำลังไปทางเหนือ\nแต่ GPS บอกว่ากำลังไปทางตะวันออก\nเข็มทิศและแผนที่กระดาษบอกว่ากำลังไปทางเหนือ',
      questions: [
        'เกิดอะไรขึ้น?',
        'ควรเชื่อ GPS หรือเข็มทิศ?',
        'นี่คือ Jamming หรือ Spoofing?',
      ],
      hints: [
        'เปรียบเทียบข้อมูลจากหลายแหล่ง',
        'เข็มทิศไม่ได้ใช้สัญญาณดาวเทียม',
        'Spoofing จะแสดงข้อมูลผิดแต่ยังมีสัญญาณ',
      ],
      answers: {
        'q1': 'ถูก GPS Spoofing - ส่งพิกัดปลอมทำให้แสดงตำแหน่งผิด',
        'q2': 'เชื่อเข็มทิศและแผนที่กระดาษ เพราะไม่ได้ใช้สัญญาณดาวเทียม',
        'q3': 'Spoofing - เพราะ GPS ยังทำงานแต่ข้อมูลผิด (Jamming จะไม่มีสัญญาณเลย)',
      },
      difficulty: 'กลาง',
    ),
    StudyScenario(
      id: 'scenario_3',
      title: 'การโจมตี EW',
      situation:
          'คุณเป็นผู้บังคับหน่วย Signals Intelligence\nตรวจพบสัญญาณเรดาร์ข้าศึกระยะ 15 กม.\nต้องวางแผนการโจมตีทาง EW',
      questions: [
        'ESM ควรทำอะไรก่อน?',
        'ควรใช้ ECM แบบไหน (Jamming/Spoofing)?',
        'มีความเสี่ยงอะไรบ้าง?',
      ],
      hints: [
        'ต้องรวบรวมข้อมูลก่อนโจมตี',
        'เลือกวิธีที่เหมาะกับเป้าหมาย',
        'การส่งสัญญาณ Jamming อาจเปิดเผยตำแหน่ง',
      ],
      answers: {
        'q1': 'วิเคราะห์คุณลักษณะสัญญาณ (ความถี่, PRF, กำลังส่ง) และหาพิกัดแน่นอน',
        'q2': 'Jamming - เพื่อบดบังการตรวจจับของเรดาร์ หรือ Spoofing ถ้าต้องการหลอกให้เห็นเป้าหมายปลอม',
        'q3': 'ความเสี่ยง: เปิดเผยตำแหน่งหน่วย Jammer, ข้าศึกอาจโจมตีตอบโต้, อาจรบกวนระบบฝ่ายเดียวกัน',
      },
      difficulty: 'สูง',
    ),
    StudyScenario(
      id: 'scenario_4',
      title: 'ทหารใช้มือถือในสนาม',
      situation:
          'คุณพบว่าทหารในหน่วยใช้มือถือส่วนตัวในพื้นที่ปฏิบัติการ\nกำลังโพสต์รูปและส่งข้อความหาครอบครัว',
      questions: [
        'มีความเสี่ยงอะไรบ้าง?',
        'ควรดำเนินการอย่างไร?',
        'EMCON ในกรณีนี้คืออะไร?',
      ],
      hints: [
        'มือถือส่งสัญญาณตลอดเวลา',
        'ข้าศึกมีเทคโนโลยีติดตามมือถือ',
        'EMCON คือการควบคุมการแพร่คลื่น',
      ],
      answers: {
        'q1': 'ความเสี่ยง: ถูกติดตามตำแหน่ง, ข้อมูลภารกิจรั่วไหล, ข้าศึกโจมตีด้วยอาวุธนำวิถี',
        'q2': 'ห้ามใช้มือถือทันที, เก็บในถุง Faraday, รายงานผู้บังคับบัญชา',
        'q3': 'EMCON = ห้ามส่งสัญญาณที่ไม่จำเป็น รวมถึงปิดมือถือส่วนตัว',
      },
      difficulty: 'พื้นฐาน',
    ),
  ];
}

// ==========================================
// 9. QUIZ QUESTIONS - คำถามเพิ่มเติม
// ==========================================
class EWQuizQuestion {
  final String id;
  final String question;
  final String? scenario;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String category;
  final String difficulty;

  const EWQuizQuestion({
    required this.id,
    required this.question,
    this.scenario,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.category = 'general',
    this.difficulty = 'medium',
  });
}

class EWQuizBank {
  // Basic Questions
  static const List<EWQuizQuestion> basicQuestions = [
    EWQuizQuestion(
      id: 'Q001',
      question: 'EW ย่อมาจากอะไร?',
      options: [
        'Electronic Warfare',
        'Electric War',
        'Energy Weapon',
        'Electronic Wave',
      ],
      correctAnswer: 0,
      explanation: 'EW = Electronic Warfare (สงครามอิเล็กทรอนิกส์)',
      category: 'พื้นฐาน',
      difficulty: 'easy',
    ),
    EWQuizQuestion(
      id: 'Q002',
      question: 'สเปกตรัมแม่เหล็กไฟฟ้าประกอบด้วยคลื่นใดบ้าง?',
      options: [
        'เฉพาะวิทยุและไมโครเวฟ',
        'ตั้งแต่วิทยุจนถึงรังสีแกมมา',
        'เฉพาะแสงที่มองเห็น',
        'เฉพาะอินฟราเรด',
      ],
      correctAnswer: 1,
      explanation: 'สเปกตรัมแม่เหล็กไฟฟ้ารวมทุกประเภทคลื่นตั้งแต่วิทยุจนถึงรังสีแกมมา',
      category: 'พื้นฐาน',
      difficulty: 'easy',
    ),
    EWQuizQuestion(
      id: 'Q003',
      question: '3 ภารกิจหลักของ EW คืออะไร?',
      options: [
        'ค้นหา รบกวน ทำลาย',
        'ควบคุม ลดทอน ป้องกัน',
        'ดักรับ วิเคราะห์ รายงาน',
        'โจมตี ป้องกัน ถอย',
      ],
      correctAnswer: 1,
      explanation: '3 ภารกิจหลัก: Control (ควบคุม), Degrade (ลดทอน), Protect (ป้องกัน)',
      category: 'พื้นฐาน',
      difficulty: 'easy',
    ),
    EWQuizQuestion(
      id: 'Q004',
      question: 'ESM มีกี่ขั้นตอน?',
      options: ['3 ขั้นตอน', '4 ขั้นตอน', '5 ขั้นตอน', '6 ขั้นตอน'],
      correctAnswer: 2,
      explanation: 'ESM มี 5 ขั้นตอน: ค้นหา ดักรับ ระบุตัวตน บันทึก วิเคราะห์',
      category: '3 เสาหลัก',
      difficulty: 'easy',
    ),
  ];

  // Intermediate Questions
  static const List<EWQuizQuestion> intermediateQuestions = [
    EWQuizQuestion(
      id: 'Q101',
      question: 'Jamming และ Spoofing ต่างกันอย่างไร?',
      options: [
        'Jamming = รบกวน, Spoofing = หลอกลวง',
        'Jamming = หลอกลวง, Spoofing = รบกวน',
        'เหมือนกัน',
        'ไม่มีข้อใดถูก',
      ],
      correctAnswer: 0,
      explanation: 'Jamming ทำให้ไม่มีสัญญาณ, Spoofing ส่งสัญญาณปลอม',
      category: 'ECM',
      difficulty: 'medium',
    ),
    EWQuizQuestion(
      id: 'Q102',
      question: 'Frequency Hopping ช่วยป้องกันอะไร?',
      options: [
        'การดักฟัง',
        'การรบกวน (Jamming)',
        'การสะท้อนคลื่น',
        'การลดทอนสัญญาณ',
      ],
      correctAnswer: 1,
      explanation:
          'Frequency Hopping กระโดดความถี่เร็วมาก ทำให้ Jammer ตามไม่ทันจึงรบกวนไม่ได้ผล',
      category: 'ECCM',
      difficulty: 'medium',
    ),
    EWQuizQuestion(
      id: 'Q103',
      question: 'โดรนพลเรือนส่วนใหญ่ใช้ความถี่ใดในการควบคุม?',
      options: [
        'HF (3-30 MHz)',
        'VHF (30-300 MHz)',
        '2.4 GHz',
        'SHF (30 GHz+)',
      ],
      correctAnswer: 2,
      explanation: 'โดรนพลเรือนส่วนใหญ่ใช้ 2.4 GHz (Wi-Fi band) สำหรับการควบคุม',
      category: 'Anti-Drone',
      difficulty: 'medium',
    ),
    EWQuizQuestion(
      id: 'Q104',
      question: 'EMCON หมายถึงอะไร?',
      options: [
        'Emergency Control',
        'Emission Control',
        'Electronic Counter',
        'Enemy Monitoring',
      ],
      correctAnswer: 1,
      explanation: 'EMCON = Emission Control วินัยการงดแพร่กระจายคลื่นเพื่อหลีกเลี่ยงการถูกตรวจจับ',
      category: 'การป้องกัน',
      difficulty: 'medium',
    ),
  ];

  // Scenario-Based Questions
  static const List<EWQuizQuestion> scenarioQuestions = [
    EWQuizQuestion(
      id: 'S001',
      scenario: 'โดรนของคุณแสดง GPS "NO SIGNAL" และวิทยุควบคุมขาดหาย',
      question: 'เกิดอะไรขึ้น?',
      options: [
        'ถูก Jamming',
        'ถูก Spoofing',
        'แบตเตอรี่หมด',
        'สภาพอากาศแย่',
      ],
      correctAnswer: 0,
      explanation: 'สัญญาณหายหมดคือลักษณะของ Jamming (ถ้า Spoofing จะยังมีสัญญาณแต่ข้อมูลผิด)',
      category: 'สถานการณ์',
      difficulty: 'medium',
    ),
    EWQuizQuestion(
      id: 'S002',
      scenario: 'GPS ทำงานปกติแต่แสดงตำแหน่งที่คุณไม่ได้อยู่ เข็มทิศบอกว่ากำลังไปทางเหนือแต่ GPS บอกไปทางตะวันออก',
      question: 'สิ่งที่เกิดขึ้นคืออะไร?',
      options: [
        'GPS เสีย',
        'ถูก GPS Jamming',
        'ถูก GPS Spoofing',
        'เข็มทิศเสีย',
      ],
      correctAnswer: 2,
      explanation:
          'GPS Spoofing ส่งสัญญาณปลอมทำให้แสดงตำแหน่งผิด แต่ยังทำงานปกติ (Jamming จะไม่มีสัญญาณเลย)',
      category: 'สถานการณ์',
      difficulty: 'medium',
    ),
    EWQuizQuestion(
      id: 'S003',
      scenario: 'คุณตรวจพบสัญญาณเรดาร์ข้าศึกที่ความถี่ 10 GHz ระยะ 20 กม.',
      question: 'ขั้นตอนแรกที่ควรทำคืออะไร?',
      options: [
        'Jam ทันที',
        'วิเคราะห์คุณลักษณะสัญญาณและหาพิกัด',
        'โจมตีด้วยอาวุธ',
        'ถอย',
      ],
      correctAnswer: 1,
      explanation: 'ต้องวิเคราะห์สัญญาณก่อน (ESM) เพื่อรู้ว่าคืออะไร อยู่ที่ไหน แล้วจึงวางแผนต่อ',
      category: 'สถานการณ์',
      difficulty: 'hard',
    ),
  ];

  // Advanced Questions
  static const List<EWQuizQuestion> advancedQuestions = [
    EWQuizQuestion(
      id: 'A001',
      question: 'ระบบ Borisoglebsk-2 ของรัสเซียมีขีดความสามารถหลักคืออะไร?',
      options: [
        'Jamming เฉพาะเรดาร์',
        'Jamming สัญญาณวิทยุและ GPS แบบครบวงจร',
        'Spoofing อย่างเดียว',
        'ดักฟังอย่างเดียว',
      ],
      correctAnswer: 1,
      explanation: 'Borisoglebsk-2 สามารถ Jam ได้ทั้งวิทยุ VHF/UHF และ GPS ในระยะ 100+ กม.',
      category: 'ระบบข้าศึก',
      difficulty: 'hard',
    ),
    EWQuizQuestion(
      id: 'A002',
      question: 'Kill Chain ในงาน EW มีกี่ขั้นตอน?',
      options: ['2 ขั้นตอน', '3 ขั้นตอน', '4 ขั้นตอน', '5 ขั้นตอน'],
      correctAnswer: 2,
      explanation:
          'Kill Chain มี 4 ขั้นตอน: Order of Battle → SIGINT → ESM → Targeting & Action',
      category: 'ยุทธวิธี',
      difficulty: 'hard',
    ),
    EWQuizQuestion(
      id: 'A003',
      question: 'ในสงครามยูเครน โดรนสูญเสียประมาณเท่าไรต่อเดือน?',
      options: [
        '1,000 ลำ',
        '5,000 ลำ',
        '10,000 ลำ',
        '20,000 ลำ',
      ],
      correctAnswer: 2,
      explanation: 'ตามรายงาน RUSI โดรนสูญเสียประมาณ 10,000 ลำต่อเดือน เนื่องจากระบบ EW ของรัสเซีย',
      category: 'กรณีศึกษา',
      difficulty: 'hard',
    ),
  ];

  /// Get all questions
  static List<EWQuizQuestion> get allQuestions {
    return [
      ...basicQuestions,
      ...intermediateQuestions,
      ...scenarioQuestions,
      ...advancedQuestions,
    ];
  }

  /// Get questions by difficulty
  static List<EWQuizQuestion> getByDifficulty(String difficulty) {
    return allQuestions.where((q) => q.difficulty == difficulty).toList();
  }

  /// Get questions by category
  static List<EWQuizQuestion> getByCategory(String category) {
    return allQuestions.where((q) => q.category == category).toList();
  }

  /// Get random questions
  static List<EWQuizQuestion> getRandomQuestions(int count) {
    final questions = List<EWQuizQuestion>.from(allQuestions);
    questions.shuffle();
    return questions.take(count).toList();
  }
}

// ==========================================
// 10. CASE STUDY DATA - ข้อมูลกรณีศึกษา
// ==========================================
class UkraineDroneWarData {
  static const Map<String, dynamic> statistics = {
    'dronesLostPerMonth': 10000,
    'source': 'RUSI Report',
    'ewStationsSpacing': '10 km',
  };

  static const List<String> lessons = [
    'รัสเซียสร้างกำแพงอิเล็กทรอนิกส์ตลอดแนวหน้า',
    'โดรนที่ควบคุมระยะไกลล้มเหลวเป็นส่วนใหญ่',
    'ต้องใช้โดรนที่ไม่ต้องพึ่ง GPS (Autonomous)',
    'FPV drone อายุใช้งานเฉลี่ยแค่ 3 วัน',
    'ความถี่ 2.4 GHz ถูก Jam ได้ง่ายที่สุด',
  ];

  static const List<String> countermeasures = [
    'พัฒนาโดรนนำทางด้วย AI (Visual Navigation)',
    'ใช้ระบบนำทางเฉื่อย (INS) ร่วมด้วย',
    'พัฒนาความถี่ที่ทนการรบกวนมากขึ้น',
    'ใช้ยุทธวิธีโดรนฝูง (Swarm) ให้ยากต่อการ Jam',
  ];
}