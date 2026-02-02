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
        'เครื่องโทรศัพท��สนาม',
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

    // =============================================
    // หน่วยทหารสื่อสารตาม อจย. (ข้อมูลจาก JSON)
    // =============================================

    // กองพันทหารสื่อสารกองพล (Signal Battalion, Division)
    MilitaryUnit(
      id: 'sig_bn_div',
      name: 'Signal Battalion, Division',
      nameThai: 'กองพันทหารสื่อสารกองพล',
      abbreviation: 'พัน.ส.พล.',
      size: UnitSize.battalion,
      branch: MilitaryBranch.signal,
      description: 'กองพันทหารสื่อสารกองพล เป็นหน่วยในอัตราของกองพล เป็นส่วนหนึ่งของหน่วยผสมเหล่า ให้การสนับสนุนการรบด้วยการสื่อสารแก่กองพล',
      childIds: ['sig_bn_div_hq', 'sig_bn_div_radio_co', 'sig_bn_div_wire_co'],
      personnelMin: 345,
      personnelMax: 459,
      commanderRank: 'พันโท',
      symbol: '||',
      missions: [
        'จัดการสื่อสารให้แก่กองบัญชาการกองพล รวมทั้งการสื่อสารไปยังหน่วยต่างๆ ที่ปฏิบัติการภายใต้การบังคับบัญชาของกองพล',
        'จัดบริการการภาพให้กับกองพล',
      ],
      capabilities: UnitCapabilities(
        capabilities: [
          'การวางแผนของฝ่ายอำนวยการ กำกับดูแลการฝึก การปฏิบัติการสื่อสารและกิจการสื่อสารอื่นๆ',
          'ติดตั้ง ปฏิบัติการ และดำรงการสื่อสารประเภทสาย และวิทยุไปยังหน่วยต่างๆ ที่ปฏิบัติงานภายใต้การบังคับบัญชาของกองบัญชาการกองพล',
          'ปฏิบัติการสื่อสารด้วยวิทยุถ่ายทอดให้แก่กองพล รวมทั้งการเชื่อมต่อการสื่อสารของกองพลให้เข้ากับระบบโทรคมนาคมในพื้นที่ตามความจำเป็น',
          'บริการส่งกำลัง และซ่อมบำรุงขั้นหน่วยแก่ยุทโธปกรณ์ในอัตรา รวมทั้งส่งกำลังและซ่อมบำรุงประเภทซ่อมบำรุงขั้นสนามอย่างจำกัดแก่เครื่องสื่อสารของกองพัน และกองบัญชาการกองพล',
          'บริการศูนย์การสื่อสารให้แก่กองบัญชาการกองพล และบริการนำสารด้วยยานพาหนะ',
          'บริการถ่าย ล้าง อัดขยายภาพนิ่ง',
          'ทำการรบอย่างทหารราบเมื่อจำเป็น',
        ],
        limitations: [
          'อาศัยหน่วยอื่นๆ ของกองพลในเรื่องการรักษาพยาบาล และการขนส่งเพิ่มเติม',
          'ต้องการตอนการบินกองพล หรือหน่วยอื่นๆ ในเรื่องเครื่องบินและนักบินเพื่อการปฏิบัติการสื่อสาร',
          'ต้องการการสื่อสารระบบโทรคมนาคมพลเรือน และทางทหารในพื้นที่ที่กองพลเข้าไปปฏิบัติการ',
        ],
        combatCapability: 'ทหารแต่ละคนได้รับการฝึกให้ทำการรบแบบทหารราบได้ มีขีดความสามารถในการป้องกันตนเองต่อการโจมตีทางพื้นดินของข้าศึก แต่ส่วนที่แยกอยู่โดดเดี่ยวต้องอาศัยหน่วยที่รับการสนับสนุนให้ช่วยป้องกันสถานที่ตั้ง',
        supportRequired: [
          'การรักษาพยาบาล',
          'การขนส่งเพิ่มเติม',
          'การบ��นสนับสนุน',
          'ระบบโทรคมนาคมในพื้นที่',
        ],
      ),
      personnelBreakdown: PersonnelBreakdown(
        officers: 10,
        ncos: 59,
        enlisted: 162,
        total: 459,
        full: ReadinessPersonnel(level: 'เต็ม', count: 459),
        reduced1: ReadinessPersonnel(level: 'ลด 1', count: 395),
        reduced2: ReadinessPersonnel(level: 'ลด 2', count: 345),
        skeleton: ReadinessPersonnel(level: 'โครง', count: 63),
      ),
      referenceDoc: 'อจย. 11-35',
    ),

    // กองบังคับการและกองร้อยกองบังคับการ (Headquarters and Headquarters Company)
    MilitaryUnit(
      id: 'sig_bn_div_hq',
      name: 'Headquarters and Headquarters Company',
      nameThai: 'กองบังคับการและกองร้อยกองบังคับการ',
      abbreviation: 'บก.พัน.ส.พล.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองบังคับการและกองร้อยกองบังคับการ กองพันทหารสื่อสารกองพล ทำหน้าที่อำนวยการและบังคับบัญชา',
      parentId: 'sig_bn_div',
      personnelMin: 100,
      personnelMax: 131,
      commanderRank: 'พันตรี',
      symbol: '|',
      missions: [
        'อำนวยการและบังคับบัญชากองพันทหารสื่อสารกองพล',
        'ประสานงานและสนับสนุนการปฏิบัติงานของหน่วยในสังกัด',
        'วางแผนและกำกับดูแลการปฏิบัติการสื่อสาร',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 3,
        ncos: 20,
        enlisted: 38,
        total: 131,
      ),
      referenceDoc: 'อจย. 11-36',
    ),

    // กองร้อยวิทยุและศูนย์ข่าว (Radio and Message Center Company)
    MilitaryUnit(
      id: 'sig_bn_div_radio_co',
      name: 'Radio and Message Center Company',
      nameThai: 'กองร้อยวิทยุและศูนย์ข่าว',
      abbreviation: 'ร้อย.ว.ศข.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยวิทยุและศูนย์ข่าว มีหน้าที่ปฏิบัติการสื่อสารด้วยวิทยุและดำเนินการศูนย์ข่าวสำหรับกองพล',
      parentId: 'sig_bn_div',
      personnelMin: 120,
      personnelMax: 150,
      commanderRank: 'พันตรี',
      symbol: '|',
      missions: [
        'ปฏิบัติการสื่อสารด้วยวิทยุให้แก่กองบัญชาการกองพลและหน่วยในสังกัด',
        'ดำเนินการศูนย์ข่าว รับส่งและกระจายข่าวสาร',
        'รักษาความปลอดภัยการสื่อสารและการเข้ารหัส',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 2,
        ncos: 30,
        enlisted: 118,
        total: 150,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'เครื่องวิทยุ AN/PRC',
          nameEn: 'Radio Set AN/PRC',
          type: 'radio',
          quantity: 20,
          specifications: 'วิทยุแบบพกพา ย่าน VHF/UHF',
        ),
        EquipmentItem(
          nameTh: 'เครื่องวิทยุ AN/VRC',
          nameEn: 'Radio Set AN/VRC',
          type: 'radio',
          quantity: 15,
          specifications: 'วิทยุติดรถยนต์',
        ),
      ],
      referenceDoc: 'อจย. 11-37',
    ),

    // กองร้อยสายและวิทยุถ่ายทอด (Wire and Relay Company)
    MilitaryUnit(
      id: 'sig_bn_div_wire_co',
      name: 'Wire and Relay Company',
      nameThai: 'กองร้อยสายและวิทยุถ่ายทอด',
      abbreviation: 'ร้อย.ส.วถ.',
      size: UnitSize.company,
      branch: MilitaryBranch.signal,
      description: 'กองร้อยสายและวิทยุถ่ายทอด มีหน้าที่ติดตั้งและดำรงระบบสายสื่อสารและวิทยุถ่ายทอด',
      parentId: 'sig_bn_div',
      personnelMin: 140,
      personnelMax: 178,
      commanderRank: 'พันตรี',
      symbol: '|',
      missions: [
        'ติดตั้งและดำรงระบบสายสื่อสารสนามให้แก่กองพล',
        'ปฏิบัติการวิทยุถ่ายทอดเพื่อขยายระยะการสื่อสาร',
        'เชื่อมต่อระบบสื่อสารกองพลเข้ากับระบบโทรคมนาคมในพื้นที่',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 2,
        ncos: 35,
        enlisted: 141,
        total: 178,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'สายสนามทหาร',
          nameEn: 'Military Field Wire',
          type: 'wire',
          quantity: 50,
          model: 'WD-1/TT',
          specifications: 'สายคู่สนาม ความยาว 400 เมตร/ม้วน',
        ),
        EquipmentItem(
          nameTh: 'เครื่องวิทยุถ่ายทอด',
          nameEn: 'Radio Relay Set',
          type: 'relay',
          quantity: 10,
          specifications: 'ระบบถ่ายทอดแบบดิจิตอล',
        ),
        EquipmentItem(
          nameTh: 'ตู้สาขาโทรศัพท์สนาม',
          nameEn: 'Field Telephone Switchboard',
          type: 'telecom',
          quantity: 8,
          model: 'SB-22/PT',
          specifications: 'ความจุ 12 สาย',
        ),
      ],
      referenceDoc: 'อจย. 11-38',
    ),

    // กองพันทหารสื่อสารกองทัพภาค (Signal Battalion, Corps)
    MilitaryUnit(
      id: 'sig_bn_corps',
      name: 'Signal Battalion, Corps',
      nameThai: 'กองพันทหารสื่อสารกองทัพภาค',
      abbreviation: 'พัน.ส.ทภ.',
      size: UnitSize.battalion,
      branch: MilitaryBranch.signal,
      description: 'กองพันทหารสื่อสารกองทัพภาค มีหน้าที่จัดและปฏิบัติการสื่อสารสนับสนุนกองบัญชาการกองทัพภาค',
      childIds: ['sig_bn_corps_hq', 'sig_bn_corps_radio_co', 'sig_bn_corps_wire_co'],
      personnelMin: 280,
      personnelMax: 350,
      commanderRank: 'พันโท',
      symbol: '||',
      missions: [
        'จัดการสื่อสารให้แก่กองบัญชาการกองทัพภาค',
        'สนับสนุนการสื่อสารแก่หน่วยในสังกัดกองทัพภาค',
        'เชื่อมโยงการสื่อสารระหว่างกองทัพภาคกับกองบัญชาการกองทัพบก',
      ],
      capabilities: UnitCapabilities(
        capabilities: [
          'ปฏิบัติการสื่อสารทุกประเภทสนับสนุนกองทัพภาค',
          'เชื่อมโยงระบบสื่อสารในระดับยุทธการ',
          'บริการศูนย์สื่อสารและการเข้ารหัสระดับสูง',
          'ซ่อมบำรุงและสนับสนุนอุปกรณ์สื่อสารในพื้นที่',
        ],
        limitations: [
          'ต้องอาศัยระบบโทรคมนาคมพื้นฐานในพื้นที่',
          'ต้องการการสนับสนุนด้านโลจิสติกส์จากกองทัพภาค',
        ],
      ),
      personnelBreakdown: PersonnelBreakdown(
        officers: 15,
        ncos: 85,
        enlisted: 250,
        total: 350,
      ),
      referenceDoc: 'อจย. 11-55',
    ),

    // กองพันทหารสื่อสาร หน่วยบัญชาการสงครามพิเศษ (Signal Battalion, Special Warfare Command)
    MilitaryUnit(
      id: 'sig_bn_sf',
      name: 'Signal Battalion, Special Warfare Command',
      nameThai: 'กองพันทหารสื่อสาร หน่วยบัญชาการสงครามพิเศษ',
      abbreviation: 'พัน.ส.นบพ.',
      size: UnitSize.battalion,
      branch: MilitaryBranch.signal,
      description: 'กองพันทหารสื่อสาร หน่วยบัญชาการสงครามพิเศษ สนับสนุนการปฏิบัติการพิเศษด้วยระบบสื่อสารที่ทันสมัย',
      personnelMin: 200,
      personnelMax: 260,
      commanderRank: 'พันโท',
      symbol: '||',
      missions: [
        'จัดการสื่อสารสนับสนุนการปฏิบัติการพิเศษ',
        'ปฏิบัติการสื่อสารในสภาวะการณ์พิเศษและการปฏิบัติการแบบไม่ตรง',
        'สนับสนุนการสื่อสารสำหรับหน่วยสงครามพิเศษ',
      ],
      capabilities: UnitCapabilities(
        capabilities: [
          'ปฏิบัติการสื่อสารในพื้นที่ปฏิบัติการพิเศษ',
          'ระบบสื่อสารที่มีความยืดหยุ่นสูงและปลอดภัย',
          'การสื่อสารแบบลับและเข้ารหัสขั้นสูง',
          'สนับสนุนการปฏิบัติการร่วมกับหน่วยพิเศษ',
        ],
        limitations: [
          'จำกัดด้วยลักษณะภารกิจพิเศษ',
          'ต้องการอุปกรณ์พิเศษและบุคลากรที่ผ่านการคัดเลือก',
        ],
      ),
      personnelBreakdown: PersonnelBreakdown(
        officers: 12,
        ncos: 68,
        enlisted: 180,
        total: 260,
      ),
      referenceDoc: 'อจย. 11-555',
    ),

    // =============================================
    // หมวดในสังกัด กองร้อยวิทยุและศูนย์ข่าว (ตาม อจย. 11-37)
    // =============================================

    // หมวดวิทยุที่ 1 (Radio Platoon 1)
    MilitaryUnit(
      id: 'plt_radio_1',
      name: 'Radio Platoon 1',
      nameThai: 'หมวดวิทยุที่ 1',
      abbreviation: 'มว.ว.1',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดวิทยุที่ 1 รับผิดชอบการสื่อสารวิทยุย่าน HF/VHF',
      parentId: 'sig_bn_div_radio_co',
      personnelMin: 25,
      personnelMax: 35,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ปฏิบัติการสื่อสารวิทยุย่าน HF ระยะไกล',
        'จัดตั้งสถานีวิทยุสนามแบบเคลื่อนที่',
        'ดูแลรักษาอุปกรณ์วิทยุประจำหมวด',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 8,
        enlisted: 26,
        total: 35,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'เครื่องวิทยุ HF',
          nameEn: 'HF Radio Set',
          type: 'radio',
          quantity: 5,
          model: 'AN/PRC-150',
          specifications: 'ย่านความถี่ 1.6-30 MHz กำลังส่ง 20W',
        ),
      ],
      referenceDoc: 'อจย. 11-37',
    ),

    // หมวดวิทยุที่ 2 (Radio Platoon 2)
    MilitaryUnit(
      id: 'plt_radio_2',
      name: 'Radio Platoon 2',
      nameThai: 'หมวดวิทยุที่ 2',
      abbreviation: 'มว.ว.2',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดวิทยุที่ 2 รับผิดชอบการสื่อสารวิทยุย่าน VHF/UHF',
      parentId: 'sig_bn_div_radio_co',
      personnelMin: 25,
      personnelMax: 35,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ปฏิบัติการสื่อสารวิทยุย่าน VHF/UHF',
        'สนับสนุนการสื่อสารทางยุทธวิธี',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 8,
        enlisted: 26,
        total: 35,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'เครื่องวิทยุ VHF',
          nameEn: 'VHF Radio Set',
          type: 'radio',
          quantity: 8,
          model: 'AN/PRC-152',
          specifications: 'ย่านความถี่ 30-512 MHz กำลังส่ง 5W',
        ),
      ],
      referenceDoc: 'อจย. 11-37',
    ),

    // หมวดศูนย์ข่าว (Message Center Platoon)
    MilitaryUnit(
      id: 'plt_msg_center',
      name: 'Message Center Platoon',
      nameThai: 'หมวดศูนย์ข่าว',
      abbreviation: 'มว.ศข.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดศูนย์ข่าว รับผิดชอบการรับส่งและกระจายข่าวสาร',
      parentId: 'sig_bn_div_radio_co',
      personnelMin: 20,
      personnelMax: 30,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ดำเนินการศูนย์ข่าว รับส่งและกระจายข่าวสาร',
        'รักษาความปลอดภัยการสื่อสาร (COMSEC)',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 6,
        enlisted: 23,
        total: 30,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'เครื่องเข้ารหัส',
          nameEn: 'Encryption Device',
          type: 'electronic',
          quantity: 4,
          specifications: 'เครื่องเข้ารหัสข่าวสารระดับลับ',
        ),
      ],
      referenceDoc: 'อจย. 11-37',
    ),

    // =============================================
    // หมวดในสังกัด กองร้อยสายและวิทยุถ่ายทอด (ตาม อจย. 11-38)
    // =============================================

    // หมวดสายที่ 1 (Wire Platoon 1)
    MilitaryUnit(
      id: 'plt_wire_1',
      name: 'Wire Platoon 1',
      nameThai: 'หมวดสายที่ 1',
      abbreviation: 'มว.ส.1',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดสายที่ 1 รับผิดชอบการวางสายและดำเนินการชุมสายโทรศัพท์สนาม',
      parentId: 'sig_bn_div_wire_co',
      personnelMin: 30,
      personnelMax: 45,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ติดตั้งระบบสายสื่อสารสนาม',
        'ดำเนินการชุมสายโทรศัพท์สนาม',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 10,
        enlisted: 34,
        total: 45,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'สายสนามทหาร',
          nameEn: 'Military Field Wire',
          type: 'wire',
          quantity: 20,
          model: 'WD-1/TT',
          specifications: 'สายคู่สนาม ความยาว 400 เมตร/ม้วน',
        ),
        EquipmentItem(
          nameTh: 'เครื่องโทรศัพท์สนาม',
          nameEn: 'Field Telephone',
          type: 'telecom',
          quantity: 10,
          model: 'TA-312/PT',
          specifications: 'โทรศัพท์สนามแบบหมุนมือ',
        ),
      ],
      referenceDoc: 'อจย. 11-38',
    ),

    // หมวดสายที่ 2 (Wire Platoon 2)
    MilitaryUnit(
      id: 'plt_wire_2',
      name: 'Wire Platoon 2',
      nameThai: 'หมวดสายที่ 2',
      abbreviation: 'มว.ส.2',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดสายที่ 2 รับผิดชอบการวางสายและสนับสนุนชุมสายโทรศัพท์สนาม',
      parentId: 'sig_bn_div_wire_co',
      personnelMin: 30,
      personnelMax: 45,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ติดตั้งระบบสายสื่อสารสนาม',
        'สนับสนุนชุมสายโทรศัพท์สนาม',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 10,
        enlisted: 34,
        total: 45,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'ตู้สาขาโทรศัพท์สนาม',
          nameEn: 'Field Telephone Switchboard',
          type: 'telecom',
          quantity: 4,
          model: 'SB-22/PT',
          specifications: 'ความจุ 12 สาย',
        ),
      ],
      referenceDoc: 'อจย. 11-38',
    ),

    // หมวดวิทยุถ่ายทอด (Radio Relay Platoon)
    MilitaryUnit(
      id: 'plt_relay',
      name: 'Radio Relay Platoon',
      nameThai: 'หมวดวิทยุถ่ายทอด',
      abbreviation: 'มว.วถ.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดวิทยุถ่ายทอด รับผิดชอบการปฏิบัติการวิทยุถ่ายทอด',
      parentId: 'sig_bn_div_wire_co',
      personnelMin: 25,
      personnelMax: 38,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ติดตั้งและดำเนินการสถานีวิทยุถ่ายทอด',
        'ขยายระยะการสื่อสารวิทยุ',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 9,
        enlisted: 28,
        total: 38,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'เครื่องวิทยุถ่ายทอด',
          nameEn: 'Radio Relay Set',
          type: 'relay',
          quantity: 6,
          model: 'AN/TRC-170',
          specifications: 'ระบบถ่ายทอดแบบดิจิตอล',
        ),
        EquipmentItem(
          nameTh: 'เครื่องกำเนิดไฟฟ้าสนาม',
          nameEn: 'Field Generator',
          type: 'electronic',
          quantity: 4,
          specifications: 'ขนาด 5 KW สำหรับจ่ายกระแสไฟสถานี',
        ),
      ],
      referenceDoc: 'อจย. 11-38',
    ),

    // =============================================
    // หมวดในสังกัด บก.และ ร้อย.บก.พัน.ส.พล. (ตาม อจย. 11-36)
    // =============================================

    // หมวดซ่อมบำรุง (Maintenance Platoon)
    MilitaryUnit(
      id: 'plt_maint',
      name: 'Maintenance Platoon',
      nameThai: 'หมวดซ่อมบำรุง',
      abbreviation: 'มว.ซบร.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดซ่อมบำรุง รับผิดชอบการซ่อมบำรุงอุปกรณ์สื่อสาร',
      parentId: 'sig_bn_div_hq',
      personnelMin: 20,
      personnelMax: 30,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ซ่อมบำรุงอุปกรณ์สื่อสารขั้นหน่วยและขั้นสนาม',
        'จัดหาอะไหล่และชิ้นส่วนซ่อม',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 8,
        enlisted: 21,
        total: 30,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'ชุดเครื่องมือซ่อมอิเล็กทรอนิกส์',
          nameEn: 'Electronics Repair Tool Kit',
          type: 'maintenance',
          quantity: 5,
          specifications: 'ชุดเครื่องมือซ่อมวิทยุ',
        ),
        EquipmentItem(
          nameTh: 'เครื่องทดสอบวิทยุ',
          nameEn: 'Radio Test Set',
          type: 'maintenance',
          quantity: 3,
          model: 'AN/PRM-34',
          specifications: 'เครื่องทดสอบวิทยุและตรวจวัดสัญญาณ',
        ),
      ],
      referenceDoc: 'อจย. 11-36',
    ),

    // หมวดบริการ (Service Platoon)
    MilitaryUnit(
      id: 'plt_service',
      name: 'Service Platoon',
      nameThai: 'หมวดบริการ',
      abbreviation: 'มว.บร.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดบริการ รับผิดชอบการขนส่งและเสบียง',
      parentId: 'sig_bn_div_hq',
      personnelMin: 15,
      personnelMax: 25,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ให้บริการขนส่งแก่กองพัน',
        'จัดเลี้ยงเสบียงแก่กองพัน',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 5,
        enlisted: 19,
        total: 25,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'รถบรรทุก',
          nameEn: 'Cargo Truck',
          type: 'vehicle',
          quantity: 4,
          model: '2.5 ตัน',
          specifications: 'รถบรรทุกอเนกประสงค์',
        ),
      ],
      referenceDoc: 'อจย. 11-36',
    ),

    // หมวดการภาพ (Photo Platoon)
    MilitaryUnit(
      id: 'plt_photo',
      name: 'Photo Platoon',
      nameThai: 'หมวดการภาพ',
      abbreviation: 'มว.กภ.',
      size: UnitSize.platoon,
      branch: MilitaryBranch.signal,
      description: 'หมวดการภาพ รับผิดชอบการถ่าย ล้าง อัดขยายภาพนิ่ง',
      parentId: 'sig_bn_div_hq',
      personnelMin: 10,
      personnelMax: 15,
      commanderRank: 'ร้อยโท',
      symbol: '●●',
      missions: [
        'ถ่ายภาพนิ่งสนับสนุนการปฏิบัติการ',
        'ล้างและอัดขยายภาพ',
      ],
      personnelBreakdown: PersonnelBreakdown(
        officers: 1,
        ncos: 4,
        enlisted: 10,
        total: 15,
      ),
      equipmentItems: [
        EquipmentItem(
          nameTh: 'กล้องถ่ายภาพดิจิตอล',
          nameEn: 'Digital Camera',
          type: 'photo',
          quantity: 5,
          specifications: 'กล้อง DSLR ความละเอียด 24 MP',
        ),
      ],
      referenceDoc: 'อจย. 11-36',
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
      answer: 'ภาคตะวันออกเฉียงเหนือ (อีสาน)\nกองบัญชาการที่ ค่ายสุรนารี นครราชสีมา',
      hint: 'พื้นที่อีสานทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_area_3',
      question: 'ทภ.3 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคเหนือ\nกองบัญชาการที่ ค่ายสมเด็จพระนเรศวรมหาราช พิษณุโลก',
      hint: 'พื้นที่ภาคเหนือทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_area_4',
      question: 'ทภ.4 รับผิดชอบพื้นที่ใด?',
      answer: 'ภาคใต้\nกองบัญชาการที่ ค่ายวชิราวุธ นครศรีธรรมราช',
      hint: 'พื้นที่ภาคใต้ทั้งหมด',
      category: 'กองทัพภาค',
      difficulty: 2,
    ),

    // หน่วยสื่อสารประจำกองทัพภาค (ข้อมูลถูกต้องจาก PDF)
    UnitFlashcard(
      id: 'fc_signal_area_1',
      question: 'ทภ.1 มีกองพันทหารสื่อสารใดบ้าง?',
      answer: 'ส.พัน.1, ส.พัน.2, ส.พัน.9, ส.พัน.21',
      hint: '4 กองพัน สนับสนุนภาคกลาง/ตะวันออก',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_area_2',
      question: 'ทภ.2 มีกองพันทหารสื่อสารใดบ้าง?',
      answer: 'ส.พัน.3, ส.พัน.6, ส.พัน.22',
      hint: '3 กองพัน สนับสนุนภาคอีสาน',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_area_3',
      question: 'ทภ.3 มีกองพันทหารสื่อสารใดบ้าง?',
      answer: 'ส.พัน.4, ส.พัน.11, ส.พัน.23',
      hint: '3 กองพัน สนับสนุนภาคเหนือ',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_area_4',
      question: 'ทภ.4 มีกองพันทหารสื่อสารใดบ้าง?',
      answer: 'ส.พัน.5, ส.พัน.15, ส.พัน.24',
      hint: '3 กองพัน สนับสนุนภาคใต้',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_signal_bn_count',
      question: 'กองทัพบกมีกองพันทหารสื่อสาร (ส.พัน.) ทั้งหมดกี่กองพัน?',
      answer: '13 กองพัน\nทภ.1: 4 กองพัน\nทภ.2: 3 กองพัน\nทภ.3: 3 กองพัน\nทภ.4: 3 กองพัน',
      hint: 'รวมทุกกองทัพภาค',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 3,
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

    // =============================================
    // Flashcards หน่วยตาม อจย.
    // =============================================

    // กองพันทหารสื่อสารกองพล
    UnitFlashcard(
      id: 'fc_sig_bn_div',
      question: 'กองพันทหารสื่อสารกองพล (พัน.ส.พล.) มีภารกิจหลักอะไร?',
      answer: 'จัดการสื่อสารให้แก่กองบัญชาการกองพล\nรวมทั้งการสื่อสารไปยังหน่วยต่างๆ\nจัดบริการการภาพให้กับกองพล',
      hint: 'หน่วยสนับสนุนการรบด้วยการสื่อสาร',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_sig_bn_div_personnel',
      question: 'กองพันทหารสื่อสารกองพลมีกำลังพลเต็มอัตราเท่าไร?',
      answer: '459 นาย\nนายทหาร 10 นาย\nนายสิบ 59 นาย\nพลทหาร 162 นาย',
      hint: 'ตาม อจย. 11-35',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_sig_bn_div_structure',
      question: 'กองพันทหารสื่อสารกองพลประกอบด้วยหน่วยรองอะไรบ้าง?',
      answer: '1. บก.และ ร้อย.บก.\n2. ร้อย.วิทยุและศูนย์ข่าว\n3. ร้อย.สายและวิทยุถ่ายทอด',
      hint: '3 หน่วยหลัก',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_sig_bn_div_ref',
      question: 'กองพันทหารสื่อสารกองพลใช้ อจย. หมายเลขอะไร?',
      answer: 'อจย. 11-35',
      hint: 'อัตราจัดและยุทโธปกรณ์',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),

    // กองร้อยวิทยุและศูนย์ข่าว
    UnitFlashcard(
      id: 'fc_radio_msg_co',
      question: 'กองร้อยวิทยุและศูนย์ข่าว (ร้อย.ว.ศข.) มีภารกิจหลักอะไร?',
      answer: 'ปฏิบัติการสื่อสารด้วยวิทยุ\nดำเนินการศูนย์ข่าว รับส่งกระจายข่าวสาร\nรักษาความปลอดภัยการสื่อสารและการเข้ารหัส',
      hint: 'หน่วยรองของ พัน.ส.พล.',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_radio_msg_co_equip',
      question: 'กองร้อยวิทยุและศูนย์ข่าวมีอุปกรณ์หลักอะไรบ้าง?',
      answer: 'เครื่องวิทยุ AN/PRC 20 เครื่อง\nเครื่องวิทยุ AN/VRC 15 เครื่อง',
      hint: 'VHF/UHF และวิทยุติดรถ',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),

    // กองร้อยสายและวิทยุถ่ายทอด
    UnitFlashcard(
      id: 'fc_wire_relay_co',
      question: 'กองร้อยสายและวิทยุถ่ายทอด (ร้อย.ส.วถ.) มีภารกิจหลักอะไร?',
      answer: 'ติดตั้งและดำรงระบบสายสื่อสารสนาม\nปฏิบัติการวิทยุถ่ายทอดขยายระยะสื่อสาร\nเชื่อมต่อระบบสื่อสารกับโทรคมนาคมในพื้นที่',
      hint: 'หน่วยรองของ พัน.ส.พล.',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_wire_relay_co_equip',
      question: 'กองร้อยสายและวิทยุถ่ายทอดมีอุปกรณ์หลักอะไรบ้าง?',
      answer: 'สายสนามทหาร WD-1/TT 50 ม้วน\nเครื่องวิทยุถ่ายทอด 10 ชุด\nตู้สาขาโทรศัพท์สนาม SB-22/PT 8 ชุด',
      hint: 'ระบบสายและถ่ายทอด',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),

    // กองพันทหารสื่อสารกองทัพภาค
    UnitFlashcard(
      id: 'fc_sig_bn_corps',
      question: 'กองพันทหารสื่อสารกองทัพภาค (พัน.ส.ทภ.) มีภารกิจหลักอะไร?',
      answer: 'จัดการสื่อสารให้แก่กองบัญชาการกองทัพภาค\nสนับสนุนการสื่อสารแก่หน่วยในสังกัด\nเชื่อมโยงการสื่อสารระหว่าง ทภ. กับ บก.ทบ.',
      hint: 'หน่วยสื่อสารระดับกองทัพภาค',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_sig_bn_corps_personnel',
      question: 'กองพันทหารสื่อสารกองทัพภาคมีกำลังพลเต็มอัตราเท่าไร?',
      answer: '350 นาย\nนายทหาร 15 นาย\nนายสิบ 85 นาย\nพลทหาร 250 นาย',
      hint: 'ตาม อจย. 11-55',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),

    // กองพันทหารสื่อสาร นบพ.
    UnitFlashcard(
      id: 'fc_sig_bn_sf',
      question: 'กองพันทหารสื่อสาร หน่วยบัญชาการสงครามพิเศษ (พัน.ส.นบพ.) มีภารกิจหลักอะไร?',
      answer: 'จัดการสื่อสารสนับสนุนการปฏิบัติการพิเศษ\nปฏิบัติการสื่อสารในสภาวะการณ์พิเศษ\nสนับสนุนการสื่อสารสำหรับหน่วยสงครามพิเศษ',
      hint: 'หน่วยสื่อสารสนับสนุนปฏิบัติการพิเศษ',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),
    UnitFlashcard(
      id: 'fc_sig_bn_sf_capability',
      question: 'กองพันทหารสื่อสาร นบพ. มีขีดความสามารถพิเศษอะไรบ้าง?',
      answer: 'ปฏิบัติการในพื้นที่ปฏิบัติการพิเศษ\nระบบสื่อสารยืดหยุ่นสูงและปลอดภัย\nการสื่อสารแบบลับและเข้ารหัสขั้นสูง',
      hint: 'ระบบสื่อสารเฉพาะทาง',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),

    // ความพร้อมรบ
    UnitFlashcard(
      id: 'fc_readiness_levels',
      question: 'ระดับความพร้อมรบของหน่วยทหารสื่อสารมีกี่ระดับ?',
      answer: '4 ระดับ:\n1. เต็ม (Full)\n2. ลด 1 (Reduced 1)\n3. ลด 2 (Reduced 2)\n4. โครง (Skeleton)',
      hint: 'ตามระดับกำลังพล',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),

    // =============================================
    // Flashcards ระดับหมวด (Platoon Level)
    // =============================================

    UnitFlashcard(
      id: 'fc_plt_radio_1',
      question: 'หมวดวิทยุที่ 1 (มว.ว.1) รับผิดชอบงานอะไร?',
      answer: 'ปฏิบัติการสื่อสารวิทยุย่าน HF ระยะไกล\nจัดตั้งสถานีวิทยุสนามแบบเคลื่อนที่',
      hint: 'ใช้วิทยุ HF ย่าน 1.6-30 MHz',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_radio_2',
      question: 'หมวดวิทยุที่ 2 (มว.ว.2) ใช้วิทยุย่านความถี่อะไร?',
      answer: 'VHF (30-512 MHz) และ UHF (225-400 MHz)',
      hint: 'สนับสนุนการสื่อสารทางยุทธวิธี',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_msg_center',
      question: 'หมวดศูนย์ข่าว (มว.ศข.) มีภารกิจหลักอะไร?',
      answer: 'ดำเนินการศูนย์ข่าว รับส่งและกระจายข่าวสาร\nรักษาความปลอดภัยการสื่อสาร (COMSEC)\nเข้ารหัสและถอดรหัสข่าวสาร',
      hint: 'รับผิดชอบความปลอดภัยข่าวสาร',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_wire',
      question: 'หมวดสาย (มว.ส.) ใช้อุปกรณ์หลักอะไร?',
      answer: 'สายสนามทหาร WD-1/TT\nเครื่องโทรศัพท์สนาม TA-312/PT\nตู้สาขาโทรศัพท์สนาม SB-22/PT',
      hint: 'ระบบสื่อสารทางสาย',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_relay',
      question: 'หมวดวิทยุถ่ายทอด (มว.วถ.) มีหน้าที่อะไร?',
      answer: 'ติดตั้งและดำเนินการสถานีวิทยุถ่ายทอด\nขยายระยะการสื่อสารวิทยุ\nเชื่อมต่อระบบสื่อสารกองพลกับโทรคมนาคมในพื้นที่',
      hint: 'ใช้เครื่อง AN/TRC-170',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_maint',
      question: 'หมวดซ่อมบำรุง (มว.ซบร.) ซ่อมบำรุงระดับใด?',
      answer: 'ซ่อมบำรุงขั้นหน่วย (Unit Level)\nซ่อมบำรุงขั้นสนาม (Field Level)\nจัดหาอะไหล่และชิ้นส่วนซ่อม',
      hint: 'ขึ้นอยู่กับ บก.พัน.ส.พล.',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_service',
      question: 'หมวดบริการ (มว.บร.) มีหน้าที่อะไร?',
      answer: 'ให้บริการขนส่งแก่กองพัน\nจัดเลี้ยงเสบียงแก่กองพัน\nบริการสิ่งอุปกรณ์และเครื่องใช้',
      hint: 'สนับสนุนด้านโลจิสติกส์',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_photo',
      question: 'หมวดการภาพ (มว.กภ.) มีภารกิจอะไร?',
      answer: 'ถ่ายภาพนิ่งสนับสนุนการปฏิบัติการ\nล้างและอัดขยายภาพ\nจัดทำสื่อภาพประกอบการฝึกศึกษา',
      hint: 'ขึ้นอยู่กับ บก.พัน.ส.พล.',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    UnitFlashcard(
      id: 'fc_plt_commander',
      question: 'ผู้บังคับหมวดทหารสื่อสารมียศอะไร?',
      answer: 'ร้อยโท (ร.ท.)',
      hint: 'นายทหารชั้นสัญญาบัตรระดับต้น',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 1,
    ),
    UnitFlashcard(
      id: 'fc_plt_personnel',
      question: 'หมวดทหารสื่อสารมีกำลังพลประมาณเท่าไร?',
      answer: '25-45 นาย (แล้วแต่ประเภทหมวด)\nนายทหาร 1 นาย\nนายสิบ 5-10 นาย\nพลทหาร 19-34 นาย',
      hint: 'ขึ้นอยู่กับภารกิจของหมวด',
      category: 'หมวดทหารสื่อสาร',
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

    // หน่วยสื่อสารประจำกองทัพภาค (ข้อมูลจาก PDF)
    QuizQuestion(
      id: 'q_signal_area_1',
      question: 'กองทัพภาคที่ 1 มีกองพันทหารสื่อสารกี่กองพัน?',
      options: ['2 กองพัน', '3 กองพัน', '4 กองพัน', '5 กองพัน'],
      correctIndex: 2,
      explanation: 'ทภ.1 มี 4 กองพัน: ส.พัน.1, ส.พัน.2, ส.พัน.9, ส.พัน.21',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_area_2',
      question: 'ส.พัน.3 สังกัดกองทัพภาคใด?',
      options: ['ทภ.1', 'ทภ.2', 'ทภ.3', 'ทภ.4'],
      correctIndex: 1,
      explanation: 'ส.พัน.3 สังกัด ทภ.2 ตั้งอยู่ที่ค่ายสุรนารี นครราชสีมา',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_area_3',
      question: 'กองพันทหารสื่อสารใดสังกัด ทภ.3?',
      options: [
        'ส.พัน.1, ส.พัน.2, ส.พัน.9',
        'ส.พัน.3, ส.พัน.6, ส.พัน.22',
        'ส.พัน.4, ส.พัน.11, ส.พัน.23',
        'ส.พัน.5, ส.พัน.15, ส.พัน.24'
      ],
      correctIndex: 2,
      explanation: 'ทภ.3 (ภาคเหนือ) มี ส.พัน.4 (พิษณุโลก), ส.พัน.11 (เชียงใหม่), ส.พัน.23 (เชียงราย)',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_area_4',
      question: 'ส.พัน.24 ตั้งอยู่ที่จังหวัดใด?',
      options: ['นครศรีธรรมราช', 'สงขลา', 'ปัตตานี', 'สุราษฎร์ธานี'],
      correctIndex: 2,
      explanation: 'ส.พัน.24 ตั้งอยู่ที่ค่ายอิงคยุทธบริหาร จ.ปัตตานี สังกัด ทภ.4',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 3,
    ),
    QuizQuestion(
      id: 'q_signal_area_5',
      question: 'ส.พัน.9 สังกัดกองทัพภาคใด?',
      options: ['ทภ.1', 'ทภ.2', 'ทภ.3', 'ทภ.4'],
      correctIndex: 0,
      explanation: 'ส.พัน.9 สังกัด ทภ.1 ตั้งอยู่ที่ค่ายสุรสีห์ จ.กาญจนบุรี',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_signal_total',
      question: 'กองทัพบกมี ส.พัน. ประจำกองทัพภาครวมทั้งหมดกี่กองพัน?',
      options: ['10 กองพัน', '12 กองพัน', '13 กองพัน', '15 กองพัน'],
      correctIndex: 2,
      explanation: 'รวม 13 กองพัน: ทภ.1 มี 4 กองพัน, ทภ.2-4 มีภาคละ 3 กองพัน',
      category: 'หน่วยสื่อสารประจำ ทภ.',
      difficulty: 3,
    ),

    // =============================================
    // Quiz Questions หน่วยตาม อจย.
    // =============================================

    QuizQuestion(
      id: 'q_sig_bn_div_personnel',
      question: 'กองพันทหารสื่อสารกองพลมีกำลังพลเต็มอัตราเท่าไร?',
      options: ['350 นาย', '395 นาย', '459 นาย', '500 นาย'],
      correctIndex: 2,
      explanation: 'พัน.ส.พล. มีกำลังพลเต็มอัตรา 459 นาย (นายทหาร 10, นายสิบ 59, พลทหาร 162) ตาม อจย. 11-35',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_div_structure',
      question: 'กองพันทหารสื่อสารกองพลประกอบด้วยกี่หน่วยรอง?',
      options: ['2 หน่วย', '3 หน่วย', '4 หน่วย', '5 หน่วย'],
      correctIndex: 1,
      explanation: 'พัน.ส.พล. มี 3 หน่วยรอง: บก.และร้อย.บก., ร้อย.วิทยุและศูนย์ข่าว, ร้อย.สายและวิทยุถ่ายทอด',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_div_ref',
      question: 'กองพันทหารสื่อสารกองพลใช้ อจย. หมายเลขอะไร?',
      options: ['อจย. 11-30', 'อจย. 11-35', 'อจย. 11-40', 'อจย. 11-55'],
      correctIndex: 1,
      explanation: 'กองพันทหารสื่อสารกองพล ใช้ อจย. 11-35',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),
    QuizQuestion(
      id: 'q_radio_msg_co',
      question: 'กองร้อยวิทยุและศูนย์ข่าวมีภารกิจใดต่อไปนี้?',
      options: [
        'ติดตั้งระบบสายสื่อสาร',
        'ซ่อมบำรุงอุปกรณ์',
        'รักษาความปลอดภัยการสื่อสารและการเข้ารหัส',
        'ขนส่งสิ่งอุปกรณ์'
      ],
      correctIndex: 2,
      explanation: 'ร้อย.ว.ศข. มีภารกิจรักษาความปลอดภัยการสื่อสารและการเข้ารหัส ดำเนินการศูนย์ข่าว และปฏิบัติการสื่อสารด้วยวิทยุ',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_wire_relay_co',
      question: 'กองร้อยสายและวิทยุถ่ายทอดมีอุปกรณ์ใดเป็นหลัก?',
      options: [
        'เครื่องวิทยุ AN/PRC',
        'รถถัง',
        'สายสนามทหาร WD-1/TT',
        'เรดาร์'
      ],
      correctIndex: 2,
      explanation: 'ร้อย.ส.วถ. มีสายสนามทหาร WD-1/TT 50 ม้วน เครื่องวิทยุถ่ายทอด 10 ชุด และตู้สาขาโทรศัพท์สนาม 8 ชุด',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_corps_personnel',
      question: 'กองพันทหารสื่อสารกองทัพภาคมีกำลังพลเต็มอัตราเท่าไร?',
      options: ['260 นาย', '300 นาย', '350 นาย', '459 นาย'],
      correctIndex: 2,
      explanation: 'พัน.ส.ทภ. มีกำลังพลเต็มอัตรา 350 นาย (นายทหาร 15, นายสิบ 85, พลทหาร 250) ตาม อจย. 11-55',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_sf',
      question: 'กองพันทหารสื่อสาร หน่วยบัญชาการสงครามพิเศษ มีขีดความสามารถพิเศษใด?',
      options: [
        'การรบแบบกองโจร',
        'การสื่อสารแบบลับและเข้ารหัสขั้นสูง',
        'การยิงปืนใหญ่',
        'การบินลาดตระเวน'
      ],
      correctIndex: 1,
      explanation: 'พัน.ส.นบพ. มีขีดความสามารถด้านการสื่อสารแบบลับและเข้ารหัสขั้นสูง รองรับการปฏิบัติการพิเศษ',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_sf_personnel',
      question: 'กองพันทหารสื่อสาร นบพ. มีกำลังพลเต็มอัตราเท่าไร?',
      options: ['200 นาย', '260 นาย', '350 นาย', '459 นาย'],
      correctIndex: 1,
      explanation: 'พัน.ส.นบพ. มีกำลังพล 260 นาย (นายทหาร 12, นายสิบ 68, พลทหาร 180) ตาม อจย. 11-555',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_readiness_levels',
      question: 'ระดับความพร้อมรบของหน่วยทหารสื่อสารมีกี่ระดับ?',
      options: ['2 ระดับ', '3 ระดับ', '4 ระดับ', '5 ระดับ'],
      correctIndex: 2,
      explanation: 'มี 4 ระดับ: เต็ม (Full), ลด 1 (Reduced 1), ลด 2 (Reduced 2), โครง (Skeleton)',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_div_combat',
      question: 'กองพันทหารสื่อสารกองพลมีขีดความสามารถในการรบอย่างไร?',
      options: [
        'ไม่มีขีดความสามารถในการรบ',
        'ทำการรบอย่างทหารราบเมื่อจำเป็น',
        'ทำการรบเป็นหน่วยหลัก',
        'ทำการรบด้วยยานเกราะ'
      ],
      correctIndex: 1,
      explanation: 'ทหารแต่ละคนได้รับการฝึกให้ทำการรบแบบทหารราบได้ มีขีดความสามารถในการป้องกันตนเองต่อการโจมตีทางพื้นดินของข้าศึก',
      category: 'หน่วยตาม อจย.',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_sig_bn_div_hq_ref',
      question: 'กองบังคับการและกองร้อยกองบังคับการ พัน.ส.พล. ใช้ อจย. หมายเลขอะไร?',
      options: ['อจย. 11-35', 'อจย. 11-36', 'อจย. 11-37', 'อจย. 11-38'],
      correctIndex: 1,
      explanation: 'บก.และร้อย.บก.พัน.ส.พล. ใช้ อจย. 11-36',
      category: 'หน่วยตาม อจย.',
      difficulty: 3,
    ),

    // =============================================
    // Quiz Questions ระดับหมวด (Platoon Level)
    // =============================================

    QuizQuestion(
      id: 'q_plt_radio_freq',
      question: 'หมวดวิทยุที่ 1 ใช้วิทยุย่านความถี่ใด?',
      options: ['VHF (30-512 MHz)', 'UHF (225-400 MHz)', 'HF (1.6-30 MHz)', 'SHF (3-30 GHz)'],
      correctIndex: 2,
      explanation: 'หมวดวิทยุที่ 1 รับผิดชอบการสื่อสารวิทยุย่าน HF ระยะไกล ใช้เครื่อง AN/PRC-150',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_msg_center_mission',
      question: 'หมวดศูนย์ข่าว (มว.ศข.) มีภารกิจใด?',
      options: [
        'วางสายสื่อสาร',
        'รักษาความปลอดภัยการสื่อสาร (COMSEC)',
        'ซ่อมบำรุงอุปกรณ์',
        'ถ่ายภาพนิ่ง'
      ],
      correctIndex: 1,
      explanation: 'หมวดศูนย์ข่าวรับผิดชอบการรับส่งกระจายข่าวสาร และรักษาความปลอดภัยการสื่อสาร (COMSEC)',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_wire_equip',
      question: 'สายสนามทหารรุ่น WD-1/TT มีความยาวเท่าไรต่อม้วน?',
      options: ['100 เมตร', '200 เมตร', '400 เมตร', '1000 เมตร'],
      correctIndex: 2,
      explanation: 'สายสนามทหาร WD-1/TT เป็นสายคู่สนาม ความยาว 400 เมตร/ม้วน',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_relay_model',
      question: 'หมวดวิทยุถ่ายทอดใช้เครื่องวิทยุรุ่นใด?',
      options: ['AN/PRC-150', 'AN/PRC-152', 'AN/TRC-170', 'AN/VRC-110'],
      correctIndex: 2,
      explanation: 'หมวดวิทยุถ่ายทอดใช้เครื่อง AN/TRC-170 ระบบถ่ายทอดแบบดิจิตอล',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_commander_rank',
      question: 'ผู้บังคับหมวดทหารสื่อสารมียศอะไร?',
      options: ['สิบเอก', 'ร้อยตรี', 'ร้อยโท', 'พันตรี'],
      correctIndex: 2,
      explanation: 'ผู้บังคับหมวดมียศ ร้อยโท (ร.ท.)',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 1,
    ),
    QuizQuestion(
      id: 'q_plt_parent_radio',
      question: 'หมวดวิทยุ สังกัดกองร้อยใด?',
      options: [
        'กองร้อยกองบังคับการ',
        'กองร้อยวิทยุและศูนย์ข่าว',
        'กองร้อยสายและวิทยุถ่ายทอด',
        'กองร้อยซ่อมบำรุง'
      ],
      correctIndex: 1,
      explanation: 'หมวดวิทยุที่ 1, 2 และหมวดศูนย์ข่าว สังกัดกองร้อยวิทยุและศูนย์ข่าว (ร้อย.ว.ศข.)',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_parent_wire',
      question: 'หมวดสายและหมวดวิทยุถ่ายทอด สังกัดกองร้อยใด?',
      options: [
        'กองร้อยกองบังคับการ',
        'กองร้อยวิทยุและศูนย์ข่าว',
        'กองร้อยสายและวิทยุถ่ายทอด',
        'กองร้อยซ่อมบำรุง'
      ],
      correctIndex: 2,
      explanation: 'หมวดสายที่ 1, 2 และหมวดวิทยุถ่ายทอด สังกัดกองร้อยสายและวิทยุถ่ายทอด (ร้อย.ส.วถ.)',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_maint_level',
      question: 'หมวดซ่อมบำรุง (มว.ซบร.) ซ่อมบำรุงระดับใด?',
      options: [
        'ขั้นหน่วยและขั้นสนาม',
        'ขั้นคลังเท่านั้น',
        'ขั้นโรงงานเท่านั้น',
        'ทุกระดับ'
      ],
      correctIndex: 0,
      explanation: 'หมวดซ่อมบำรุงรับผิดชอบซ่อมบำรุงขั้นหน่วย (Unit Level) และขั้นสนาม (Field Level)',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_telephone',
      question: 'เครื่องโทรศัพท์สนามรุ่น TA-312/PT เป็นชนิดใด?',
      options: ['กดปุ่มดิจิตอล', 'หมุนมือ', 'ไร้สาย', 'IP Phone'],
      correctIndex: 1,
      explanation: 'เครื่องโทรศัพท์สนาม TA-312/PT เป็นชนิดหมุนมือ ใช้กับระบบสายสนาม',
      category: 'หมวดทหารสื่อสาร',
      difficulty: 2,
    ),
    QuizQuestion(
      id: 'q_plt_switchboard',
      question: 'ตู้สาขาโทรศัพท์สนาม SB-22/PT มีความจุเท่าไร?',
      options: ['6 สาย', '12 สาย', '24 สาย', '48 สาย'],
      correctIndex: 1,
      explanation: 'ตู้สาขาโทรศัพท์สนาม SB-22/PT มีความจุ 12 สาย',
      category: 'หมวดทหารสื่อสาร',
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
