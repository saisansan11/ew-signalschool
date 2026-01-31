import 'package:flutter/material.dart';

/// โครงสร้างหน่วยทหารสื่อสาร กองทัพบก (ข้อมูลครบถ้วน)
/// Royal Thai Army Signal Corps Organization

class RTASignalCorps {
  // =============================================
  // หน่วยทหารสื่อสาร ส่วนกลาง
  // =============================================

  static const List<SignalUnit> centralUnits = [
    // กรมการทหารสื่อสาร
    SignalUnit(
      id: 'signal_dept',
      name: 'กรมการทหารสื่อสาร',
      nameEn: 'Signal Department',
      abbreviation: 'กส.',
      level: UnitLevel.department,
      parentId: null,
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8191,
        longitude: 100.5150,
      ),
      commanderRank: 'พลโท',
      description: 'เป็นหน่วยขึ้นตรงกองทัพบก รับผิดชอบงานสื่อสารทั้งปวงของกองทัพบก',
      missions: [
        'วางแผน อำนวยการ ประสานงาน กำกับการ และดำเนินการด้านการสื่อสาร',
        'พัฒนาระบบสื่อสารและสารสนเทศของกองทัพบก',
        'ผลิต จัดหา ซ่อมบำรุงยุทโธปกรณ์สายสื่อสาร',
        'ฝึกศึกษาบุคลากรด้านการสื่อสาร',
        'ดำเนินการด้านสงครามอิเล็กทรอนิกส์',
      ],
      childUnitIds: ['signal_center', 'signal_school', 'signal_factory', 'signal_bn1', 'signal_bn2'],
      color: Color(0xFFFF9500),
    ),

    // ศูนย์การสื่อสาร กส.
    SignalUnit(
      id: 'signal_center',
      name: 'ศูนย์การสื่อสาร',
      nameEn: 'Signal Center',
      abbreviation: 'ศส.กส.',
      level: UnitLevel.center,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8191,
        longitude: 100.5150,
      ),
      commanderRank: 'พันเอก',
      description: 'ศูนย์ควบคุมและปฏิบัติการสื่อสารหลักของกองทัพบก',
      missions: [
        'ควบคุมการสื่อสารของกองทัพบก',
        'ดำเนินการระบบสื่อสารดาวเทียมทหาร',
        'ดำเนินการระบบโทรคมนาคมทหาร',
        'บริการข่ายสื่อสารทางทหาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // โรงเรียนทหารสื่อสาร
    SignalUnit(
      id: 'signal_school',
      name: 'โรงเรียนทหารสื่อสาร',
      nameEn: 'Signal School',
      abbreviation: 'รร.ส.สส.',
      level: UnitLevel.school,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8185,
        longitude: 100.5145,
      ),
      commanderRank: 'พลตรี',
      description: 'สถาบันการศึกษาและฝึกอบรมด้านการสื่อสารทหารบก',
      missions: [
        'ผลิตนายทหารสื่อสาร (หลักสูตรชั้นนายร้อย-นายพัน)',
        'อบรมหลักสูตรเฉพาะทางด้านการสื่อสาร',
        'วิจัยและพัฒนาด้านการสื่อสารทหาร',
        'เป็นศูนย์กลางความรู้ด้านการสื่อสาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองโรงงานซ่อมสร้างเครื่องสื่อสาร
    SignalUnit(
      id: 'signal_factory',
      name: 'กองโรงงานซ่อมสร้างเครื่องสื่อสาร',
      nameEn: 'Signal Equipment Factory',
      abbreviation: 'กรส.กส.',
      level: UnitLevel.factory,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8195,
        longitude: 100.5155,
      ),
      commanderRank: 'พันเอก',
      description: 'หน่วยซ่อมสร้างและผลิตอุปกรณ์สื่อสาร',
      missions: [
        'ซ่อมบำรุงยุทโธปกรณ์สายสื่อสารขั้นคลัง',
        'ผลิตอุปกรณ์สื่อสาร',
        'ดัดแปลง ปรับปรุงอุปกรณ์สื่อสาร',
        'ทดสอบและควบคุมคุณภาพ',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองพันทหารสื่อสารที่ 1
    SignalUnit(
      id: 'signal_bn1',
      name: 'กองพันทหารสื่อสารที่ 1',
      nameEn: '1st Signal Battalion',
      abbreviation: 'พัน.ส.1',
      level: UnitLevel.battalion,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8188,
        longitude: 100.5148,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารสนับสนุนส่วนกลาง',
      missions: [
        'สนับสนุนการสื่อสารให้ บก.ทบ.',
        'ดำเนินการสื่อสารในพื้นที่ส่วนกลาง',
        'สนับสนุนการฝึกและพิธีการต่างๆ',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      color: Color(0xFFFF9500),
    ),

    // กองพันทหารสื่อสารที่ 2
    SignalUnit(
      id: 'signal_bn2',
      name: 'กองพันทหารสื่อสารที่ 2',
      nameEn: '2nd Signal Battalion',
      abbreviation: 'พัน.ส.2',
      level: UnitLevel.battalion,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8190,
        longitude: 100.5152,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารสำรองและสนับสนุน',
      missions: [
        'สนับสนุนการสื่อสารสำรอง',
        'สนับสนุนการฝึกศึกษา',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      color: Color(0xFFFF9500),
    ),
  ];

  // =============================================
  // หน่วยสื่อสารประจำกองทัพภาค
  // =============================================

  static const List<SignalUnit> armyAreaUnits = [
    // กองทัพภาคที่ 1 (ภาคกลาง/ภาคตะวันออก)
    SignalUnit(
      id: 'signal_1st_army',
      name: 'กองพันทหารสื่อสารที่ 1 รักษาพระองค์',
      nameEn: '1st Signal Battalion, King\'s Guard',
      abbreviation: 'พัน.ส.1 รอ.',
      level: UnitLevel.battalion,
      parentId: '1st_army_area',
      location: UnitLocation(
        name: 'ค่ายจักรพงษ์',
        province: 'ปราจีนบุรี',
        district: 'เมืองปราจีนบุรี',
        latitude: 14.0579,
        longitude: 101.3731,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองทัพภาคที่ 1',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.1',
        'ปฏิบัติการสื่อสารในพื้นที่ภาคกลางและภาคตะวันออก',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 1,
      color: Color(0xFF4CAF50),
    ),

    // กองทัพภาคที่ 2 (ภาคตะวันออกเฉียงเหนือ)
    SignalUnit(
      id: 'signal_2nd_army',
      name: 'กองพันทหารสื่อสารที่ 2',
      nameEn: '2nd Area Signal Battalion',
      abbreviation: 'พัน.ส.ทภ.2',
      level: UnitLevel.battalion,
      parentId: '2nd_army_area',
      location: UnitLocation(
        name: 'ค่ายสุรนารี',
        province: 'นครราชสีมา',
        district: 'เมืองนครราชสีมา',
        latitude: 14.9707,
        longitude: 102.1018,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองทัพภาคที่ 2',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.2',
        'ปฏิบัติการสื่อสารในพื้นที่ภาคตะวันออกเฉียงเหนือ',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 2,
      color: Color(0xFF2196F3),
    ),

    // กองทัพภาคที่ 3 (ภาคเหนือ)
    SignalUnit(
      id: 'signal_3rd_army',
      name: 'กองพันทหารสื่อสารที่ 3',
      nameEn: '3rd Area Signal Battalion',
      abbreviation: 'พัน.ส.ทภ.3',
      level: UnitLevel.battalion,
      parentId: '3rd_army_area',
      location: UnitLocation(
        name: 'ค่ายสมเด็จพระนเรศวรมหาราช',
        province: 'พิษณุโลก',
        district: 'เมืองพิษณุโลก',
        latitude: 16.8211,
        longitude: 100.2659,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองทัพภาคที่ 3',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.3',
        'ปฏิบัติการสื่อสารในพื้นที่ภาคเหนือ',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 3,
      color: Color(0xFFFF9800),
    ),

    // กองทัพภาคที่ 4 (ภาคใต้)
    SignalUnit(
      id: 'signal_4th_army',
      name: 'กองพันทหารสื่อสารที่ 4',
      nameEn: '4th Area Signal Battalion',
      abbreviation: 'พัน.ส.ทภ.4',
      level: UnitLevel.battalion,
      parentId: '4th_army_area',
      location: UnitLocation(
        name: 'ค่ายวชิราวุธ',
        province: 'นครศรีธรรมราช',
        district: 'เมืองนครศรีธรรมราช',
        latitude: 8.4304,
        longitude: 99.9632,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองทัพภาคที่ 4',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.4',
        'ปฏิบัติการสื่อสารในพื้นที่ภาคใต้',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 4,
      color: Color(0xFFE91E63),
    ),
  ];

  // =============================================
  // หน่วยสื่อสารประจำกองพล
  // =============================================

  static const List<SignalUnit> divisionUnits = [
    // พล.ร.2 รอ.
    SignalUnit(
      id: 'signal_2nd_div',
      name: 'กองพันทหารสื่อสาร พลร.2 รอ.',
      nameEn: '2nd Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.2 รอ.',
      level: UnitLevel.battalion,
      parentId: '2nd_infantry_div',
      location: UnitLocation(
        name: 'ค่ายพรหมโยธี',
        province: 'ปราจีนบุรี',
        district: 'เมืองปราจีนบุรี',
        latitude: 14.0500,
        longitude: 101.3700,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 2 รักษาพระองค์',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.2 รอ.'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.3
    SignalUnit(
      id: 'signal_3rd_div',
      name: 'กองพันทหารสื่อสาร พลร.3',
      nameEn: '3rd Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.3',
      level: UnitLevel.battalion,
      parentId: '3rd_infantry_div',
      location: UnitLocation(
        name: 'ค่ายสุรนารี',
        province: 'นครราชสีมา',
        district: 'เมืองนครราชสีมา',
        latitude: 14.9650,
        longitude: 102.0950,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 3',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.3'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.4
    SignalUnit(
      id: 'signal_4th_div',
      name: 'กองพันทหารสื่อสาร พลร.4',
      nameEn: '4th Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.4',
      level: UnitLevel.battalion,
      parentId: '4th_infantry_div',
      location: UnitLocation(
        name: 'ค่ายสมเด็จพระนเรศวรมหาราช',
        province: 'พิษณุโลก',
        district: 'เมืองพิษณุโลก',
        latitude: 16.8150,
        longitude: 100.2600,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 4',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.4'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.5
    SignalUnit(
      id: 'signal_5th_div',
      name: 'กองพันทหารสื่อสาร พลร.5',
      nameEn: '5th Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.5',
      level: UnitLevel.battalion,
      parentId: '5th_infantry_div',
      location: UnitLocation(
        name: 'ค่ายเทพสตรีศรีสุนทร',
        province: 'ลพบุรี',
        district: 'เมืองลพบุรี',
        latitude: 14.8000,
        longitude: 100.6200,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 5',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.5'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.6
    SignalUnit(
      id: 'signal_6th_div',
      name: 'กองพันทหารสื่อสาร พลร.6',
      nameEn: '6th Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.6',
      level: UnitLevel.battalion,
      parentId: '6th_infantry_div',
      location: UnitLocation(
        name: 'ค่ายสรรพสิทธิประสงค์',
        province: 'อุบลราชธานี',
        district: 'วารินชำราบ',
        latitude: 15.2000,
        longitude: 104.8700,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 6',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.6'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.9
    SignalUnit(
      id: 'signal_9th_div',
      name: 'กองพันทหารสื่อสาร พลร.9',
      nameEn: '9th Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.9',
      level: UnitLevel.battalion,
      parentId: '9th_infantry_div',
      location: UnitLocation(
        name: 'ค่ายสุรสีห์',
        province: 'กาญจนบุรี',
        district: 'เมืองกาญจนบุรี',
        latitude: 14.0200,
        longitude: 99.5300,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 9',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.9'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),

    // พล.ร.15
    SignalUnit(
      id: 'signal_15th_div',
      name: 'กองพันทหารสื่อสาร พลร.15',
      nameEn: '15th Infantry Division Signal Battalion',
      abbreviation: 'พัน.ส.พล.ร.15',
      level: UnitLevel.battalion,
      parentId: '15th_infantry_div',
      location: UnitLocation(
        name: 'ค่ายวชิราวุธ',
        province: 'นครศรีธรรมราช',
        district: 'เมืองนครศรีธรรมราช',
        latitude: 8.4250,
        longitude: 99.9580,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารประจำกองพลทหารราบที่ 15',
      missions: ['สนับสนุนการสื่อสารให้ พล.ร.15'],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 350,
      color: Color(0xFF9C27B0),
    ),
  ];

  // =============================================
  // หน่วยสื่อสารพิเศษ
  // =============================================

  static const List<SignalUnit> specialUnits = [
    // ศูนย์สงครามอิเล็กทรอนิกส์
    SignalUnit(
      id: 'ew_center',
      name: 'ศูนย์สงครามอิเล็กทรอนิกส์',
      nameEn: 'Electronic Warfare Center',
      abbreviation: 'ศสอ.',
      level: UnitLevel.center,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8192,
        longitude: 100.5151,
      ),
      commanderRank: 'พันเอก',
      description: 'ศูนย์ปฏิบัติการสงครามอิเล็กทรอนิกส์ของกองทัพบก',
      missions: [
        'วางแผนและปฏิบัติการสงครามอิเล็กทรอนิกส์',
        'ดำเนินการ ESM/ECM/ECCM',
        'วิเคราะห์และข่าวกรองสัญญาณ',
        'ฝึกอบรมด้านสงครามอิเล็กทรอนิกส์',
      ],
      childUnitIds: [],
      color: Color(0xFFFF5722),
    ),
  ];

  /// Get all units combined
  static List<SignalUnit> get allUnits => [
    ...centralUnits,
    ...specialUnits,
  ];

  static List<SignalUnit> get allCombinedUnits => [
    ...centralUnits,
    ...armyAreaUnits,
    ...divisionUnits,
    ...specialUnits,
  ];

  /// Get unit by ID
  static SignalUnit? getUnitById(String id) {
    try {
      return allCombinedUnits.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get child units
  static List<SignalUnit> getChildUnits(String parentId) {
    return allCombinedUnits.where((u) => u.parentId == parentId).toList();
  }

  /// Get units by level
  static List<SignalUnit> getUnitsByLevel(UnitLevel level) {
    return allCombinedUnits.where((u) => u.level == level).toList();
  }

  /// Get root unit (Signal Department)
  static SignalUnit get rootUnit => centralUnits.first;

  /// Get units for map display (main units only)
  static List<SignalUnit> get mapDisplayUnits => [
    ...centralUnits.where((u) => u.level == UnitLevel.department),
    ...armyAreaUnits,
    ...divisionUnits,
  ];
}

// =============================================
// Models
// =============================================

/// ระดับหน่วย
enum UnitLevel {
  department,  // กรม
  center,      // ศูนย์
  school,      // โรงเรียน
  factory,     // กองโรงงาน
  battalion,   // กองพัน
  company,     // กองร้อย
  platoon,     // หมวด
  squad,       // หมู่
}

extension UnitLevelExtension on UnitLevel {
  String get thaiName {
    switch (this) {
      case UnitLevel.department:
        return 'กรม';
      case UnitLevel.center:
        return 'ศูนย์';
      case UnitLevel.school:
        return 'โรงเรียน';
      case UnitLevel.factory:
        return 'กองโรงงาน';
      case UnitLevel.battalion:
        return 'กองพัน';
      case UnitLevel.company:
        return 'กองร้อย';
      case UnitLevel.platoon:
        return 'หมวด';
      case UnitLevel.squad:
        return 'หมู่';
    }
  }

  String get symbol {
    switch (this) {
      case UnitLevel.department:
        return '|||';
      case UnitLevel.center:
        return '◆';
      case UnitLevel.school:
        return '🎓';
      case UnitLevel.factory:
        return '🏭';
      case UnitLevel.battalion:
        return '||';
      case UnitLevel.company:
        return '|';
      case UnitLevel.platoon:
        return '••';
      case UnitLevel.squad:
        return '•';
    }
  }

  int get sortOrder {
    switch (this) {
      case UnitLevel.department:
        return 0;
      case UnitLevel.center:
        return 1;
      case UnitLevel.school:
        return 1;
      case UnitLevel.factory:
        return 1;
      case UnitLevel.battalion:
        return 2;
      case UnitLevel.company:
        return 3;
      case UnitLevel.platoon:
        return 4;
      case UnitLevel.squad:
        return 5;
    }
  }
}

/// ที่ตั้งหน่วย
class UnitLocation {
  final String name;
  final String province;
  final String district;
  final double latitude;
  final double longitude;

  const UnitLocation({
    required this.name,
    required this.province,
    required this.district,
    required this.latitude,
    required this.longitude,
  });

  String get fullAddress => '$name, $district, $province';
}

/// หน่วยทหารสื่อสาร
class SignalUnit {
  final String id;
  final String name;
  final String nameEn;
  final String abbreviation;
  final UnitLevel level;
  final String? parentId;
  final UnitLocation location;
  final String commanderRank;
  final String description;
  final List<String> missions;
  final List<String> childUnitIds;
  final int? personnelMin;
  final int? personnelMax;
  final int? armyArea;
  final Color color;

  const SignalUnit({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.abbreviation,
    required this.level,
    this.parentId,
    required this.location,
    required this.commanderRank,
    required this.description,
    required this.missions,
    required this.childUnitIds,
    this.personnelMin,
    this.personnelMax,
    this.armyArea,
    required this.color,
  });

  String get personnelRange {
    if (personnelMin != null && personnelMax != null) {
      return '$personnelMin - $personnelMax นาย';
    }
    return '-';
  }
}
