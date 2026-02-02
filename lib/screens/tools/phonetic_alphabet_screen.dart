import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

class PhoneticAlphabetScreen extends StatefulWidget {
  const PhoneticAlphabetScreen({super.key});

  @override
  State<PhoneticAlphabetScreen> createState() => _PhoneticAlphabetScreenState();
}

class _PhoneticAlphabetScreenState extends State<PhoneticAlphabetScreen> {
  String _selectedTab = 'alphabet';

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Text(
              'NATO PHONETIC',
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
              // Tab Selector
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surface : AppColorsLight.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.border : AppColorsLight.border,
                  ),
                ),
                child: Row(
                  children: [
                    _buildTabButton('alphabet', 'ตัวอักษร A-Z', isDark),
                    _buildTabButton('numbers', 'ตัวเลข 0-9', isDark),
                    _buildTabButton('prowords', 'Prowords', isDark),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _selectedTab == 'alphabet'
                    ? _buildAlphabetGrid(isDark)
                    : _selectedTab == 'numbers'
                        ? _buildNumbersGrid(isDark)
                        : _buildProwordslist(isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String tab, String label, bool isDark) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetGrid(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _phoneticAlphabet.length,
      itemBuilder: (context, index) {
        final item = _phoneticAlphabet[index];
        return _buildLetterCard(item, isDark);
      },
    );
  }

  Widget _buildLetterCard(_PhoneticItem item, bool isDark) {
    return Container(
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
          // Letter
          Text(
            item.letter,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Phonetic word
          Text(
            item.word,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          // Pronunciation
          Text(
            item.pronunciation,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumbersGrid(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Numbers Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.9,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _phoneticNumbers.length,
          itemBuilder: (context, index) {
            final item = _phoneticNumbers[index];
            return _buildNumberCard(item, isDark);
          },
        ),
        const SizedBox(height: 24),
        // Special Numbers
        _buildSectionHeader('ตัวเลขพิเศษ', isDark),
        const SizedBox(height: 12),
        ..._specialNumbers.map((item) => _buildSpecialNumberRow(item, isDark)),
      ],
    );
  }

  Widget _buildNumberCard(_PhoneticItem item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.letter,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.word,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            item.pronunciation,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialNumberRow(_PhoneticItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item.letter,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
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
                  item.word,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.pronunciation,
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
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

  Widget _buildProwordslist(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Banner
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withAlpha(50)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Prowords คือคำสั่งมาตรฐานที่ใช้ในการสื่อสารทางวิทยุ',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._prowords.map((item) => _buildProwordCard(item, isDark)),
      ],
    );
  }

  Widget _buildProwordCard(_Proword item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.category == 'เริ่มต้น/สิ้นสุด'
                      ? Colors.green.withAlpha(30)
                      : item.category == 'ยืนยัน/ตอบรับ'
                          ? Colors.blue.withAlpha(30)
                          : item.category == 'แก้ไข/ทวน'
                              ? Colors.orange.withAlpha(30)
                              : Colors.purple.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.category,
                  style: TextStyle(
                    color: item.category == 'เริ่มต้น/สิ้นสุด'
                        ? Colors.green
                        : item.category == 'ยืนยัน/ตอบรับ'
                            ? Colors.blue
                            : item.category == 'แก้ไข/ทวน'
                                ? Colors.orange
                                : Colors.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.word,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.meaning,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 13,
            ),
          ),
          if (item.example != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.background : AppColorsLight.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    size: 16,
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.example!,
                      style: TextStyle(
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // NATO Phonetic Alphabet Data
  final List<_PhoneticItem> _phoneticAlphabet = [
    _PhoneticItem(letter: 'A', word: 'Alpha', pronunciation: 'AL-fah'),
    _PhoneticItem(letter: 'B', word: 'Bravo', pronunciation: 'BRAH-voh'),
    _PhoneticItem(letter: 'C', word: 'Charlie', pronunciation: 'CHAR-lee'),
    _PhoneticItem(letter: 'D', word: 'Delta', pronunciation: 'DELL-tah'),
    _PhoneticItem(letter: 'E', word: 'Echo', pronunciation: 'ECK-oh'),
    _PhoneticItem(letter: 'F', word: 'Foxtrot', pronunciation: 'FOKS-trot'),
    _PhoneticItem(letter: 'G', word: 'Golf', pronunciation: 'GOLF'),
    _PhoneticItem(letter: 'H', word: 'Hotel', pronunciation: 'hoh-TELL'),
    _PhoneticItem(letter: 'I', word: 'India', pronunciation: 'IN-dee-ah'),
    _PhoneticItem(letter: 'J', word: 'Juliet', pronunciation: 'JEW-lee-ett'),
    _PhoneticItem(letter: 'K', word: 'Kilo', pronunciation: 'KEY-loh'),
    _PhoneticItem(letter: 'L', word: 'Lima', pronunciation: 'LEE-mah'),
    _PhoneticItem(letter: 'M', word: 'Mike', pronunciation: 'MIKE'),
    _PhoneticItem(letter: 'N', word: 'November', pronunciation: 'no-VEM-ber'),
    _PhoneticItem(letter: 'O', word: 'Oscar', pronunciation: 'OSS-car'),
    _PhoneticItem(letter: 'P', word: 'Papa', pronunciation: 'pah-PAH'),
    _PhoneticItem(letter: 'Q', word: 'Quebec', pronunciation: 'keh-BECK'),
    _PhoneticItem(letter: 'R', word: 'Romeo', pronunciation: 'ROW-me-oh'),
    _PhoneticItem(letter: 'S', word: 'Sierra', pronunciation: 'see-AIR-rah'),
    _PhoneticItem(letter: 'T', word: 'Tango', pronunciation: 'TANG-go'),
    _PhoneticItem(letter: 'U', word: 'Uniform', pronunciation: 'YOU-nee-form'),
    _PhoneticItem(letter: 'V', word: 'Victor', pronunciation: 'VIK-ter'),
    _PhoneticItem(letter: 'W', word: 'Whiskey', pronunciation: 'WISS-key'),
    _PhoneticItem(letter: 'X', word: 'X-ray', pronunciation: 'ECKS-ray'),
    _PhoneticItem(letter: 'Y', word: 'Yankee', pronunciation: 'YANG-key'),
    _PhoneticItem(letter: 'Z', word: 'Zulu', pronunciation: 'ZOO-loo'),
  ];

  final List<_PhoneticItem> _phoneticNumbers = [
    _PhoneticItem(letter: '0', word: 'Zero', pronunciation: 'ZEE-ro'),
    _PhoneticItem(letter: '1', word: 'One', pronunciation: 'WUN'),
    _PhoneticItem(letter: '2', word: 'Two', pronunciation: 'TOO'),
    _PhoneticItem(letter: '3', word: 'Three', pronunciation: 'TREE'),
    _PhoneticItem(letter: '4', word: 'Four', pronunciation: 'FOW-er'),
    _PhoneticItem(letter: '5', word: 'Five', pronunciation: 'FIFE'),
    _PhoneticItem(letter: '6', word: 'Six', pronunciation: 'SIX'),
    _PhoneticItem(letter: '7', word: 'Seven', pronunciation: 'SEV-en'),
    _PhoneticItem(letter: '8', word: 'Eight', pronunciation: 'AIT'),
    _PhoneticItem(letter: '9', word: 'Nine', pronunciation: 'NIN-er'),
  ];

  final List<_PhoneticItem> _specialNumbers = [
    _PhoneticItem(letter: '00', word: 'Zero Zero', pronunciation: 'ศูนย์สองตัว'),
    _PhoneticItem(letter: '100', word: 'One Hundred', pronunciation: 'หนึ่งร้อย'),
    _PhoneticItem(letter: '1000', word: 'One Thousand', pronunciation: 'หนึ่งพัน'),
    _PhoneticItem(letter: '.', word: 'Decimal', pronunciation: 'DAY-SEE-mal'),
    _PhoneticItem(letter: '-', word: 'Dash', pronunciation: 'DASH'),
  ];

  final List<_Proword> _prowords = [
    // เริ่มต้น/สิ้นสุด
    _Proword(
      word: 'THIS IS...',
      meaning: 'ใช้เพื่อระบุตนเอง ตามด้วยนามเรียกขาน',
      category: 'เริ่มต้น/สิ้นสุด',
      example: 'THIS IS ALPHA ONE',
    ),
    _Proword(
      word: 'OVER',
      meaning: 'จบการส่งข้อความ รอรับคำตอบ',
      category: 'เริ่มต้น/สิ้นสุด',
      example: 'Request status update, OVER',
    ),
    _Proword(
      word: 'OUT',
      meaning: 'จบการสนทนา ไม่ต้องตอบ',
      category: 'เริ่มต้น/สิ้นสุด',
      example: 'Message received, OUT',
    ),
    _Proword(
      word: 'BREAK',
      meaning: 'แยกส่วนของข้อความ หรือหยุดชั่วคราว',
      category: 'เริ่มต้น/สิ้นสุด',
      example: 'Grid 123456, BREAK, time 0800',
    ),

    // ยืนยัน/ตอบรับ
    _Proword(
      word: 'ROGER',
      meaning: 'ได้รับข้อความแล้ว เข้าใจแล้ว',
      category: 'ยืนยัน/ตอบรับ',
      example: 'ROGER, moving to objective',
    ),
    _Proword(
      word: 'WILCO',
      meaning: 'Will Comply - จะปฏิบัติตาม',
      category: 'ยืนยัน/ตอบรับ',
      example: 'WILCO, proceeding to rally point',
    ),
    _Proword(
      word: 'AFFIRMATIVE',
      meaning: 'ใช่ ถูกต้อง',
      category: 'ยืนยัน/ตอบรับ',
      example: 'AFFIRMATIVE, target confirmed',
    ),
    _Proword(
      word: 'NEGATIVE',
      meaning: 'ไม่ใช่ ไม่ถูกต้อง',
      category: 'ยืนยัน/ตอบรับ',
      example: 'NEGATIVE, cannot comply',
    ),

    // แก้ไข/ทวน
    _Proword(
      word: 'SAY AGAIN',
      meaning: 'ขอให้พูดซ้ำ',
      category: 'แก้ไข/ทวน',
      example: 'SAY AGAIN your last transmission',
    ),
    _Proword(
      word: 'I SAY AGAIN',
      meaning: 'ฉันจะพูดซ้ำ',
      category: 'แก้ไข/ทวน',
      example: 'I SAY AGAIN, grid 123456',
    ),
    _Proword(
      word: 'CORRECTION',
      meaning: 'มีการแก้ไข ข้อความถูกต้องคือ...',
      category: 'แก้ไข/ทวน',
      example: 'CORRECTION, time is 0900',
    ),
    _Proword(
      word: 'WORDS TWICE',
      meaning: 'ส่งคำละสองครั้ง (สัญญาณไม่ดี)',
      category: 'แก้ไข/ทวน',
    ),
    _Proword(
      word: 'READ BACK',
      meaning: 'ขอให้อ่านทวนข้อความ',
      category: 'แก้ไข/ทวน',
      example: 'READ BACK my last message',
    ),

    // สถานะ/ความเร่งด่วน
    _Proword(
      word: 'WAIT',
      meaning: 'รอสักครู่ จะกลับมาภายใน 5 วินาที',
      category: 'สถานะ/ความเร่งด่วน',
    ),
    _Proword(
      word: 'WAIT OUT',
      meaning: 'รอ จะติดต่อกลับเมื่อพร้อม',
      category: 'สถานะ/ความเร่งด่วน',
    ),
    _Proword(
      word: 'PRIORITY',
      meaning: 'ข้อความเร่งด่วน',
      category: 'สถานะ/ความเร่งด่วน',
      example: 'PRIORITY, enemy contact',
    ),
    _Proword(
      word: 'IMMEDIATE',
      meaning: 'ข้อความเร่งด่วนที่สุด',
      category: 'สถานะ/ความเร่งด่วน',
      example: 'IMMEDIATE, troops in contact',
    ),
    _Proword(
      word: 'RADIO CHECK',
      meaning: 'ทดสอบการรับส่ง',
      category: 'สถานะ/ความเร่งด่วน',
      example: 'ALPHA ONE, RADIO CHECK, OVER',
    ),
    _Proword(
      word: 'LOUD AND CLEAR',
      meaning: 'รับสัญญาณดีมาก',
      category: 'สถานะ/ความเร่งด่วน',
      example: 'ROGER, LOUD AND CLEAR',
    ),
  ];
}

class _PhoneticItem {
  final String letter;
  final String word;
  final String pronunciation;

  _PhoneticItem({
    required this.letter,
    required this.word,
    required this.pronunciation,
  });
}

class _Proword {
  final String word;
  final String meaning;
  final String category;
  final String? example;

  _Proword({
    required this.word,
    required this.meaning,
    required this.category,
    this.example,
  });
}
