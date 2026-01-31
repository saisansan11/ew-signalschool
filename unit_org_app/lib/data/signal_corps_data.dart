import '../models/unit_models.dart';

/// ข้อมูลหน่วยทหารสื่อสาร (Signal Corps)
class SignalCorpsData {
  // =============================================
  // โครงสร้างหน่วยทหารสื่อสาร
  // =============================================

  static const List<MilitaryUnit> units = [
    // กรมการทหารสื่อสาร (Signal Department)
    MilitaryUnit(
      id: 'signal_dept',
      name: 'Signal Department',
      nameThai: 'กรมการทหารสื่อสาร',
      abbreviation: 'กส.',
      size: UnitSize.regiment,
      branch: MilitaryBranch.signal,
      description: 'หน่วยงานหลักที่รับผิดชอบงานสื่อสารของกองทัพบก',
      childIds: ['signal_bn1', 'signal_bn2', 'signal_school'],
      personnelMin: 2000,
      personnelMax: 5000,
      commanderRank: 'พลตรี',
      symbol: '|||',
      missions: [
        'วางแผนและอำนวยการด้านการสื่อสาร',
        'พัฒนาระบบสื่อสารของกองทัพบก',
        'ผลิตและซ่อมบำรุงอุปกรณ์สื่อสาร',
        'ฝึกอบรมบุคลากรด้านสื่อสาร',
      ],
    ),

    // กองพันทหารสื่อสาร (Signal Battalion)
    MilitaryUnit(
      id: 'signal_bn',
      name: 'Signal Battalion',
      nameThai: 'กองพันทหารสื่อสาร',
      abbreviation: 'พัน.ส.',
      size: UnitSize.battalion,
      branch: MilitaryBranch.signal,
      description: 'หน่วยสื่อสารระดับกองพัน สนับสนุนการสื่อสารให้กองพล',
      parentId: 'signal_dept',
      childIds: ['signal_co_hq', 'signal_co_radio', 'signal_co_line', 'signal_co_maint'],
      personnelMin: 300,
      personnelMax: 600,
      commanderRank: 'พันโท',
      symbol: '||',
      equipment: [
        'วิทยุสื่อสาร CNR-900',
        'เครื่องทวนสัญญาณ',
        'ระบบสายส่งสัญญาณ',
        'ชุมสายโทรศัพท์สนาม',
      ],
      missions: [
        'สนับสนุนการสื่อสารให้หน่วยระดับกองพล',
        'จัดตั้งและดำเนินการเครือข่ายสื่อสาร',
        'ซ่อมบำรุงอุปกรณ์สื่อสาร',
      ],
    ),

    // กองร้อยกองบังคับการ (HQ Company)
    MilitaryUnit(
      id: 'signal_co_hq',
      name: 'Headquarters Company',
      nameThai: 'กองร้อยกองบังคับการ',
      abbreviation: 'ร้อย.บก.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยกองบังคับการของกองพันทหารสื่อสาร',
      parentId: 'signal_bn',
      childIds: ['signal_plt_cmd', 'signal_plt_sup'],
      personnelMin: 80,
      personnelMax: 120,
      commanderRank: 'พันตรี',
      symbol: '|',
      missions: [
        'อำนวยการและควบคุมการปฏิบัติของกองพัน',
        'ธุรการและส่งกำลังบำรุง',
      ],
    ),

    // กองร้อยสื่อสารวิทยุ (Radio Company)
    MilitaryUnit(
      id: 'signal_co_radio',
      name: 'Radio Company',
      nameThai: 'กองร้อยสื่อสารวิทยุ',
      abbreviation: 'ร้อย.ว.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยรับผิดชอบการสื่อสารทางวิทยุ',
      parentId: 'signal_bn',
      childIds: ['radio_plt1', 'radio_plt2', 'radio_plt3'],
      personnelMin: 80,
      personnelMax: 150,
      commanderRank: 'พันตรี',
      symbol: '|',
      equipment: [
        'วิทยุ HF/VHF/UHF',
        'เครื่องทวนสัญญาณวิทยุ',
        'เสาอากาศสนาม',
        'รถสื่อสาร',
      ],
      missions: [
        'จัดตั้งข่ายสื่อสารวิทยุ',
        'ปฏิบัติการสื่อสารทางวิทยุ',
        'ซ่อมบำรุงเครื่องวิทยุ',
      ],
    ),

    // กองร้อยสื่อสารสาย (Wire/Line Company)
    MilitaryUnit(
      id: 'signal_co_line',
      name: 'Wire Company',
      nameThai: 'กองร้อยสื่อสารสาย',
      abbreviation: 'ร้อย.ส.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยรับผิดชอบการสื่อสารทางสาย',
      parentId: 'signal_bn',
      childIds: ['line_plt1', 'line_plt2'],
      personnelMin: 60,
      personnelMax: 100,
      commanderRank: 'พันตรี',
      symbol: '|',
      equipment: [
        'สายโทรศัพท์สนาม',
        'ชุมสายโทรศัพท์',
        'เครื่องโทรศัพท์สนาม',
        'รถวางสาย',
      ],
      missions: [
        'จัดตั้งระบบสื่อสารสาย',
        'ดำเนินการชุมสายโทรศัพท์สนาม',
        'ซ่อมบำรุงระบบสาย',
      ],
    ),

    // กองร้อยซ่อมบำรุง (Maintenance Company)
    MilitaryUnit(
      id: 'signal_co_maint',
      name: 'Maintenance Company',
      nameThai: 'กองร้อยซ่อมบำรุง',
      abbreviation: 'ร้อย.ซบร.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยรับผิดชอบการซ่อมบำรุงอุปกรณ์สื่อสาร',
      parentId: 'signal_bn',
      personnelMin: 60,
      personnelMax: 100,
      commanderRank: 'พันตรี',
      symbol: '|',
      equipment: [
        'เครื่องมือซ่อมอิเล็กทรอนิกส์',
        'อะไหล่และชิ้นส่วน',
        'รถซ่อมบำรุงเคลื่อนที่',
      ],
      missions: [
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นสนาม',
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นกลาง',
        'สนับสนุนอะไหล่',
      ],
    ),

    // หมวดสื่อสารวิทยุ (Radio Platoon)
    MilitaryUnit(
      id: 'radio_plt',
      name: 'Radio Platoon',
      nameThai: 'หมวดสื่อสารวิทยุ',
      abbreviation: 'มว.ว.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดปฏิบัติการสื่อสารทางวิทยุ',
      parentId: 'signal_co_radio',
      childIds: ['radio_squad1', 'radio_squad2', 'radio_squad3'],
      personnelMin: 25,
      personnelMax: 40,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      equipment: [
        'วิทยุสื่อสาร VHF/UHF',
        'เสาอากาศ',
        'เครื่องจ่ายไฟสนาม',
      ],
      missions: [
        'ดำเนินการสื่อสารวิทยุ',
        'จัดตั้งสถานีวิทยุสนาม',
      ],
    ),

    // หมู่วิทยุ (Radio Squad)
    MilitaryUnit(
      id: 'radio_squad',
      name: 'Radio Squad',
      nameThai: 'หมู่วิทยุ',
      abbreviation: 'มู่.ว.',
      size: UnitSize.squad,
      branch: MilitaryBranch.signal,
      description: 'หมู่ปฏิบัติการวิทยุ',
      parentId: 'radio_plt',
      personnelMin: 8,
      personnelMax: 12,
      commanderRank: 'สิบเอก',
      symbol: '●',
      equipment: [
        'วิทยุสื่อสารประจำหมู่',
        'อุปกรณ์เสริม',
      ],
      missions: [
        'ปฏิบัติการวิทยุสื่อสาร',
        'ดูแลรักษาอุปกรณ์',
      ],
    ),
  ];

  // =============================================
  // Flashcards สำหรับการจำ
  // =============================================

  static const List<UnitFlashcard> flashcards = [
    // ขนาดหน่วย
    UnitFlashcard(
      id: 'fc_size_squad',
      question: 'หมู่ (Squad) มีกำลังพลประมาณเท่าไร?',
      answer: '8-13 คน',
      hint: 'หน่วยย่อยที่สุดที่มีการจัดตั้งเป็นทางการ',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_size_platoon',
      question: 'หมวด (Platoon) มีกำลังพลประมาณเท่าไร?',
      answer: '25-50 คน\nประกอบด้วย 3-4 หมู่',
      hint: 'ผู้บังคับหมวดมียศ ร้อยโท-ร้อยเอก',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_size_company',
      question: 'กองร้อย (Company) มีกำลังพลประมาณเท่าไร?',
      answer: '80-250 คน\nประกอบด้วย 3-5 หมวด',
      hint: 'ผู้บังคับกองร้อยมียศ พันตรี',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_size_battalion',
      question: 'กองพัน (Battalion) มีกำลังพลประมาณเท่าไร?',
      answer: '300-1,000 คน\nประกอบด้วย 4-6 กองร้อย',
      hint: 'ผู้บังคับกองพันมียศ พันโท',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_size_regiment',
      question: 'กรม (Regiment) มีกำลังพลประมาณเท่าไร?',
      answer: '2,000-5,000 คน\nประกอบด้วย 2-3 กองพัน',
      hint: 'ผู้บังคับการมียศ พันเอก',
      category: 'ขนาดหน่วย',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_size_division',
      question: 'กองพล (Division) มีกำลังพลประมาณเท่าไร?',
      answer: '10,000-20,000 คน',
      hint: 'ผู้บัญชาการมียศ พลตรี',
      category: 'ขนาดหน่วย',
      difficulty: 2,
    ),

    // สัญลักษณ์หน่วย
    UnitFlashcard(
      id: 'fc_symbol_squad',
      question: 'สัญลักษณ์ของ หมู่ คืออะไร?',
      answer: '● (จุดเดียว)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_symbol_platoon',
      question: 'สัญลักษณ์ของ หมวด คืออะไร?',
      answer: '●● (สองจุด)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_symbol_company',
      question: 'สัญลักษณ์ของ กองร้อย คืออะไร?',
      answer: '| (ขีดเดียว)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_symbol_battalion',
      question: 'สัญลักษณ์ของ กองพัน คืออะไร?',
      answer: '|| (สองขีด)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_symbol_regiment',
      question: 'สัญลักษณ์ของ กรม คืออะไร?',
      answer: '||| (สามขีด)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_symbol_division',
      question: 'สัญลักษณ์ของ กองพล คืออะไร?',
      answer: 'XX (สองกากบาท)',
      category: 'สัญลักษณ์หน่วย',
      difficulty: 2,
    ),

    // ยศผู้บังคับบัญชา
    UnitFlashcard(
      id: 'fc_cmd_squad',
      question: 'ผู้บังคับหมู่มียศอะไร?',
      answer: 'สิบเอก (ส.อ.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_cmd_platoon',
      question: 'ผู้บังคับหมวดมียศอะไร?',
      answer: 'ร้อยตรี - ร้อยโท',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_cmd_company',
      question: 'ผู้บังคับกองร้อยมียศอะไร?',
      answer: 'พันตรี (พ.ต.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_cmd_battalion',
      question: 'ผู้บังคับกองพันมียศอะไร?',
      answer: 'พันโท (พ.ท.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_cmd_regiment',
      question: 'ผู้บังคับการกรมมียศอะไร?',
      answer: 'พันเอก (พ.อ.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_cmd_division',
      question: 'ผู้บัญชาการกองพลมียศอะไร?',
      answer: 'พลตรี (พล.ต.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 2,
    ),

    // หน่วยสื่อสาร
    UnitFlashcard(
      id: 'fc_signal_radio_co',
      question: 'กองร้อยสื่อสารวิทยุมีหน้าที่หลักอะไร?',
      answer: 'จัดตั้งและดำเนินการข่ายสื่อสารวิทยุ\nปฏิบัติการสื่อสารทางวิทยุ',
      category: 'หน่วยสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_wire_co',
      question: 'กองร้อยสื่อสารสายมีหน้าที่หลักอะไร?',
      answer: 'จัดตั้งระบบสื่อสารสาย\nดำเนินการชุมสายโทรศัพท์สนาม',
      category: 'หน่วยสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_maint_co',
      question: 'กองร้อยซ่อมบำรุง ส. มีหน้าที่หลักอะไร?',
      answer: 'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นสนามและขั้นกลาง\nสนับสนุนอะไหล่',
      category: 'หน่วยสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_bn_structure',
      question: 'กองพันทหารสื่อสารประกอบด้วยกองร้อยอะไรบ้าง?',
      answer: '1. ร้อย.บก. (กองบังคับการ)\n2. ร้อย.ว. (วิทยุ)\n3. ร้อย.ส. (สาย)\n4. ร้อย.ซบร. (ซ่อมบำรุง)',
      category: 'หน่วยสื่อสาร',
      difficulty: 3,
    ),

    // อักษรย่อ
    UnitFlashcard(
      id: 'fc_abbr_signal_dept',
      question: 'กส. ย่อมาจากอะไร?',
      answer: 'กรมการทหารสื่อสาร',
      category: 'อักษรย่อ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_abbr_signal_bn',
      question: 'พัน.ส. ย่อมาจากอะไร?',
      answer: 'กองพันทหารสื่อสาร',
      category: 'อักษรย่อ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_abbr_radio_co',
      question: 'ร้อย.ว. ย่อมาจากอะไร?',
      answer: 'กองร้อยสื่อสารวิทยุ',
      category: 'อักษรย่อ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_abbr_wire_co',
      question: 'ร้อย.ส. ย่อมาจากอะไร?',
      answer: 'กองร้อยสื่อสารสาย',
      category: 'อักษรย่อ',
      difficulty: 1,
    ),

    // สงครามอิเล็กทรอนิกส์ (Electronic Warfare)
    UnitFlashcard(
      id: 'fc_ew_esm',
      question: 'ESM ย่อมาจากอะไร?',
      answer: 'Electronic Support Measures\nมาตรการสนับสนุนทางอิเล็กทรอนิกส์',
      hint: 'การตรวจจับและวิเคราะห์สัญญาณ',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_ew_ecm',
      question: 'ECM ย่อมาจากอะไร?',
      answer: 'Electronic Countermeasures\nมาตรการตอบโต้ทางอิเล็กทรอนิกส์',
      hint: 'การรบกวนสัญญาณข้าศึก',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_ew_eccm',
      question: 'ECCM ย่อมาจากอะไร?',
      answer: 'Electronic Counter-Countermeasures\nมาตรการตอบโต้การตอบโต้ทางอิเล็กทรอนิกส์',
      hint: 'การป้องกันสัญญาณของฝ่ายเรา',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 3,
    ),
    UnitFlashcard(
      id: 'fc_ew_sigint',
      question: 'SIGINT คืออะไร?',
      answer: 'Signal Intelligence\nข่าวกรองสัญญาณ',
      hint: 'การรวบรวมข่าวสารจากการดักฟังสัญญาณ',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 3,
    ),
    UnitFlashcard(
      id: 'fc_ew_comint',
      question: 'COMINT คืออะไร?',
      answer: 'Communications Intelligence\nข่าวกรองการสื่อสาร',
      hint: 'ข่าวกรองจากการดักฟังการสื่อสาร',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 3,
    ),
    UnitFlashcard(
      id: 'fc_ew_elint',
      question: 'ELINT คืออะไร?',
      answer: 'Electronic Intelligence\nข่าวกรองอิเล็กทรอนิกส์',
      hint: 'ข่าวกรองจากเรดาร์และสัญญาณอื่น',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 3,
    ),
    UnitFlashcard(
      id: 'fc_ew_jamming',
      question: 'Jamming (การรบกวนสัญญาณ) คืออะไร?',
      answer: 'การส่งสัญญาณรบกวนเพื่อขัดขวางการสื่อสารของข้าศึก',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),

    // กองทัพภาค
    UnitFlashcard(
      id: 'fc_area_1',
      question: 'ทภ.1 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคกลางและภาคตะวันออก\nกองบัญชาการที่ กรุงเทพฯ',
      hint: 'รวมกรุงเทพและปริมณฑล',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_area_2',
      question: 'ทภ.2 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคตะวันออกเฉียงเหนือ (อีสาน)\nกองบัญชาการที่ นครราชสีมา',
      hint: 'พื้นที่อีสานทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_area_3',
      question: 'ทภ.3 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคเหนือ\nกองบัญชาการที่ พิษณุโลก',
      hint: 'พื้นที่ภาคเหนือทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_area_4',
      question: 'ทภ.4 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคใต้\nกองบัญชาการที่ นครศรีธรรมราช',
      hint: 'พื้นที่ภาคใต้ทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),

    // หน่วยส่วนกลาง
    UnitFlashcard(
      id: 'fc_central_school',
      question: 'โรงเรียนทหารสื่อสารมีหน้าที่หลักอะไร?',
      answer: 'ผลิตนายทหารสื่อสาร\nอบรมหลักสูตรเฉพาะทาง\nวิจัยและพัฒนาด้านการสื่อสาร',
      hint: 'สถาบันการศึกษาของเหล่าทหารสื่อสาร',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_central_center',
      question: 'ศูนย์การสื่อสาร (ศส.กส.) มีหน้าที่หลักอะไร?',
      answer: 'ควบคุมการสื่อสารของ ทบ.\nดำเนินการสื่อสารดาวเทียม\nบริการโทรคมนาคมทหาร',
      hint: 'ศูนย์ควบคุมการสื่อสารหลัก',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_central_factory',
      question: 'กองโรงงานซ่อมสร้างเครื่องสื่อสาร (กรส.กส.) มีหน้าที่หลักอะไร?',
      answer: 'ซ่อมบำรุงขั้นคลัง\nผลิตอุปกรณ์สื่อสาร\nทดสอบและควบคุมคุณภาพ',
      hint: 'หน่วยซ่อมและผลิตอุปกรณ์',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_central_ew',
      question: 'ศูนย์สงครามอิเล็กทรอนิกส์ (ศสอ.) มีหน้าที่หลักอะไร?',
      answer: 'วางแผนและปฏิบัติการ EW\nดำเนินการ ESM/ECM/ECCM\nข่าวกรองสัญญาณ',
      hint: 'หน่วยปฏิบัติการสงครามอิเล็กทรอนิกส์',
      category: 'หน่วยส่วนกลาง',
      difficulty: 3,
    ),

    // ความถี่และคลื่นวิทยุ
    UnitFlashcard(
      id: 'fc_freq_hf',
      question: 'HF (High Frequency) มีย่านความถี่เท่าไร?',
      answer: '3-30 MHz\nใช้สื่อสารระยะไกลผ่านชั้นบรรยากาศ',
      hint: 'ใช้สำหรับการสื่อสารระยะไกล',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_freq_vhf',
      question: 'VHF (Very High Frequency) มีย่านความถี่เท่าไร?',
      answer: '30-300 MHz\nใช้สื่อสารระยะสายตา',
      hint: 'ใช้สำหรับการสื่อสารทั่วไปในระยะใกล้-กลาง',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_freq_uhf',
      question: 'UHF (Ultra High Frequency) มีย่านความถี่เท่าไร?',
      answer: '300-3000 MHz\nใช้สื่อสารเฉพาะทางและดาวเทียม',
      hint: 'ใช้สำหรับดาวเทียมและการสื่อสารพิเศษ',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_freq_los',
      question: 'Line of Sight (LOS) หมายความว่าอย่างไร?',
      answer: 'การสื่อสารระยะสายตา\nสัญญาณเดินทางเป็นเส้นตรง\nถูกขัดขวางโดยสิ่งกีดขวาง',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),

    // ระเบียบปฏิบัติวิทยุ
    UnitFlashcard(
      id: 'fc_radio_pro_roger',
      question: '"Roger" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'รับทราบ/เข้าใจแล้ว\n(Received and understood)',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_radio_pro_wilco',
      question: '"Wilco" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'จะปฏิบัติตาม\n(Will comply)',
      hint: 'มาจาก Will Comply',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_radio_pro_over',
      question: '"Over" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'จบข้อความ รอคำตอบ\n(End of transmission, awaiting reply)',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_radio_pro_out',
      question: '"Out" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'จบการสื่อสาร\n(End of communication)',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_radio_pro_say_again',
      question: '"Say Again" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'ขอให้พูดซ้ำ\n(Please repeat)',
      hint: 'ห้ามใช้คำว่า Repeat',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_radio_pro_break',
      question: '"Break" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      answer: 'แยกข้อความ/หยุดชั่วคราว',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),

    // อุปกรณ์สื่อสาร
    UnitFlashcard(
      id: 'fc_equip_prc',
      question: 'PRC ย่อมาจากอะไร?',
      answer: 'Portable Radio Communication\nวิทยุสื่อสารแบบพกพา',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_equip_vrc',
      question: 'VRC ย่อมาจากอะไร?',
      answer: 'Vehicular Radio Communication\nวิทยุสื่อสารประจำยานพาหนะ',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_equip_satcom',
      question: 'SATCOM ย่อมาจากอะไร?',
      answer: 'Satellite Communication\nการสื่อสารผ่านดาวเทียม',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
  ];

  // =============================================
  // Quiz Questions
  // =============================================

  static const List<QuizQuestion> quizQuestions = [
    // ขนาดหน่วย
    QuizQuestion(
      id: 'q_size_1',
      question: 'หน่วยใดมีกำลังพล 25-50 คน?',
      options: ['หมู่', 'หมวด', 'กองร้อย', 'กองพัน'],
      correctIndex: 1,
      explanation: 'หมวด (Platoon) มีกำลังพลประมาณ 25-50 คน ประกอบด้วย 3-4 หมู่',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_size_2',
      question: 'กองพัน (Battalion) มีกำลังพลประมาณเท่าไร?',
      options: ['80-250 คน', '300-1,000 คน', '2,000-5,000 คน', '10,000-20,000 คน'],
      correctIndex: 1,
      explanation: 'กองพันมีกำลังพล 300-1,000 คน ประกอบด้วย 4-6 กองร้อย',
      category: 'ขนาดหน่วย',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_size_3',
      question: 'หน่วยใดมีขนาดใหญ่ที่สุด?',
      options: ['กรม', 'กองพล', 'กองพัน', 'กองทัพน้อย'],
      correctIndex: 3,
      explanation: 'กองทัพน้อย (Corps) มีกำลังพล 20,000-45,000 คน ใหญ่กว่ากองพล',
      category: 'ขนาดหน่วย',
      difficulty: 2,
    ),

    // สัญลักษณ์
    QuizQuestion(
      id: 'q_symbol_1',
      question: 'สัญลักษณ์ || หมายถึงหน่วยระดับใด?',
      options: ['หมวด', 'กองร้อย', 'กองพัน', 'กรม'],
      correctIndex: 2,
      explanation: 'สัญลักษณ์ || (สองขีด) หมายถึง กองพัน (Battalion)',
      category: 'สัญลักษณ์',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_symbol_2',
      question: 'สัญลักษณ์ XX หมายถึงหน่วยระดับใด?',
      options: ['กรม', 'กองพล', 'กองทัพน้อย', 'กองทัพภาค'],
      correctIndex: 1,
      explanation: 'สัญลักษณ์ XX (สองกากบาท) หมายถึง กองพล (Division)',
      category: 'สัญลักษณ์',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_symbol_3',
      question: 'สัญลักษณ์ ●● หมายถึงหน่วยระดับใด?',
      options: ['ชุด', 'หมู่', 'หมวด', 'กองร้อย'],
      correctIndex: 2,
      explanation: 'สัญลักษณ์ ●● (สองจุด) หมายถึง หมวด (Platoon)',
      category: 'สัญลักษณ์',
      difficulty: 1,
    ),

    // ผู้บังคับบัญชา
    QuizQuestion(
      id: 'q_cmd_1',
      question: 'ผู้บังคับกองพันมียศอะไร?',
      options: ['พันตรี', 'พันโท', 'พันเอก', 'พลตรี'],
      correctIndex: 1,
      explanation: 'ผู้บังคับกองพันมียศ พันโท (พ.ท.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_cmd_2',
      question: 'ผู้บัญชาการกองพลมียศอะไร?',
      options: ['พันเอก', 'พลจัตวา', 'พลตรี', 'พลโท'],
      correctIndex: 2,
      explanation: 'ผู้บัญชาการกองพลมียศ พลตรี (พล.ต.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_cmd_3',
      question: 'ผู้บังคับหมู่มียศอะไร?',
      options: ['พลทหาร', 'สิบตรี', 'สิบเอก', 'จ่าสิบเอก'],
      correctIndex: 2,
      explanation: 'ผู้บังคับหมู่มียศ สิบเอก (ส.อ.)',
      category: 'ผู้บังคับบัญชา',
      difficulty: 1,
    ),

    // หน่วยสื่อสาร
    QuizQuestion(
      id: 'q_signal_1',
      question: 'กองพันทหารสื่อสารประกอบด้วยกี่กองร้อยหลัก?',
      options: ['2 กองร้อย', '3 กองร้อย', '4 กองร้อย', '5 กองร้อย'],
      correctIndex: 2,
      explanation: 'กองพัน ส. มี 4 กองร้อย: บก., วิทยุ, สาย, ซ่อมบำรุง',
      category: 'หน่วยสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_2',
      question: 'ร้อย.ว. ย่อมาจากอะไร?',
      options: [
        'กองร้อยวิศวกรรม',
        'กองร้อยสื่อสารวิทยุ',
        'กองร้อยเวชกรรม',
        'กองร้อยวัตถุระเบิด'
      ],
      correctIndex: 1,
      explanation: 'ร้อย.ว. = กองร้อยสื่อสารวิทยุ (Radio Company)',
      category: 'หน่วยสื่อสาร',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_signal_3',
      question: 'หน่วยใดรับผิดชอบการซ่อมบำรุงอุปกรณ์สื่อสาร?',
      options: ['ร้อย.บก.', 'ร้อย.ว.', 'ร้อย.ส.', 'ร้อย.ซบร.'],
      correctIndex: 3,
      explanation: 'กองร้อยซ่อมบำรุง (ร้อย.ซบร.) รับผิดชอบซ่อมบำรุงอุปกรณ์',
      category: 'หน่วยสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_4',
      question: 'กส. ย่อมาจากอะไร?',
      options: [
        'กองสนับสนุน',
        'กรมการทหารสื่อสาร',
        'กองสื่อสาร',
        'กองพันทหารสื่อสาร'
      ],
      correctIndex: 1,
      explanation: 'กส. = กรมการทหารสื่อสาร (Signal Department)',
      category: 'หน่วยสื่อสาร',
      difficulty: 1,
    ),

    // โครงสร้าง
    QuizQuestion(
      id: 'q_structure_1',
      question: '1 กองร้อย ประกอบด้วยกี่หมวด?',
      options: ['2 หมวด', '3-5 หมวด', '6-8 หมวด', '10 หมวด'],
      correctIndex: 1,
      explanation: '1 กองร้อยประกอบด้วย 3-5 หมวด',
      category: 'โครงสร้าง',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_structure_2',
      question: '1 หมวด ประกอบด้วยกี่หมู่?',
      options: ['2 หมู่', '3-4 หมู่', '5-6 หมู่', '8 หมู่'],
      correctIndex: 1,
      explanation: '1 หมวดประกอบด้วย 3-4 หมู่',
      category: 'โครงสร้าง',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_structure_3',
      question: '1 กองพัน ประกอบด้วยกี่กองร้อย?',
      options: ['2-3 กองร้อย', '4-6 กองร้อย', '7-9 กองร้อย', '10 กองร้อย'],
      correctIndex: 1,
      explanation: '1 กองพันประกอบด้วย 4-6 กองร้อย',
      category: 'โครงสร้าง',
      difficulty: 1,
    ),

    // สงครามอิเล็กทรอนิกส์
    QuizQuestion(
      id: 'q_ew_1',
      question: 'ESM (Electronic Support Measures) หมายถึงอะไร?',
      options: [
        'การรบกวนสัญญาณข้าศึก',
        'การตรวจจับและวิเคราะห์สัญญาณ',
        'การป้องกันสัญญาณของเรา',
        'การส่งสัญญาณหลอกลวง'
      ],
      correctIndex: 1,
      explanation: 'ESM = Electronic Support Measures คือมาตรการสนับสนุนทางอิเล็กทรอนิกส์ ใช้ตรวจจับและวิเคราะห์สัญญาณ',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_ew_2',
      question: 'ECM (Electronic Countermeasures) หมายถึงอะไร?',
      options: [
        'การตรวจจับสัญญาณ',
        'การสื่อสารเข้ารหัส',
        'การรบกวนสัญญาณข้าศึก',
        'การซ่อมบำรุงอุปกรณ์'
      ],
      correctIndex: 2,
      explanation: 'ECM = Electronic Countermeasures คือมาตรการตอบโต้ทางอิเล็กทรอนิกส์ ใช้รบกวนสัญญาณข้าศึก',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_ew_3',
      question: 'SIGINT ย่อมาจากอะไร?',
      options: [
        'Signal Intelligence',
        'Signal Integration',
        'Signal Interception',
        'Signal Interface'
      ],
      correctIndex: 0,
      explanation: 'SIGINT = Signal Intelligence คือข่าวกรองสัญญาณ',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_ew_4',
      question: 'การ Jamming หมายถึงอะไร?',
      options: [
        'การเข้ารหัสสัญญาณ',
        'การส่งสัญญาณรบกวน',
        'การถอดรหัสสัญญาณ',
        'การซ่อมบำรุงเครื่อง'
      ],
      correctIndex: 1,
      explanation: 'Jamming คือการส่งสัญญาณรบกวนเพื่อขัดขวางการสื่อสารของข้าศึก',
      category: 'สงครามอิเล็กทรอนิกส์',
      difficulty: 2,
    ),

    // กองทัพภาค
    QuizQuestion(
      id: 'q_area_1',
      question: 'กองทัพภาคที่ 2 (ทภ.2) รับผิดชอบพื้นที่ใด?',
      options: [
        'ภาคกลาง',
        'ภาคเหนือ',
        'ภาคตะวันออกเฉียงเหนือ',
        'ภาคใต้'
      ],
      correctIndex: 2,
      explanation: 'ทภ.2 รับผิดชอบภาคตะวันออกเฉียงเหนือ (อีสาน) มีกองบัญชาการที่ค่ายสุรนารี จ.นครราชสีมา',
      category: 'กองทัพภาค',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_area_2',
      question: 'ค่ายสมเด็จพระนเรศวรมหาราช ตั้งอยู่จังหวัดใด?',
      options: [
        'เชียงใหม่',
        'พิษณุโลก',
        'ลำปาง',
        'นครราชสีมา'
      ],
      correctIndex: 1,
      explanation: 'ค่ายสมเด็จพระนเรศวรมหาราช ตั้งอยู่ที่ จ.พิษณุโลก เป็นที่ตั้งของ ทภ.3',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_area_3',
      question: 'กองทัพภาคที่ 4 (ทภ.4) มีกองบัญชาการอยู่ที่ใด?',
      options: [
        'สงขลา',
        'สุราษฎร์ธานี',
        'นครศรีธรรมราช',
        'ภูเก็ต'
      ],
      correctIndex: 2,
      explanation: 'ทภ.4 มีกองบัญชาการที่ค่ายวชิราวุธ จ.นครศรีธรรมราช',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),

    // ความถี่วิทยุ
    QuizQuestion(
      id: 'q_freq_1',
      question: 'VHF (Very High Frequency) มีย่านความถี่เท่าไร?',
      options: [
        '3-30 MHz',
        '30-300 MHz',
        '300-3000 MHz',
        '3-30 GHz'
      ],
      correctIndex: 1,
      explanation: 'VHF = 30-300 MHz ใช้สำหรับสื่อสารระยะสายตา',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_freq_2',
      question: 'ย่านความถี่ใดใช้สำหรับการสื่อสารระยะไกลผ่านชั้นบรรยากาศ?',
      options: [
        'VHF',
        'UHF',
        'HF',
        'SHF'
      ],
      correctIndex: 2,
      explanation: 'HF (3-30 MHz) สามารถสะท้อนกับชั้นบรรยากาศไอโอโนสเฟียร์ ใช้สื่อสารระยะไกล',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_freq_3',
      question: 'Line of Sight (LOS) หมายความว่าอย่างไร?',
      options: [
        'การสื่อสารผ่านดาวเทียม',
        'การสื่อสารระยะสายตา',
        'การสื่อสารผ่านสายโทรศัพท์',
        'การสื่อสารดิจิทัล'
      ],
      correctIndex: 1,
      explanation: 'LOS = Line of Sight คือการสื่อสารระยะสายตา สัญญาณเดินทางเป็นเส้นตรง',
      category: 'ความถี่วิทยุ',
      difficulty: 2,
    ),

    // ระเบียบปฏิบัติวิทยุ
    QuizQuestion(
      id: 'q_radio_1',
      question: '"Roger" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      options: [
        'จบการสื่อสาร',
        'รับทราบ/เข้าใจแล้ว',
        'ขอให้พูดซ้ำ',
        'จะปฏิบัติตาม'
      ],
      correctIndex: 1,
      explanation: 'Roger = Received and understood หมายถึงรับทราบและเข้าใจแล้ว',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_radio_2',
      question: '"Wilco" ในการสื่อสารวิทยุหมายความว่าอย่างไร?',
      options: [
        'รับทราบแล้ว',
        'ขอให้พูดซ้ำ',
        'จะปฏิบัติตาม',
        'รอสักครู่'
      ],
      correctIndex: 2,
      explanation: 'Wilco = Will comply หมายถึงจะปฏิบัติตาม',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_radio_3',
      question: 'ต้องการให้ผู้รับพูดซ้ำ ควรพูดว่าอย่างไร?',
      options: [
        'Repeat',
        'Say Again',
        'Copy',
        'Roger'
      ],
      correctIndex: 1,
      explanation: 'ใช้ "Say Again" ห้ามใช้ "Repeat" เพราะ Repeat ใช้สำหรับสั่งยิงซ้ำในทางทหาร',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_radio_4',
      question: '"Over" และ "Out" ต่างกันอย่างไร?',
      options: [
        'Over = จบสื่อสาร, Out = รอคำตอบ',
        'Over = รอคำตอบ, Out = จบสื่อสาร',
        'Over และ Out ใช้แทนกันได้',
        'ทั้งสองหมายถึงจบสื่อสาร'
      ],
      correctIndex: 1,
      explanation: 'Over = จบข้อความ รอคำตอบ, Out = จบการสื่อสาร ไม่ใช้ Over Out ด้วยกัน',
      category: 'ระเบียบปฏิบัติวิทยุ',
      difficulty: 1,
    ),

    // หน่วยส่วนกลาง
    QuizQuestion(
      id: 'q_central_1',
      question: 'โรงเรียนทหารสื่อสาร (รร.ส.สส.) มีหน้าที่หลักอะไร?',
      options: [
        'ซ่อมบำรุงอุปกรณ์',
        'ควบคุมการสื่อสาร',
        'ผลิตนายทหารสื่อสาร',
        'ปฏิบัติการสงครามอิเล็กทรอนิกส์'
      ],
      correctIndex: 2,
      explanation: 'รร.ส.สส. มีหน้าที่ผลิตนายทหารสื่อสาร อบรมหลักสูตรเฉพาะทาง และวิจัยพัฒนา',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_central_2',
      question: 'ศสอ. ย่อมาจากอะไร?',
      options: [
        'ศูนย์สื่อสารอากาศ',
        'ศูนย์สงครามอิเล็กทรอนิกส์',
        'ศูนย์สนับสนุนการรบ',
        'ศูนย์สารสนเทศ'
      ],
      correctIndex: 1,
      explanation: 'ศสอ. = ศูนย์สงครามอิเล็กทรอนิกส์ เป็นหน่วยปฏิบัติการ EW ของ ทบ.',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_central_3',
      question: 'กรมการทหารสื่อสาร (กส.) ตั้งอยู่ที่ใด?',
      options: [
        'สนามเป้า',
        'สะพานแดง',
        'ราชดำเนิน',
        'พหลโยธิน'
      ],
      correctIndex: 1,
      explanation: 'กรมการทหารสื่อสาร ตั้งอยู่ที่ สะพานแดง เขตบางซื่อ กรุงเทพมหานคร',
      category: 'หน่วยส่วนกลาง',
      difficulty: 2,
    ),

    // อุปกรณ์สื่อสาร
    QuizQuestion(
      id: 'q_equip_1',
      question: 'PRC ย่อมาจากอะไร?',
      options: [
        'Portable Radio Communication',
        'Personal Radio Control',
        'Private Radio Channel',
        'Programmable Radio Circuit'
      ],
      correctIndex: 0,
      explanation: 'PRC = Portable Radio Communication คือวิทยุสื่อสารแบบพกพา',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_equip_2',
      question: 'VRC ย่อมาจากอะไร?',
      options: [
        'Variable Radio Control',
        'Vehicular Radio Communication',
        'Voice Radio Channel',
        'Visual Radio Communication'
      ],
      correctIndex: 1,
      explanation: 'VRC = Vehicular Radio Communication คือวิทยุสื่อสารประจำยานพาหนะ',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_equip_3',
      question: 'SATCOM หมายถึงอะไร?',
      options: [
        'การสื่อสารผ่านดาวเทียม',
        'การสื่อสารทางเสียง',
        'การสื่อสารทางสาย',
        'การสื่อสารทางแสง'
      ],
      correctIndex: 0,
      explanation: 'SATCOM = Satellite Communication คือการสื่อสารผ่านดาวเทียม',
      category: 'อุปกรณ์สื่อสาร',
      difficulty: 2,
    ),
  ];

  /// Get flashcards by category
  static List<UnitFlashcard> getFlashcardsByCategory(String category) {
    return flashcards.where((f) => f.category == category).toList();
  }

  /// Get quiz questions by category
  static List<QuizQuestion> getQuizByCategory(String category) {
    return quizQuestions.where((q) => q.category == category).toList();
  }

  /// Get quiz questions by difficulty
  static List<QuizQuestion> getQuizByDifficulty(int difficulty) {
    return quizQuestions.where((q) => q.difficulty == difficulty).toList();
  }

  /// Get all categories
  static List<String> get flashcardCategories {
    return flashcards.map((f) => f.category).toSet().toList();
  }

  static List<String> get quizCategories {
    return quizQuestions.map((q) => q.category).toSet().toList();
  }
}
