import 'package:flutter/material.dart';

/// โครงสร้างหน่วยทหารสื่อสาร กองทัพบก
/// Royal Thai Army Signal Corps Organization
/// อ้างอิง: เว็บไซต์ signal.rta.mi.th, signalschool.ac.th, และ rta.mi.th
/// ปรับปรุงข้อมูล: 2567

class RTASignalCorps {
  // =============================================
  // หน่วยทหารสื่อสาร ส่วนกลาง (กรมการทหารสื่อสาร)
  // =============================================

  static const List<SignalUnit> centralUnits = [
    // กรมการทหารสื่อสาร
    SignalUnit(
      id: 'signal_dept',
      name: 'กรมการทหารสื่อสาร',
      nameEn: 'Signal Department',
      abbreviation: 'สส.',
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
      description: 'เป็นหน่วยขึ้นตรงกองทัพบก (นขต.ทบ.) รับผิดชอบงานสื่อสารทั้งปวงของกองทัพบก',
      missions: [
        'วางแผน อำนวยการ ประสานงาน กำกับการ และดำเนินการด้านการสื่อสาร',
        'พัฒนาระบบสื่อสารและสารสนเทศของกองทัพบก',
        'ผลิต จัดหา ซ่อมบำรุงยุทโธปกรณ์สายสื่อสาร',
        'ฝึกศึกษาบุคลากรด้านการสื่อสาร',
        'ดำเนินการด้านสงครามอิเล็กทรอนิกส์',
      ],
      childUnitIds: ['signal_center', 'signal_school', 'signal_factory', 'ew_center', 'signal_regiment_1', 'signal_maint_bn'],
      color: Color(0xFFFF9500),
    ),

    // ศูนย์การสื่อสาร สส.
    SignalUnit(
      id: 'signal_center',
      name: 'ศูนย์การสื่อสาร',
      nameEn: 'Signal Center',
      abbreviation: 'ศส.สส.',
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
      childUnitIds: ['signal_center_hq', 'signal_center_ops', 'signal_center_tech'],
      color: Color(0xFFFF9500),
    ),

    // กองบังคับการ ศส.สส.
    SignalUnit(
      id: 'signal_center_hq',
      name: 'กองบังคับการ',
      nameEn: 'Headquarters',
      abbreviation: 'บก.ศส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8191,
        longitude: 100.5150,
      ),
      commanderRank: 'พันโท',
      description: 'กองบังคับการศูนย์การสื่อสาร ดำเนินการด้านธุรการและกำลังพล',
      missions: [
        'ดำเนินการด้านกำลังพลให้แก่ศูนย์การสื่อสาร',
        'ดำเนินการด้านธุรการ การเงิน และส่งกำลังบำรุง',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองปฏิบัติการ ศส.สส.
    SignalUnit(
      id: 'signal_center_ops',
      name: 'กองปฏิบัติการ',
      nameEn: 'Operations Division',
      abbreviation: 'กปก.ศส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8191,
        longitude: 100.5150,
      ),
      commanderRank: 'พันโท',
      description: 'กองปฏิบัติการศูนย์การสื่อสาร ดำเนินการควบคุมและปฏิบัติการสื่อสาร',
      missions: [
        'ควบคุมการสื่อสารของกองทัพบก',
        'ดำเนินการระบบสื่อสารดาวเทียมและโทรคมนาคมทหาร',
        'บริการข่ายสื่อสารทางทหาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองเทคนิค ศส.สส.
    SignalUnit(
      id: 'signal_center_tech',
      name: 'กองเทคนิค',
      nameEn: 'Technical Division',
      abbreviation: 'กทค.ศส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8191,
        longitude: 100.5150,
      ),
      commanderRank: 'พันโท',
      description: 'กองเทคนิคศูนย์การสื่อสาร ดำเนินการด้านเทคนิคและซ่อมบำรุงระบบสื่อสาร',
      missions: [
        'ดำเนินการด้านเทคนิคระบบสื่อสาร',
        'ซ่อมบำรุงอุปกรณ์สื่อสาร',
        'พัฒนาและปรับปรุงระบบสื่อสาร',
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
      childUnitIds: ['school_hq', 'school_edu', 'school_cadet_bn'],
      color: Color(0xFFFF9500),
    ),

    // กองบังคับการ รร.ส.สส.
    SignalUnit(
      id: 'school_hq',
      name: 'กองบังคับการ',
      nameEn: 'Headquarters Division',
      abbreviation: 'บก.รร.ส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_school',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8185,
        longitude: 100.5145,
      ),
      commanderRank: 'พันเอก',
      description: 'กองบังคับการโรงเรียนทหารสื่อสาร รับผิดชอบงานธุรการ กำลังพล และการวางแผนการศึกษา',
      missions: [
        'ดำเนินการด้านกำลังพลให้แก่โรงเรียนทหารสื่อสาร',
        'ดำเนินการเกี่ยวกับแผนการศึกษา ประสานงาน กำหนดตารางฝึกศึกษา',
        'ดำเนินการด้านการสนับสนุนกิจกรรมต่างๆ สิ่งอุปกรณ์ อาคารที่ใช้สำหรับการเรียนการสอน',
        'ดำเนินการด้านการประเมินผลการศึกษา ใบประกาศนียบัตร ติดตามผลการประเมินหลักสูตร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองการศึกษา รร.ส.สส.
    SignalUnit(
      id: 'school_edu',
      name: 'กองการศึกษา',
      nameEn: 'Education Division',
      abbreviation: 'กศ.รร.ส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_school',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8185,
        longitude: 100.5145,
      ),
      commanderRank: 'พันเอก',
      description: 'กองการศึกษาโรงเรียนทหารสื่อสาร รับผิดชอบการจัดการเรียนการสอนด้านเทคโนโลยีสารสนเทศและการสื่อสาร',
      missions: [
        'ดำเนินการจัดการเรียนการสอนตามหลักสูตรต่างๆ',
        'พัฒนาหลักสูตรและจัดการเรียนการสอนให้ทันสมัย',
        'พัฒนาครูอาจารย์และบุคลากรทางการศึกษา',
        'วิจัยและพัฒนาด้านการศึกษาทางทหาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองพันนักเรียน รร.ส.สส.
    SignalUnit(
      id: 'school_cadet_bn',
      name: 'กองพันนักเรียน',
      nameEn: 'Cadet Battalion',
      abbreviation: 'พัน.นร.รร.ส.สส.',
      level: UnitLevel.battalion,
      parentId: 'signal_school',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8185,
        longitude: 100.5145,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันนักเรียนโรงเรียนทหารสื่อสาร รับผิดชอบการฝึกศึกษาทางยุทธวิธีและกำกับดูแลนักเรียน',
      missions: [
        'ดำเนินการด้านการฝึกศึกษาทางยุทธวิธีให้กับนักเรียนนายสิบ',
        'กำกับดูแลนายทหารนักเรียนและนายสิบนักเรียนระหว่างการศึกษา',
        'ฝึกความเป็นผู้นำและวินัยทหาร',
        'สนับสนุนกิจกรรมนักเรียนทหารสื่อสาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองโรงงานซ่อมสร้างเครื่องสื่อสาร
    SignalUnit(
      id: 'signal_factory',
      name: 'กองโรงงานซ่อมสร้างเครื่องสื่อสาร',
      nameEn: 'Signal Equipment Factory',
      abbreviation: 'กรส.สส.',
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
      childUnitIds: ['factory_hq', 'factory_repair', 'factory_production'],
      color: Color(0xFFFF9500),
    ),

    // กองบังคับการ กรส.สส.
    SignalUnit(
      id: 'factory_hq',
      name: 'กองบังคับการ',
      nameEn: 'Headquarters',
      abbreviation: 'บก.กรส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_factory',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8195,
        longitude: 100.5155,
      ),
      commanderRank: 'พันโท',
      description: 'กองบังคับการกองโรงงาน ดำเนินการด้านธุรการและกำลังพล',
      missions: [
        'ดำเนินการด้านกำลังพลให้แก่กองโรงงาน',
        'ดำเนินการด้านธุรการ การเงิน และส่งกำลังบำรุง',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองซ่อม กรส.สส.
    SignalUnit(
      id: 'factory_repair',
      name: 'กองซ่อม',
      nameEn: 'Repair Division',
      abbreviation: 'กซ.กรส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_factory',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8195,
        longitude: 100.5155,
      ),
      commanderRank: 'พันโท',
      description: 'กองซ่อม ดำเนินการซ่อมบำรุงยุทโธปกรณ์สายสื่อสาร',
      missions: [
        'ซ่อมบำรุงยุทโธปกรณ์สายสื่อสารขั้นคลัง',
        'ดัดแปลง ปรับปรุงอุปกรณ์สื่อสาร',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // กองผลิต กรส.สส.
    SignalUnit(
      id: 'factory_production',
      name: 'กองผลิต',
      nameEn: 'Production Division',
      abbreviation: 'กผ.กรส.สส.',
      level: UnitLevel.company,
      parentId: 'signal_factory',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8195,
        longitude: 100.5155,
      ),
      commanderRank: 'พันโท',
      description: 'กองผลิต ดำเนินการผลิตอุปกรณ์สื่อสาร',
      missions: [
        'ผลิตอุปกรณ์สื่อสาร',
        'ทดสอบและควบคุมคุณภาพ',
      ],
      childUnitIds: [],
      color: Color(0xFFFF9500),
    ),

    // ศูนย์สงครามอิเล็กทรอนิกส์
    SignalUnit(
      id: 'ew_center',
      name: 'ศูนย์สงครามอิเล็กทรอนิกส์',
      nameEn: 'Electronic Warfare Center',
      abbreviation: 'ศสอ.สส.',
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
      childUnitIds: ['ew_center_hq', 'ew_center_ops', 'ew_center_intel'],
      color: Color(0xFFFF5722),
    ),

    // กองบังคับการ ศสอ.สส.
    SignalUnit(
      id: 'ew_center_hq',
      name: 'กองบังคับการ',
      nameEn: 'Headquarters',
      abbreviation: 'บก.ศสอ.สส.',
      level: UnitLevel.company,
      parentId: 'ew_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8192,
        longitude: 100.5151,
      ),
      commanderRank: 'พันโท',
      description: 'กองบังคับการศูนย์สงครามอิเล็กทรอนิกส์ ดำเนินการด้านธุรการและกำลังพล',
      missions: [
        'ดำเนินการด้านกำลังพลให้แก่ศูนย์สงครามอิเล็กทรอนิกส์',
        'ดำเนินการด้านธุรการ การเงิน และส่งกำลังบำรุง',
      ],
      childUnitIds: [],
      color: Color(0xFFFF5722),
    ),

    // กองปฏิบัติการ ศสอ.สส.
    SignalUnit(
      id: 'ew_center_ops',
      name: 'กองปฏิบัติการ',
      nameEn: 'Operations Division',
      abbreviation: 'กปก.ศสอ.สส.',
      level: UnitLevel.company,
      parentId: 'ew_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8192,
        longitude: 100.5151,
      ),
      commanderRank: 'พันโท',
      description: 'กองปฏิบัติการ ดำเนินการปฏิบัติการสงครามอิเล็กทรอนิกส์',
      missions: [
        'ดำเนินการ ESM/ECM/ECCM',
        'ปฏิบัติการสงครามอิเล็กทรอนิกส์',
        'ฝึกอบรมด้านสงครามอิเล็กทรอนิกส์',
      ],
      childUnitIds: [],
      color: Color(0xFFFF5722),
    ),

    // กองข่าวกรองสัญญาณ ศสอ.สส.
    SignalUnit(
      id: 'ew_center_intel',
      name: 'กองข่าวกรองสัญญาณ',
      nameEn: 'Signal Intelligence Division',
      abbreviation: 'กขส.ศสอ.สส.',
      level: UnitLevel.company,
      parentId: 'ew_center',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8192,
        longitude: 100.5151,
      ),
      commanderRank: 'พันโท',
      description: 'กองข่าวกรองสัญญาณ ดำเนินการวิเคราะห์และข่าวกรองสัญญาณ',
      missions: [
        'วิเคราะห์และข่าวกรองสัญญาณ',
        'รวบรวมและประมวลผลข่าวสารสัญญาณ',
      ],
      childUnitIds: [],
      color: Color(0xFFFF5722),
    ),

    // กรมทหารสื่อสารที่ 1 (สส.1)
    // ที่ตั้ง: ค่ายกำแพงเพชรอัครโยธิน ตำบลสวนหลวง อำเภอกระทุ่มแบน จังหวัดสมุทรสาคร
    SignalUnit(
      id: 'signal_regiment_1',
      name: 'กรมทหารสื่อสารที่ 1',
      nameEn: '1st Signal Regiment',
      abbreviation: 'สส.1',
      level: UnitLevel.department,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'ค่ายกำแพงเพชรอัครโยธิน',
        province: 'สมุทรสาคร',
        district: 'กระทุ่มแบน',
        latitude: 13.6533,
        longitude: 100.2597,
      ),
      commanderRank: 'พันเอก',
      description: 'กรมทหารสื่อสารที่ 1 เป็นหน่วยสื่อสารระดับกรม สนับสนุนการปฏิบัติการของกองทัพบก',
      missions: [
        'สนับสนุนการสื่อสารให้กับหน่วยทหารในพื้นที่รับผิดชอบ',
        'ฝึกทหารใหม่สายทหารสื่อสาร',
        'ซ่อมบำรุงอุปกรณ์สื่อสาร',
        'สนับสนุนการฝึกและการศึกษาทางทหาร',
      ],
      childUnitIds: ['signal_bn_101', 'signal_bn_102'],
      color: Color(0xFFFF9500),
    ),

    // กองพันทหารสื่อสารที่ 101 กรมทหารสื่อสารที่ 1
    SignalUnit(
      id: 'signal_bn_101',
      name: 'กองพันทหารสื่อสารที่ 101',
      nameEn: '101st Signal Battalion',
      abbreviation: 'ส.พัน.101',
      level: UnitLevel.battalion,
      parentId: 'signal_regiment_1',
      location: UnitLocation(
        name: 'ค่ายกำแพงเพชรอัครโยธิน',
        province: 'สมุทรสาคร',
        district: 'กระทุ่มแบน',
        latitude: 13.6533,
        longitude: 100.2597,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 101 กรมทหารสื่อสารที่ 1',
      missions: ['สนับสนุนการสื่อสารและฝึกทหารใหม่'],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      color: Color(0xFFFF9500),
    ),

    // กองพันทหารสื่อสารที่ 102 กรมทหารสื่อสารที่ 1
    SignalUnit(
      id: 'signal_bn_102',
      name: 'กองพันทหารสื่อสารที่ 102',
      nameEn: '102nd Signal Battalion',
      abbreviation: 'ส.พัน.102',
      level: UnitLevel.battalion,
      parentId: 'signal_regiment_1',
      location: UnitLocation(
        name: 'ค่ายกำแพงเพชรอัครโยธิน',
        province: 'สมุทรสาคร',
        district: 'กระทุ่มแบน',
        latitude: 13.6533,
        longitude: 100.2597,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 102 กรมทหารสื่อสารที่ 1',
      missions: ['สนับสนุนการสื่อสารและฝึกทหารใหม่'],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      color: Color(0xFFFF9500),
    ),

    // กองพันสื่อสารซ่อมบำรุงเขตหลัง (พัน.ส.ซบร.)
    // ที่ตั้ง: สะพานแดง แขวงบางซื่อ เขตบางซื่อ กรุงเทพมหานคร
    SignalUnit(
      id: 'signal_maint_bn',
      name: 'กองพันสื่อสารซ่อมบำรุงเขตหลัง',
      nameEn: 'Signal Maintenance Battalion (Rear Area)',
      abbreviation: 'พัน.ส.ซบร.',
      level: UnitLevel.battalion,
      parentId: 'signal_dept',
      location: UnitLocation(
        name: 'สะพานแดง',
        province: 'กรุงเทพมหานคร',
        district: 'บางซื่อ',
        latitude: 13.8193,
        longitude: 100.5152,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันสื่อสารซ่อมบำรุงเขตหลัง รับผิดชอบการซ่อมบำรุงยุทโธปกรณ์สายสื่อสารในเขตหลัง',
      missions: [
        'ซ่อมบำรุงยุทโธปกรณ์สายสื่อสารในเขตหลัง',
        'สนับสนุนการซ่อมบำรุงให้กับหน่วยสื่อสาร',
        'ดำเนินการซ่อมบำรุงขั้นหน่วยและขั้นสนาม',
        'จัดทำอะไหล่และชิ้นส่วนซ่อม',
      ],
      childUnitIds: [],
      personnelMin: 200,
      personnelMax: 400,
      color: Color(0xFFFF9500),
    ),
  ];

  // =============================================
  // หน่วยสื่อสารประจำกองทัพภาค (ข้อมูลจากเว็บไซต์ทางการ)
  // กองพันทหารสื่อสาร (ส.พัน.) ขึ้นตรง ทภ.
  // =============================================

  static const List<SignalUnit> armyAreaUnits = [
    // =============================================
    // กองทัพภาคที่ 1 (ภาคกลาง/ภาคตะวันออก)
    // ส.พัน.1, ส.พัน.2, ส.พัน.9, ส.พัน.21
    // =============================================

    // กองพันทหารสื่อสารที่ 1 รักษาพระองค์ (ส.พัน.1 รอ.)
    // ที่ตั้ง: ถนนนางลิ้นจี่ แขวงทุ่งมหาเมฆ เขตสาทร กรุงเทพฯ
    SignalUnit(
      id: 'signal_bn_1',
      name: 'กองพันทหารสื่อสารที่ 1 รักษาพระองค์',
      nameEn: '1st Signal Battalion (Royal Guard)',
      abbreviation: 'ส.พัน.1 รอ.',
      level: UnitLevel.battalion,
      parentId: '1st_army_area',
      location: UnitLocation(
        name: 'ถนนนางลิ้นจี่',
        province: 'กรุงเทพมหานคร',
        district: 'สาทร',
        latitude: 13.7130,
        longitude: 100.5430,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 1 รักษาพระองค์ เป็นหน่วยทหารสื่อสารที่มีเกียรติประวัติสูง ได้รับพระมหากรุณาธิคุณให้เป็นหน่วยรักษาพระองค์ มีภารกิจสนับสนุนการสื่อสารให้กองพลที่ 1 รักษาพระองค์ และกองทัพภาคที่ 1',
      missions: [
        'สนับสนุนการสื่อสารให้ พล.1 รอ. และ ทภ.1',
        'จัดตั้งข่ายสื่อสารทางยุทธวิธีในพื้นที่ปฏิบัติการ',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกและพัฒนากำลังพลสายทหารสื่อสาร',
        'สนับสนุนภารกิจพิเศษตามที่ได้รับมอบหมาย',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 1,
      color: Color(0xFF4CAF50),
    ),

    // กองพันทหารสื่อสารที่ 2 (ส.พัน.2)
    // ที่ตั้ง: ค่ายจักรพงษ์ ตำบลดงพระราม อำเภอเมืองปราจีนบุรี จังหวัดปราจีนบุรี
    SignalUnit(
      id: 'signal_bn_2',
      name: 'กองพันทหารสื่อสารที่ 2',
      nameEn: '2nd Signal Battalion',
      abbreviation: 'ส.พัน.2',
      level: UnitLevel.battalion,
      parentId: '1st_army_area',
      location: UnitLocation(
        name: 'ค่ายจักรพงษ์',
        province: 'ปราจีนบุรี',
        district: 'เมืองปราจีนบุรี',
        latitude: 14.0500,
        longitude: 101.3700,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 2 ตั้งอยู่ที่ค่ายจักรพงษ์ จังหวัดปราจีนบุรี มีภารกิจสนับสนุนการสื่อสารให้กองพลทหารราบที่ 2 รักษาพระองค์ และเป็นหน่วยสื่อสารส่วนหน้าของกองทัพภาคที่ 1 ในพื้นที่ภาคตะวันออก',
      missions: [
        'สนับสนุนการสื่อสารให้ พล.ร.2 รอ. และ ทภ.1 (ส่วนหน้า)',
        'จัดตั้งและดำเนินการข่ายสื่อสารในพื้นที่ภาคตะวันออก',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพลสายสื่อสาร',
        'สนับสนุนการฝึกร่วมและการปฏิบัติการร่วม',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 1,
      color: Color(0xFF4CAF50),
    ),

    // กองพันทหารสื่อสารที่ 9 (ส.พัน.9)
    // ที่ตั้ง: ค่ายสุรสีห์ ตำบลลาดหญ้า อำเภอเมืองกาญจนบุรี จังหวัดกาญจนบุรี
    SignalUnit(
      id: 'signal_bn_9',
      name: 'กองพันทหารสื่อสารที่ 9',
      nameEn: '9th Signal Battalion',
      abbreviation: 'ส.พัน.9',
      level: UnitLevel.battalion,
      parentId: '1st_army_area',
      location: UnitLocation(
        name: 'ค่ายสุรสีห์',
        province: 'กาญจนบุรี',
        district: 'เมืองกาญจนบุรี',
        latitude: 14.4781,
        longitude: 99.4303,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 9 ตั้งอยู่ที่ค่ายสุรสีห์ จังหวัดกาญจนบุรี มีภารกิจสนับสนุนการสื่อสารให้กองทัพภาคที่ 1 ในพื้นที่ภาคตะวันตก ติดชายแดนเมียนมา',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.1 ในพื้นที่ภาคตะวันตก',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-เมียนมา',
        'สนับสนุนการปฏิบัติการป้องกันชายแดน',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 1,
      color: Color(0xFF4CAF50),
    ),

    // กองพันทหารสื่อสารที่ 21 (ส.พัน.21)
    // ที่ตั้ง: ค่ายนวมินทราชินี ตำบลบ้านสวน อำเภอเมืองชลบุรี จังหวัดชลบุรี
    SignalUnit(
      id: 'signal_bn_21',
      name: 'กองพันทหารสื่อสารที่ 21',
      nameEn: '21st Signal Battalion',
      abbreviation: 'ส.พัน.21',
      level: UnitLevel.battalion,
      parentId: '1st_army_area',
      location: UnitLocation(
        name: 'ค่ายนวมินทราชินี',
        province: 'ชลบุรี',
        district: 'เมืองชลบุรี',
        latitude: 13.3611,
        longitude: 100.9847,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 21 ตั้งอยู่ที่ค่ายนวมินทราชินี จังหวัดชลบุรี มีภารกิจสนับสนุนการสื่อสารให้กองทัพภาคที่ 1 ในพื้นที่ชายฝั่งทะเลตะวันออก (Eastern Seaboard)',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.1 ในพื้นที่ชายฝั่งทะเลตะวันออก',
        'จัดตั้งข่ายสื่อสารสนับสนุนการปฏิบัติการทางทะเล',
        'ประสานการสื่อสารกับหน่วยทหารเรือและนาวิกโยธิน',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 1,
      color: Color(0xFF4CAF50),
    ),

    // =============================================
    // กองทัพภาคที่ 2 (ภาคตะวันออกเฉียงเหนือ/อีสาน)
    // ส.พัน.3, ส.พัน.6, ส.พัน.22
    // =============================================

    SignalUnit(
      id: 'signal_bn_3',
      name: 'กองพันทหารสื่อสารที่ 3',
      nameEn: '3rd Signal Battalion',
      abbreviation: 'ส.พัน.3',
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
      description: 'กองพันทหารสื่อสารที่ 3 ตั้งอยู่ที่ค่ายสุรนารี จังหวัดนครราชสีมา เป็นหน่วยสื่อสารหลักของกองทัพภาคที่ 2 มีภารกิจสนับสนุนการสื่อสารในพื้นที่ภาคตะวันออกเฉียงเหนือตอนล่าง',
      missions: [
        'สนับสนุนการสื่อสารให้ บก.ทภ.2 และหน่วยขึ้นตรง',
        'จัดตั้งข่ายสื่อสารหลักของ ทภ.2',
        'ประสานงานสื่อสารกับหน่วยในพื้นที่อีสานตอนล่าง',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 2,
      color: Color(0xFF2196F3),
    ),

    SignalUnit(
      id: 'signal_bn_6',
      name: 'กองพันทหารสื่อสารที่ 6',
      nameEn: '6th Signal Battalion',
      abbreviation: 'ส.พัน.6',
      level: UnitLevel.battalion,
      parentId: '2nd_army_area',
      location: UnitLocation(
        name: 'ค่ายสรรพสิทธิประสงค์',
        province: 'อุบลราชธานี',
        district: 'วารินชำราบ',
        latitude: 15.2000,
        longitude: 104.8700,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 6 ตั้งอยู่ที่ค่ายสรรพสิทธิประสงค์ จังหวัดอุบลราชธานี มีภารกิจสนับสนุนการสื่อสารในพื้นที่ชายแดนไทย-ลาว-กัมพูชา (สามเหลี่ยมมรกต)',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.2 ในพื้นที่อีสานตะวันออก',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-ลาว-กัมพูชา',
        'สนับสนุนการปฏิบัติการป้องกันชายแดน',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 2,
      color: Color(0xFF2196F3),
    ),

    SignalUnit(
      id: 'signal_bn_22',
      name: 'กองพันทหารสื่อสารที่ 22',
      nameEn: '22nd Signal Battalion',
      abbreviation: 'ส.พัน.22',
      level: UnitLevel.battalion,
      parentId: '2nd_army_area',
      location: UnitLocation(
        name: 'ค่ายประจักษ์ศิลปาคม',
        province: 'อุดรธานี',
        district: 'เมืองอุดรธานี',
        latitude: 17.4156,
        longitude: 102.7872,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 22 ตั้งอยู่ที่ค่ายประจักษ์ศิลปาคม จังหวัดอุดรธานี มีภารกิจสนับสนุนการสื่อสารในพื้นที่อีสานตอนบน ติดชายแดนไทย-ลาว',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.2 ในพื้นที่อีสานตอนบน',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-ลาว',
        'สนับสนุนการปฏิบัติการป้องกันชายแดน',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 2,
      color: Color(0xFF2196F3),
    ),

    // =============================================
    // กองทัพภาคที่ 3 (ภาคเหนือ)
    // ส.พัน.4, ส.พัน.11, ส.พัน.23
    // =============================================

    SignalUnit(
      id: 'signal_bn_4',
      name: 'กองพันทหารสื่อสารที่ 4',
      nameEn: '4th Signal Battalion',
      abbreviation: 'ส.พัน.4',
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
      description: 'กองพันทหารสื่อสารที่ 4 ตั้งอยู่ที่ค่ายสมเด็จพระนเรศวรมหาราช จังหวัดพิษณุโลก เป็นหน่วยสื่อสารหลักของกองทัพภาคที่ 3 มีภารกิจสนับสนุนการสื่อสารในพื้นที่ภาคเหนือตอนล่าง',
      missions: [
        'สนับสนุนการสื่อสารให้ บก.ทภ.3 และหน่วยขึ้นตรง',
        'จัดตั้งข่ายสื่อสารหลักของ ทภ.3',
        'ประสานงานสื่อสารกับหน่วยในพื้นที่ภาคเหนือตอนล่าง',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 3,
      color: Color(0xFFFF9800),
    ),

    SignalUnit(
      id: 'signal_bn_11',
      name: 'กองพันทหารสื่อสารที่ 11',
      nameEn: '11th Signal Battalion',
      abbreviation: 'ส.พัน.11',
      level: UnitLevel.battalion,
      parentId: '3rd_army_area',
      location: UnitLocation(
        name: 'ค่ายกาวิละ',
        province: 'เชียงใหม่',
        district: 'เมืองเชียงใหม่',
        latitude: 18.7883,
        longitude: 98.9853,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 11 ตั้งอยู่ที่ค่ายกาวิละ จังหวัดเชียงใหม่ มีภารกิจสนับสนุนการสื่อสารในพื้นที่ภาคเหนือตอนบน ติดชายแดนไทย-เมียนมา',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.3 ในพื้นที่ภาคเหนือตอนบน',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-เมียนมา',
        'สนับสนุนการปฏิบัติการป้องกันชายแดน',
        'สนับสนุนการปฏิบัติการร่วมกับหน่วยข้ามชาติ',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 3,
      color: Color(0xFFFF9800),
    ),

    SignalUnit(
      id: 'signal_bn_23',
      name: 'กองพันทหารสื่อสารที่ 23',
      nameEn: '23rd Signal Battalion',
      abbreviation: 'ส.พัน.23',
      level: UnitLevel.battalion,
      parentId: '3rd_army_area',
      location: UnitLocation(
        name: 'ค่ายเม็งรายมหาราช',
        province: 'เชียงราย',
        district: 'เมืองเชียงราย',
        latitude: 19.9071,
        longitude: 99.8310,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 23 ตั้งอยู่ที่ค่ายเม็งรายมหาราช จังหวัดเชียงราย มีภารกิจสนับสนุนการสื่อสารในพื้นที่สามเหลี่ยมทองคำ (Golden Triangle) ชายแดนไทย-เมียนมา-ลาว',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.3 ในพื้นที่สามเหลี่ยมทองคำ',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-เมียนมา-ลาว',
        'สนับสนุนการปฏิบัติการป้องกันชายแดน',
        'สนับสนุนการปราบปรามยาเสพติด',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 3,
      color: Color(0xFFFF9800),
    ),

    // =============================================
    // กองทัพภาคที่ 4 (ภาคใต้)
    // ส.พัน.5, ส.พัน.15, ส.พัน.24
    // =============================================

    SignalUnit(
      id: 'signal_bn_5',
      name: 'กองพันทหารสื่อสารที่ 5',
      nameEn: '5th Signal Battalion',
      abbreviation: 'ส.พัน.5',
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
      description: 'กองพันทหารสื่อสารที่ 5 ตั้งอยู่ที่ค่ายวชิราวุธ จังหวัดนครศรีธรรมราช เป็นหน่วยสื่อสารหลักของกองทัพภาคที่ 4 มีภารกิจสนับสนุนการสื่อสารในพื้นที่ภาคใต้ตอนบน',
      missions: [
        'สนับสนุนการสื่อสารให้ บก.ทภ.4 และหน่วยขึ้นตรง',
        'จัดตั้งข่ายสื่อสารหลักของ ทภ.4',
        'ประสานงานสื่อสารกับหน่วยในพื้นที่ภาคใต้ตอนบน',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 4,
      color: Color(0xFFE91E63),
    ),

    SignalUnit(
      id: 'signal_bn_15',
      name: 'กองพันทหารสื่อสารที่ 15',
      nameEn: '15th Signal Battalion',
      abbreviation: 'ส.พัน.15',
      level: UnitLevel.battalion,
      parentId: '4th_army_area',
      location: UnitLocation(
        name: 'ค่ายเสนาณรงค์',
        province: 'สงขลา',
        district: 'หาดใหญ่',
        latitude: 7.0086,
        longitude: 100.4747,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 15 ตั้งอยู่ที่ค่ายเสนาณรงค์ จังหวัดสงขลา มีภารกิจสนับสนุนการสื่อสารในพื้นที่ภาคใต้ตอนกลาง ติดชายแดนไทย-มาเลเซีย',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.4 ในพื้นที่ภาคใต้ตอนกลาง',
        'จัดตั้งข่ายสื่อสารชายแดนไทย-มาเลเซีย',
        'สนับสนุนการปฏิบัติการร่วมกับหน่วยมาเลเซีย',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 4,
      color: Color(0xFFE91E63),
    ),

    SignalUnit(
      id: 'signal_bn_24',
      name: 'กองพันทหารสื่อสารที่ 24',
      nameEn: '24th Signal Battalion',
      abbreviation: 'ส.พัน.24',
      level: UnitLevel.battalion,
      parentId: '4th_army_area',
      location: UnitLocation(
        name: 'ค่ายอิงคยุทธบริหาร',
        province: 'ปัตตานี',
        district: 'หนองจิก',
        latitude: 6.8691,
        longitude: 101.2501,
      ),
      commanderRank: 'พันโท',
      description: 'กองพันทหารสื่อสารที่ 24 ตั้งอยู่ที่ค่ายอิงคยุทธบริหาร จังหวัดปัตตานี มีภารกิจสนับสนุนการสื่อสารในพื้นที่จังหวัดชายแดนภาคใต้ (ปัตตานี ยะลา นราธิวาส)',
      missions: [
        'สนับสนุนการสื่อสารให้ ทภ.4 ในพื้นที่จังหวัดชายแดนภาคใต้',
        'สนับสนุนการปฏิบัติการรักษาความมั่นคงภายใน',
        'จัดตั้งข่ายสื่อสารสนับสนุน กอ.รมน.ภาค 4',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วย',
        'ฝึกทหารใหม่และพัฒนากำลังพล',
        'สนับสนุนการประสานงานระหว่างหน่วยทหาร ตำรวจ และฝ่ายปกครอง',
      ],
      childUnitIds: [],
      personnelMin: 300,
      personnelMax: 500,
      armyArea: 4,
      color: Color(0xFFE91E63),
    ),
  ];

  // =============================================
  // ข้อมูลสรุปกองทัพภาค (สำหรับการแสดงผล)
  // =============================================

  static const List<ArmyAreaInfo> armyAreaInfo = [
    ArmyAreaInfo(
      id: 1,
      name: 'กองทัพภาคที่ 1',
      nameEn: '1st Army Area',
      abbreviation: 'ทภ.1',
      region: 'ภาคกลาง/ตะวันออก',
      headquarters: 'กรุงเทพมหานคร',
      signalBattalions: ['ส.พัน.1', 'ส.พัน.2', 'ส.พัน.9', 'ส.พัน.21'],
      color: Color(0xFF4CAF50),
      latitude: 13.7563,
      longitude: 100.5018,
    ),
    ArmyAreaInfo(
      id: 2,
      name: 'กองทัพภาคที่ 2',
      nameEn: '2nd Army Area',
      abbreviation: 'ทภ.2',
      region: 'ภาคตะวันออกเฉียงเหนือ',
      headquarters: 'ค่ายสุรนารี นครราชสีมา',
      signalBattalions: ['ส.พัน.3', 'ส.พัน.6', 'ส.พัน.22'],
      color: Color(0xFF2196F3),
      latitude: 14.9707,
      longitude: 102.1018,
    ),
    ArmyAreaInfo(
      id: 3,
      name: 'กองทัพภาคที่ 3',
      nameEn: '3rd Army Area',
      abbreviation: 'ทภ.3',
      region: 'ภาคเหนือ',
      headquarters: 'ค่ายสมเด็จพระนเรศวรมหาราช พิษณุโลก',
      signalBattalions: ['ส.พัน.4', 'ส.พัน.11', 'ส.พัน.23'],
      color: Color(0xFFFF9800),
      latitude: 16.8211,
      longitude: 100.2659,
    ),
    ArmyAreaInfo(
      id: 4,
      name: 'กองทัพภาคที่ 4',
      nameEn: '4th Army Area',
      abbreviation: 'ทภ.4',
      region: 'ภาคใต้',
      headquarters: 'ค่ายวชิราวุธ นครศรีธรรมราช',
      signalBattalions: ['ส.พัน.5', 'ส.พัน.15', 'ส.พัน.24'],
      color: Color(0xFFE91E63),
      latitude: 8.4304,
      longitude: 99.9632,
    ),
  ];

  /// Get all units combined
  static List<SignalUnit> get allUnits => [
    ...centralUnits,
  ];

  static List<SignalUnit> get allCombinedUnits => [
    ...centralUnits,
    ...armyAreaUnits,
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

  /// Get units by army area
  static List<SignalUnit> getUnitsByArmyArea(int armyArea) {
    return armyAreaUnits.where((u) => u.armyArea == armyArea).toList();
  }

  /// Get root unit (Signal Department)
  static SignalUnit get rootUnit => centralUnits.first;

  /// Get units for map display (main units only)
  static List<SignalUnit> get mapDisplayUnits => [
    ...centralUnits.where((u) => u.level == UnitLevel.department || u.level == UnitLevel.school),
    ...armyAreaUnits,
  ];

  /// Get army area info by ID
  static ArmyAreaInfo? getArmyAreaInfo(int id) {
    try {
      return armyAreaInfo.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
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
        return '⚙';
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

/// ข้อมูลกองทัพภาค
class ArmyAreaInfo {
  final int id;
  final String name;
  final String nameEn;
  final String abbreviation;
  final String region;
  final String headquarters;
  final List<String> signalBattalions;
  final Color color;
  final double latitude;
  final double longitude;

  const ArmyAreaInfo({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.abbreviation,
    required this.region,
    required this.headquarters,
    required this.signalBattalions,
    required this.color,
    required this.latitude,
    required this.longitude,
  });
}
