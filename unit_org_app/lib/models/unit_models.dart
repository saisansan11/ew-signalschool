import 'package:flutter/material.dart';

/// ประเภทเหล่าทหาร
enum MilitaryBranch {
  signal,       // สื่อสาร
  infantry,     // ราบ
  armor,        // ม้า
  artillery,    // ปืนใหญ่
  engineer,     // ช่าง
  quartermaster,// พลาธิการ
  medical,      // แพทย์
  ordnance,     // สรรพาวุธ
  transport,    // ขนส่ง
  adjutant,     // สารบรรณ
}

/// ขนาดหน่วย
enum UnitSize {
  team,         // ชุด (3-5 คน)
  squad,        // หมู่ (8-13 คน)
  platoon,      // หมวด (25-50 คน)
  company,      // กองร้อย (80-250 คน)
  battalion,    // กองพัน (300-1,000 คน)
  regiment,     // กรม (2,000-5,000 คน)
  division,     // กองพล (10,000-20,000 คน)
  corps,        // กองทัพน้อย
  army,         // กองทัพภาค
}

/// ระดับยศ
enum RankLevel {
  enlisted,     // พลทหาร
  nco,          // นายสิบ
  officer,      // นายทหาร
}

/// ข้อมูลขีดความสามารถของหน่วย
class UnitCapabilities {
  final List<String> capabilities;
  final List<String> limitations;
  final String? combatCapability;
  final List<String> supportRequired;

  const UnitCapabilities({
    this.capabilities = const [],
    this.limitations = const [],
    this.combatCapability,
    this.supportRequired = const [],
  });
}

/// ข้อมูลกำลังพลตามระดับความพร้อม
class ReadinessPersonnel {
  final String level;
  final int count;

  const ReadinessPersonnel({
    required this.level,
    required this.count,
  });
}

/// ข้อมูลกำลังพลแบบละเอียด
class PersonnelBreakdown {
  final int officers;
  final int ncos;
  final int enlisted;
  final int total;
  final ReadinessPersonnel? full;
  final ReadinessPersonnel? reduced1;
  final ReadinessPersonnel? reduced2;
  final ReadinessPersonnel? skeleton;

  const PersonnelBreakdown({
    required this.officers,
    required this.ncos,
    required this.enlisted,
    required this.total,
    this.full,
    this.reduced1,
    this.reduced2,
    this.skeleton,
  });
}

/// ข้อมูลอุปกรณ์แบบละเอียด
class EquipmentItem {
  final String nameTh;
  final String nameEn;
  final String type;
  final int quantity;
  final String? model;
  final String? specifications;

  const EquipmentItem({
    required this.nameTh,
    required this.nameEn,
    required this.type,
    required this.quantity,
    this.model,
    this.specifications,
  });
}

/// Military Unit Model
class MilitaryUnit {
  final String id;
  final String name;
  final String nameThai;
  final String abbreviation;
  final UnitSize size;
  final MilitaryBranch branch;
  final String description;
  final String? parentId;
  final List<String> childIds;
  final int personnelMin;
  final int personnelMax;
  final String commanderRank;
  final String symbol;
  final List<String> equipment;
  final List<String> missions;
  // New fields from JSON
  final UnitCapabilities? capabilities;
  final PersonnelBreakdown? personnelBreakdown;
  final List<EquipmentItem> equipmentItems;
  final String? referenceDoc;

  const MilitaryUnit({
    required this.id,
    required this.name,
    required this.nameThai,
    required this.abbreviation,
    required this.size,
    required this.branch,
    required this.description,
    this.parentId,
    this.childIds = const [],
    required this.personnelMin,
    required this.personnelMax,
    required this.commanderRank,
    required this.symbol,
    this.equipment = const [],
    this.missions = const [],
    this.capabilities,
    this.personnelBreakdown,
    this.equipmentItems = const [],
    this.referenceDoc,
  });
}

/// Position/Role in a unit
class UnitPosition {
  final String id;
  final String title;
  final String titleThai;
  final String rank;
  final String rankThai;
  final RankLevel rankLevel;
  final String duties;
  final String unitId;

  const UnitPosition({
    required this.id,
    required this.title,
    required this.titleThai,
    required this.rank,
    required this.rankThai,
    required this.rankLevel,
    required this.duties,
    required this.unitId,
  });
}

/// Flashcard for memorization
class UnitFlashcard {
  final String id;
  final String question;
  final String answer;
  final String? hint;
  final String category;
  final int difficulty; // 1-3
  final String? imageAsset;

  const UnitFlashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.hint,
    required this.category,
    this.difficulty = 1,
    this.imageAsset,
  });
}

/// Quiz question
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String category;
  final int difficulty;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    required this.category,
    this.difficulty = 1,
  });
}

/// Extension methods for enums
extension UnitSizeExtension on UnitSize {
  String get thaiName {
    switch (this) {
      case UnitSize.team:
        return 'ชุด';
      case UnitSize.squad:
        return 'หมู่';
      case UnitSize.platoon:
        return 'หมวด';
      case UnitSize.company:
        return 'กองร้อย';
      case UnitSize.battalion:
        return 'กองพัน';
      case UnitSize.regiment:
        return 'กรม';
      case UnitSize.division:
        return 'กองพล';
      case UnitSize.corps:
        return 'กองทัพน้อย';
      case UnitSize.army:
        return 'กองทัพภาค';
    }
  }

  String get symbol {
    switch (this) {
      case UnitSize.team:
        return '⊙';
      case UnitSize.squad:
        return '●';
      case UnitSize.platoon:
        return '●●';
      case UnitSize.company:
        return '|';
      case UnitSize.battalion:
        return '||';
      case UnitSize.regiment:
        return '|||';
      case UnitSize.division:
        return 'XX';
      case UnitSize.corps:
        return 'XXX';
      case UnitSize.army:
        return 'XXXX';
    }
  }

  String get personnelRange {
    switch (this) {
      case UnitSize.team:
        return '3-5';
      case UnitSize.squad:
        return '8-13';
      case UnitSize.platoon:
        return '25-50';
      case UnitSize.company:
        return '80-250';
      case UnitSize.battalion:
        return '300-1,000';
      case UnitSize.regiment:
        return '2,000-5,000';
      case UnitSize.division:
        return '10,000-20,000';
      case UnitSize.corps:
        return '20,000-45,000';
      case UnitSize.army:
        return '50,000+';
    }
  }
}

extension MilitaryBranchExtension on MilitaryBranch {
  String get thaiName {
    switch (this) {
      case MilitaryBranch.signal:
        return 'ทหารสื่อสาร';
      case MilitaryBranch.infantry:
        return 'ทหารราบ';
      case MilitaryBranch.armor:
        return 'ทหารม้า';
      case MilitaryBranch.artillery:
        return 'ทหารปืนใหญ่';
      case MilitaryBranch.engineer:
        return 'ทหารช่าง';
      case MilitaryBranch.quartermaster:
        return 'ทหารพลาธิการ';
      case MilitaryBranch.medical:
        return 'ทหารแพทย์';
      case MilitaryBranch.ordnance:
        return 'ทหารสรรพาวุธ';
      case MilitaryBranch.transport:
        return 'ทหารขนส่ง';
      case MilitaryBranch.adjutant:
        return 'ทหารสารบรรณ';
    }
  }

  Color get color {
    switch (this) {
      case MilitaryBranch.signal:
        return const Color(0xFFFF9500);
      case MilitaryBranch.infantry:
        return const Color(0xFF34C759);
      case MilitaryBranch.armor:
        return const Color(0xFF007AFF);
      case MilitaryBranch.artillery:
        return const Color(0xFFFF3B30);
      case MilitaryBranch.engineer:
        return const Color(0xFFAF52DE);
      case MilitaryBranch.quartermaster:
        return const Color(0xFF5856D6);
      case MilitaryBranch.medical:
        return const Color(0xFFFF2D55);
      case MilitaryBranch.ordnance:
        return const Color(0xFF8E8E93);
      case MilitaryBranch.transport:
        return const Color(0xFF30B0C7);
      case MilitaryBranch.adjutant:
        return const Color(0xFFFFCC00);
    }
  }

  IconData get icon {
    switch (this) {
      case MilitaryBranch.signal:
        return Icons.cell_tower;
      case MilitaryBranch.infantry:
        return Icons.directions_walk;
      case MilitaryBranch.armor:
        return Icons.directions_car;
      case MilitaryBranch.artillery:
        return Icons.gps_fixed;
      case MilitaryBranch.engineer:
        return Icons.construction;
      case MilitaryBranch.quartermaster:
        return Icons.inventory_2;
      case MilitaryBranch.medical:
        return Icons.medical_services;
      case MilitaryBranch.ordnance:
        return Icons.build;
      case MilitaryBranch.transport:
        return Icons.local_shipping;
      case MilitaryBranch.adjutant:
        return Icons.description;
    }
  }
}
