import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

class NatoSymbolsScreen extends StatefulWidget {
  const NatoSymbolsScreen({super.key});

  @override
  State<NatoSymbolsScreen> createState() => _NatoSymbolsScreenState();
}

class _NatoSymbolsScreenState extends State<NatoSymbolsScreen> {
  String _selectedCategory = 'ทั้งหมด';

  final List<String> _categories = [
    'ทั้งหมด',
    'หน่วยภาคพื้นดิน',
    'หน่วยสื่อสาร',
    'หน่วยสนับสนุน',
    'อุปกรณ์',
    'กิจกรรม',
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        final filteredSymbols = _selectedCategory == 'ทั้งหมด'
            ? _militarySymbols
            : _militarySymbols.where((s) => s.category == _selectedCategory).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'NATO MILITARY SYMBOLS',
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 16,
              ),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          body: Column(
            children: [
              // Info Banner
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'สัญลักษณ์ทางทหารตามมาตรฐาน MIL-STD-2525D (APP-6)',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
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
              const SizedBox(height: 8),
              // Affiliation Legend
              _buildAffiliationLegend(isDark),
              // Symbols Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredSymbols.length,
                  itemBuilder: (context, index) {
                    return _buildSymbolCard(filteredSymbols[index], isDark);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAffiliationLegend(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'สังกัด (Affiliation)',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAffiliationItem('ฝ่ายเรา', Colors.blue, Icons.crop_square),
              _buildAffiliationItem('ศัตรู', Colors.red, Icons.change_history),
              _buildAffiliationItem('กลาง', Colors.green, Icons.crop_square_rounded),
              _buildAffiliationItem('ไม่ทราบ', Colors.yellow.shade700, Icons.circle_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAffiliationItem(String label, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolCard(_MilitarySymbol symbol, bool isDark) {
    return GestureDetector(
      onTap: () => _showSymbolDetail(symbol, isDark),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.border : AppColorsLight.border,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Symbol representation
            Container(
              width: 60,
              height: 50,
              decoration: BoxDecoration(
                color: symbol.affiliationColor.withAlpha(20),
                border: Border.all(color: symbol.affiliationColor, width: 2),
                borderRadius: symbol.affiliation == 'friendly'
                    ? BorderRadius.circular(4)
                    : symbol.affiliation == 'hostile'
                        ? null
                        : BorderRadius.circular(12),
                shape: symbol.affiliation == 'hostile' ? BoxShape.rectangle : BoxShape.rectangle,
              ),
              child: Center(
                child: Text(
                  symbol.symbolCode,
                  style: TextStyle(
                    color: symbol.affiliationColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                symbol.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              symbol.thaiName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSymbolDetail(_MilitarySymbol symbol, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.border : AppColorsLight.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Large Symbol
              Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: symbol.affiliationColor.withAlpha(20),
                  border: Border.all(color: symbol.affiliationColor, width: 3),
                  borderRadius: symbol.affiliation == 'friendly'
                      ? BorderRadius.circular(6)
                      : symbol.affiliation == 'hostile'
                          ? null
                          : BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    symbol.symbolCode,
                    style: TextStyle(
                      color: symbol.affiliationColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                symbol.name,
                style: TextStyle(
                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                symbol.thaiName,
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.background : AppColorsLight.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  symbol.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDetailChip('หมวดหมู่', symbol.category, isDark),
                  const SizedBox(width: 12),
                  _buildDetailChip('ขนาด', symbol.echelon, isDark),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailChip(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  final List<_MilitarySymbol> _militarySymbols = [
    // หน่วยภาคพื้นดิน
    _MilitarySymbol(
      name: 'Infantry',
      thaiName: 'ทหารราบ',
      symbolCode: '⚔',
      category: 'หน่วยภาคพื้นดิน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยทหารราบ ทำหน้าที่รบภาคพื้นดิน ยึดและรักษาพื้นที่',
    ),
    _MilitarySymbol(
      name: 'Armor',
      thaiName: 'ทหารม้า (ยานเกราะ)',
      symbolCode: '⬭',
      category: 'หน่วยภาคพื้นดิน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยยานเกราะ ใช้รถถังและยานเกราะในการรบ',
    ),
    _MilitarySymbol(
      name: 'Artillery',
      thaiName: 'ทหารปืนใหญ่',
      symbolCode: '●',
      category: 'หน่วยภาคพื้นดิน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยปืนใหญ่ ให้การยิงสนับสนุนระยะไกล',
    ),
    _MilitarySymbol(
      name: 'Air Defense',
      thaiName: 'ทหารป้องกันภัยทางอากาศ',
      symbolCode: '⌒',
      category: 'หน่วยภาคพื้นดิน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยป้องกันภัยทางอากาศ ใช้ขีปนาวุธและปืนต่อสู้อากาศยาน',
    ),
    _MilitarySymbol(
      name: 'Engineer',
      thaiName: 'ทหารช่าง',
      symbolCode: '⌂',
      category: 'หน่วยสนับสนุน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยทหารช่าง ก่อสร้าง ทำลาย และสะพาน',
    ),

    // หน่วยสื่อสาร
    _MilitarySymbol(
      name: 'Signal',
      thaiName: 'ทหารสื่อสาร',
      symbolCode: '⚡',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยทหารสื่อสาร ดำเนินการสื่อสารและระบบสารสนเทศ',
    ),
    _MilitarySymbol(
      name: 'Electronic Warfare',
      thaiName: 'สงครามอิเล็กทรอนิกส์',
      symbolCode: 'EW',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'กองร้อย',
      description: 'หน่วยสงครามอิเล็กทรอนิกส์ ดำเนินการ EA, ES, EP',
    ),
    _MilitarySymbol(
      name: 'SIGINT',
      thaiName: 'ข่าวกรองสัญญาณ',
      symbolCode: 'SI',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'กองร้อย',
      description: 'หน่วยข่าวกรองสัญญาณ รวบรวมและวิเคราะห์ SIGINT',
    ),
    _MilitarySymbol(
      name: 'Direction Finding',
      thaiName: 'หาทิศทาง',
      symbolCode: 'DF',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'หมวด',
      description: 'หน่วยหาทิศทาง ระบุตำแหน่งแหล่งกำเนิดสัญญาณ',
    ),
    _MilitarySymbol(
      name: 'Jamming',
      thaiName: 'รบกวนสัญญาณ',
      symbolCode: 'J',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'หมวด',
      description: 'หน่วยรบกวนสัญญาณ ดำเนินการ ECM',
    ),
    _MilitarySymbol(
      name: 'Cyber',
      thaiName: 'ไซเบอร์',
      symbolCode: 'CY',
      category: 'หน่วยสื่อสาร',
      affiliation: 'friendly',
      echelon: 'กองร้อย',
      description: 'หน่วยปฏิบัติการไซเบอร์ ทั้งรุกและรับ',
    ),

    // หน่วยสนับสนุน
    _MilitarySymbol(
      name: 'Medical',
      thaiName: 'การแพทย์',
      symbolCode: '✚',
      category: 'หน่วยสนับสนุน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยการแพทย์ ให้การรักษาพยาบาลและอพยพผู้บาดเจ็บ',
    ),
    _MilitarySymbol(
      name: 'Supply',
      thaiName: 'ส่งกำลังบำรุง',
      symbolCode: 'S',
      category: 'หน่วยสนับสนุน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยส่งกำลังบำรุง จัดหาและแจกจ่ายสิ่งอุปกรณ์',
    ),
    _MilitarySymbol(
      name: 'Maintenance',
      thaiName: 'ซ่อมบำรุง',
      symbolCode: '⚙',
      category: 'หน่วยสนับสนุน',
      affiliation: 'friendly',
      echelon: 'กองร้อย',
      description: 'หน่วยซ่อมบำรุง ซ่อมแซมยุทโธปกรณ์',
    ),
    _MilitarySymbol(
      name: 'Transportation',
      thaiName: 'ขนส่ง',
      symbolCode: '⊿',
      category: 'หน่วยสนับสนุน',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'หน่วยขนส่ง ลำเลียงกำลังพลและสิ่งอุปกรณ์',
    ),

    // อุปกรณ์
    _MilitarySymbol(
      name: 'Unmanned Aircraft',
      thaiName: 'อากาศยานไร้คนขับ',
      symbolCode: 'UAV',
      category: 'อุปกรณ์',
      affiliation: 'friendly',
      echelon: '-',
      description: 'โดรน/UAV ใช้ในภารกิจลาดตระเวนและโจมตี',
    ),
    _MilitarySymbol(
      name: 'Radar',
      thaiName: 'เรดาร์',
      symbolCode: 'R',
      category: 'อุปกรณ์',
      affiliation: 'friendly',
      echelon: '-',
      description: 'สถานีเรดาร์ ตรวจจับเป้าหมายทางอากาศและภาคพื้น',
    ),
    _MilitarySymbol(
      name: 'Radio',
      thaiName: 'วิทยุ',
      symbolCode: '📻',
      category: 'อุปกรณ์',
      affiliation: 'friendly',
      echelon: '-',
      description: 'สถานีวิทยุสื่อสาร',
    ),
    _MilitarySymbol(
      name: 'Satellite Ground Station',
      thaiName: 'สถานีดาวเทียมภาคพื้น',
      symbolCode: '📡',
      category: 'อุปกรณ์',
      affiliation: 'friendly',
      echelon: '-',
      description: 'สถานีรับ-ส่งสัญญาณดาวเทียม',
    ),

    // กิจกรรม
    _MilitarySymbol(
      name: 'Command Post',
      thaiName: 'ที่บัญชาการ',
      symbolCode: 'CP',
      category: 'กิจกรรม',
      affiliation: 'friendly',
      echelon: 'กองพล',
      description: 'ที่ตั้งของกองบัญชาการหน่วย',
    ),
    _MilitarySymbol(
      name: 'Observation Post',
      thaiName: 'ที่ตรวจการณ์',
      symbolCode: 'OP',
      category: 'กิจกรรม',
      affiliation: 'friendly',
      echelon: 'หมู่',
      description: 'จุดตรวจการณ์และเฝ้าระวัง',
    ),
    _MilitarySymbol(
      name: 'Assembly Area',
      thaiName: 'พื้นที่รวมพล',
      symbolCode: 'AA',
      category: 'กิจกรรม',
      affiliation: 'friendly',
      echelon: 'กองพัน',
      description: 'พื้นที่รวมพลก่อนปฏิบัติภารกิจ',
    ),
    _MilitarySymbol(
      name: 'Hostile Unit',
      thaiName: 'หน่วยศัตรู',
      symbolCode: '?',
      category: 'หน่วยภาคพื้นดิน',
      affiliation: 'hostile',
      echelon: 'ไม่ทราบ',
      description: 'หน่วยศัตรูที่ถูกตรวจพบ ยังไม่ระบุประเภท',
    ),
  ];
}

class _MilitarySymbol {
  final String name;
  final String thaiName;
  final String symbolCode;
  final String category;
  final String affiliation;
  final String echelon;
  final String description;

  _MilitarySymbol({
    required this.name,
    required this.thaiName,
    required this.symbolCode,
    required this.category,
    required this.affiliation,
    required this.echelon,
    required this.description,
  });

  Color get affiliationColor {
    switch (affiliation) {
      case 'friendly':
        return Colors.blue;
      case 'hostile':
        return Colors.red;
      case 'neutral':
        return Colors.green;
      default:
        return Colors.yellow.shade700;
    }
  }
}
