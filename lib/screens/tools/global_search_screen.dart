import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/bookmark_service.dart';
import '../../knowledge_base.dart';
import 'glossary_screen.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _query = '';
  Set<_SearchCategory> _selectedCategories = {
    _SearchCategory.lessons,
    _SearchCategory.glossary,
    _SearchCategory.tools,
    _SearchCategory.flashcards,
  };
  List<_SearchResult> _results = [];
  List<String> _recentSearches = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    // Auto focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadRecentSearches() {
    // In production, load from SharedPreferences
    _recentSearches = [
      'jamming',
      'ESM',
      'spectrum',
      'radar',
      'GPS spoofing',
    ];
  }

  void _saveRecentSearch(String query) {
    if (query.isEmpty) return;
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.sublist(0, 10);
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _query = query;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted || _query != query) return;

      final results = <_SearchResult>[];
      final lowerQuery = query.toLowerCase();

      // Search lessons
      if (_selectedCategories.contains(_SearchCategory.lessons)) {
        results.addAll(_searchLessons(lowerQuery));
      }

      // Search glossary
      if (_selectedCategories.contains(_SearchCategory.glossary)) {
        results.addAll(_searchGlossary(lowerQuery));
      }

      // Search tools
      if (_selectedCategories.contains(_SearchCategory.tools)) {
        results.addAll(_searchTools(lowerQuery));
      }

      // Search flashcards
      if (_selectedCategories.contains(_SearchCategory.flashcards)) {
        results.addAll(_searchFlashcards(lowerQuery));
      }

      // Sort by relevance (match at start > match in middle)
      results.sort((a, b) {
        final aStartsWith = a.title.toLowerCase().startsWith(lowerQuery);
        final bStartsWith = b.title.toLowerCase().startsWith(lowerQuery);
        if (aStartsWith && !bStartsWith) return -1;
        if (!aStartsWith && bStartsWith) return 1;
        return a.title.compareTo(b.title);
      });

      setState(() {
        _results = results;
        _isSearching = false;
      });
    });
  }

  List<_SearchResult> _searchLessons(String query) {
    final results = <_SearchResult>[];

    // EW Lessons data
    final lessons = [
      _LessonData(0, 'EW Fundamentals', 'พื้นฐานสงครามอิเล็กทรอนิกส์',
          'สเปกตรัมแม่เหล็กไฟฟ้า ความถี่ คลื่นวิทยุ การแพร่กระจายคลื่น'),
      _LessonData(1, 'Spectrum Analysis', 'การวิเคราะห์สเปกตรัม',
          'การวิเคราะห์สเปกตรัม FFT spectrum analyzer waterfall display'),
      _LessonData(2, 'ESM - Electronic Support', 'มาตรการสนับสนุนอิเล็กทรอนิกส์',
          'SIGINT ELINT COMINT การดักสัญญาณ direction finding'),
      _LessonData(3, 'ECM - Electronic Countermeasures', 'มาตรการต่อต้านอิเล็กทรอนิกส์',
          'jamming noise jamming barrage jamming deception jamming'),
      _LessonData(4, 'ECCM - Counter-Countermeasures', 'การป้องกันการจัม',
          'frequency hopping spread spectrum anti-jam techniques'),
      _LessonData(5, 'Radio Communications', 'การสื่อสารทางวิทยุ',
          'HF VHF UHF radio frequency modulation AM FM'),
      _LessonData(6, 'COMSEC', 'การรักษาความปลอดภัยการสื่อสาร',
          'encryption decryption cryptography secure communications'),
      _LessonData(7, 'Radar Technology', 'เทคโนโลยีเรดาร์',
          'radar pulse PRF PRI radar cross section RCS'),
      _LessonData(8, 'GPS Warfare', 'สงคราม GPS',
          'GPS jamming GPS spoofing GNSS navigation warfare'),
    ];

    for (final lesson in lessons) {
      final searchText =
          '${lesson.title} ${lesson.subtitle} ${lesson.keywords}'.toLowerCase();
      if (searchText.contains(query)) {
        results.add(_SearchResult(
          title: lesson.title,
          subtitle: lesson.subtitle,
          category: _SearchCategory.lessons,
          icon: Icons.menu_book,
          color: AppColors.primary,
          data: lesson.index,
          matchedText: _getMatchedText(searchText, query),
        ));
      }
    }

    return results;
  }

  List<_SearchResult> _searchGlossary(String query) {
    final results = <_SearchResult>[];

    // Key glossary terms
    final terms = [
      _GlossaryTerm('Jamming', 'การรบกวน', 'การส่งสัญญาณรบกวนเพื่อขัดขวางการสื่อสาร'),
      _GlossaryTerm('ESM', 'มาตรการสนับสนุน EW', 'Electronic Support Measures - การตรวจจับสัญญาณ'),
      _GlossaryTerm('ECM', 'มาตรการต่อต้าน', 'Electronic Countermeasures - การรบกวนสัญญาณ'),
      _GlossaryTerm('ECCM', 'การป้องกันการจัม', 'Electronic Counter-Countermeasures'),
      _GlossaryTerm('Spectrum', 'สเปกตรัม', 'ช่วงความถี่ของคลื่นแม่เหล็กไฟฟ้า'),
      _GlossaryTerm('SIGINT', 'ข่าวกรองสัญญาณ', 'Signals Intelligence - การรวบรวมข่าวกรองจากสัญญาณ'),
      _GlossaryTerm('ELINT', 'ข่าวกรองอิเล็กทรอนิกส์', 'Electronic Intelligence'),
      _GlossaryTerm('COMINT', 'ข่าวกรองการสื่อสาร', 'Communications Intelligence'),
      _GlossaryTerm('Radar', 'เรดาร์', 'Radio Detection and Ranging'),
      _GlossaryTerm('PRF', 'อัตราการซ้ำพัลส์', 'Pulse Repetition Frequency'),
      _GlossaryTerm('GPS Spoofing', 'การหลอก GPS', 'การส่งสัญญาณ GPS ปลอมเพื่อหลอกเครื่องรับ'),
      _GlossaryTerm('Frequency Hopping', 'การกระโดดความถี่', 'เทคนิคการเปลี่ยนความถี่อย่างรวดเร็ว'),
      _GlossaryTerm('Spread Spectrum', 'สเปกตรัมแผ่', 'เทคนิคการกระจายสัญญาณในหลายความถี่'),
      _GlossaryTerm('RCS', 'พื้นที่หน้าตัดเรดาร์', 'Radar Cross Section'),
      _GlossaryTerm('Direction Finding', 'การหาทิศทาง', 'การหาตำแหน่งแหล่งกำเนิดสัญญาณ'),
      _GlossaryTerm('Barrage Jamming', 'การจัมแบบปูพรม', 'การรบกวนหลายความถี่พร้อมกัน'),
      _GlossaryTerm('Spot Jamming', 'การจัมจุด', 'การรบกวนความถี่เดียวอย่างเข้มข้น'),
      _GlossaryTerm('Deception Jamming', 'การจัมหลอกลวง', 'การส่งสัญญาณปลอมเพื่อหลอกระบบเรดาร์'),
      _GlossaryTerm('Anti-Drone', 'ต่อต้านโดรน', 'ระบบตรวจจับและต่อต้านอากาศยานไร้คนขับ'),
      _GlossaryTerm('C-UAS', 'ต่อต้าน UAS', 'Counter-Unmanned Aircraft Systems'),
      _GlossaryTerm('EW', 'สงครามอิเล็กทรอนิกส์', 'Electronic Warfare'),
      _GlossaryTerm('RF', 'ความถี่วิทยุ', 'Radio Frequency'),
      _GlossaryTerm('Modulation', 'การกล้ำสัญญาณ', 'กระบวนการใส่ข้อมูลลงในคลื่นพาหะ'),
      _GlossaryTerm('Demodulation', 'การถอดกล้ำ', 'กระบวนการแยกข้อมูลออกจากคลื่นพาหะ'),
      _GlossaryTerm('Antenna', 'เสาอากาศ', 'อุปกรณ์แปลงสัญญาณไฟฟ้าเป็นคลื่นวิทยุ'),
    ];

    for (final term in terms) {
      final searchText =
          '${term.term} ${term.thai} ${term.definition}'.toLowerCase();
      if (searchText.contains(query)) {
        results.add(_SearchResult(
          title: term.term,
          subtitle: term.thai,
          category: _SearchCategory.glossary,
          icon: Icons.auto_stories,
          color: AppColors.success,
          data: term.term,
          matchedText: term.definition,
        ));
      }
    }

    return results;
  }

  List<_SearchResult> _searchTools(String query) {
    final results = <_SearchResult>[];

    final tools = [
      _ToolData('Spectrum Analyzer', 'เครื่องวิเคราะห์สเปกตรัม', 'spectrum frequency analysis'),
      _ToolData('Frequency Chart', 'ตารางความถี่', 'frequency bands HF VHF UHF'),
      _ToolData('Phonetic Alphabet', 'รหัสตัวอักษร', 'NATO phonetic alphabet alpha bravo'),
      _ToolData('UAV Database', 'ฐานข้อมูลโดรน', 'drone UAV specifications database'),
      _ToolData('Signal Calculator', 'เครื่องคำนวณสัญญาณ', 'path loss link budget calculator'),
      _ToolData('Practice Mode', 'โหมดฝึกซ้อม', 'quiz practice review spaced repetition'),
      _ToolData('Study Timer', 'จับเวลาเรียน', 'pomodoro timer study focus'),
      _ToolData('Glossary', 'คลังศัพท์', 'EW terminology glossary dictionary'),
      _ToolData('Flashcards', 'บัตรคำ', 'flashcard memory review'),
      _ToolData('Tactical Simulator', 'จำลองยุทธวิธี', 'simulation tactical scenario'),
    ];

    for (final tool in tools) {
      final searchText =
          '${tool.name} ${tool.thai} ${tool.keywords}'.toLowerCase();
      if (searchText.contains(query)) {
        results.add(_SearchResult(
          title: tool.name,
          subtitle: tool.thai,
          category: _SearchCategory.tools,
          icon: Icons.build,
          color: AppColors.warning,
          data: tool.name,
          matchedText: tool.keywords,
        ));
      }
    }

    return results;
  }

  List<_SearchResult> _searchFlashcards(String query) {
    final results = <_SearchResult>[];

    final cards = [
      _FlashcardData('EMS คืออะไร?', 'Electromagnetic Spectrum - สเปกตรัมคลื่นแม่เหล็กไฟฟ้า'),
      _FlashcardData('ESM ย่อมาจาก?', 'Electronic Support Measures'),
      _FlashcardData('ECM ย่อมาจาก?', 'Electronic Countermeasures'),
      _FlashcardData('ECCM ย่อมาจาก?', 'Electronic Counter-Countermeasures'),
      _FlashcardData('Jamming คือ?', 'การรบกวนสัญญาณทางอิเล็กทรอนิกส์'),
      _FlashcardData('PRF ย่อมาจาก?', 'Pulse Repetition Frequency'),
      _FlashcardData('RCS ย่อมาจาก?', 'Radar Cross Section'),
      _FlashcardData('SIGINT ย่อมาจาก?', 'Signals Intelligence'),
      _FlashcardData('COMSEC ย่อมาจาก?', 'Communications Security'),
      _FlashcardData('C-UAS ย่อมาจาก?', 'Counter-Unmanned Aircraft Systems'),
    ];

    for (final card in cards) {
      final searchText = '${card.question} ${card.answer}'.toLowerCase();
      if (searchText.contains(query)) {
        results.add(_SearchResult(
          title: card.question,
          subtitle: card.answer,
          category: _SearchCategory.flashcards,
          icon: Icons.quiz,
          color: AppColors.tabLearning,
          data: card.question,
          matchedText: card.answer,
        ));
      }
    }

    return results;
  }

  String _getMatchedText(String text, String query) {
    final index = text.indexOf(query);
    if (index == -1) return '';

    final start = (index - 20).clamp(0, text.length);
    final end = (index + query.length + 30).clamp(0, text.length);
    var snippet = text.substring(start, end);

    if (start > 0) snippet = '...$snippet';
    if (end < text.length) snippet = '$snippet...';

    return snippet;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'ค้นหาบทเรียน, คำศัพท์, เครื่องมือ...',
            hintStyle: const TextStyle(color: AppColors.textMuted),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppColors.textMuted),
                    onPressed: () {
                      _searchController.clear();
                      _performSearch('');
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            _performSearch(value);
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _saveRecentSearch(value);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filters
          _buildCategoryFilters(),

          // Results or suggestions
          Expanded(
            child: _query.isEmpty
                ? _buildSuggestions()
                : _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? _buildNoResults()
                        : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _SearchCategory.values.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(category.label),
                avatar: Icon(
                  category.icon,
                  size: 16,
                  color: isSelected ? Colors.white : category.color,
                ),
                selectedColor: category.color,
                checkmarkColor: Colors.white,
                backgroundColor: AppColors.surfaceLight,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontSize: 12,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCategories.add(category);
                    } else {
                      _selectedCategories.remove(category);
                    }
                  });
                  if (_query.isNotEmpty) {
                    _performSearch(_query);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.history, color: AppColors.textMuted, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'การค้นหาล่าสุด',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _recentSearches.clear();
                    });
                  },
                  child: const Text('ล้าง', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return ActionChip(
                  label: Text(search),
                  backgroundColor: AppColors.surfaceLight,
                  labelStyle: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                  onPressed: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Popular searches
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              const Text(
                'คำค้นหายอดนิยม',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPopularSearchItem('ECM', 'Electronic Countermeasures'),
          _buildPopularSearchItem('GPS Spoofing', 'การหลอก GPS'),
          _buildPopularSearchItem('Frequency Hopping', 'การกระโดดความถี่'),
          _buildPopularSearchItem('Radar', 'เรดาร์'),
          _buildPopularSearchItem('SIGINT', 'Signals Intelligence'),

          const SizedBox(height: 24),

          // Quick links
          const Row(
            children: [
              Icon(Icons.bolt, color: AppColors.warning, size: 18),
              SizedBox(width: 8),
              Text(
                'เข้าถึงด่วน',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickLink(
                  Icons.auto_stories,
                  'Glossary',
                  AppColors.success,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GlossaryScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickLink(
                  Icons.menu_book,
                  'Lessons',
                  AppColors.primary,
                  () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSearchItem(String term, String description) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.search, color: AppColors.primary, size: 18),
      ),
      title: Text(
        term,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
        ),
      ),
      onTap: () {
        _searchController.text = term;
        _performSearch(term);
      },
    );
  }

  Widget _buildQuickLink(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textMuted.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบผลลัพธ์สำหรับ "$_query"',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ลองค้นหาด้วยคำอื่น หรือปรับตัวกรอง',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    // Group results by category
    final grouped = <_SearchCategory, List<_SearchResult>>{};
    for (final result in _results) {
      grouped.putIfAbsent(result.category, () => []);
      grouped[result.category]!.add(result);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'พบ ${_results.length} ผลลัพธ์',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),

        // Results by category
        ...grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(entry.key.icon, color: entry.key.color, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      entry.key.label,
                      style: TextStyle(
                        color: entry.key.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: entry.key.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${entry.value.length}',
                        style: TextStyle(
                          color: entry.key.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Results
              ...entry.value.map((result) => _buildResultCard(result)),

              const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildResultCard(_SearchResult result) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: result.color.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(result.icon, color: result.color, size: 22),
        ),
        title: _highlightText(result.title, _query),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                result.subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
            if (result.matchedText.isNotEmpty) ...[
              const SizedBox(height: 4),
              _highlightText(
                result.matchedText,
                _query,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bookmark button
            BookmarkButton(
              itemId: 'search_${result.category.name}_${result.title.replaceAll(' ', '_')}',
              type: _getBookmarkType(result.category),
              title: result.title,
              subtitle: result.subtitle,
              size: 20,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
        onTap: () => _onResultTap(result),
      ),
    );
  }

  Widget _highlightText(String text, String query, {TextStyle? style}) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return Text(text, style: style);
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    final baseStyle = style ?? const TextStyle(color: AppColors.textPrimary);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: before, style: baseStyle),
          TextSpan(
            text: match,
            style: baseStyle.copyWith(
              backgroundColor: AppColors.warning.withAlpha(50),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: after, style: baseStyle),
        ],
      ),
    );
  }

  BookmarkType _getBookmarkType(_SearchCategory category) {
    switch (category) {
      case _SearchCategory.lessons:
        return BookmarkType.lesson;
      case _SearchCategory.glossary:
        return BookmarkType.glossaryTerm;
      case _SearchCategory.flashcards:
        return BookmarkType.flashcard;
      case _SearchCategory.tools:
        return BookmarkType.referenceCard;
    }
  }

  void _onResultTap(_SearchResult result) {
    _saveRecentSearch(_query);

    switch (result.category) {
      case _SearchCategory.lessons:
        final lessonIndex = result.data as int;
        if (lessonIndex >= 0 && lessonIndex < ewLessons.length) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LessonDetailPage(lesson: ewLessons[lessonIndex]),
            ),
          );
        }
        break;
      case _SearchCategory.glossary:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GlossaryScreen()),
        );
        break;
      case _SearchCategory.tools:
        // Navigate to specific tool
        Navigator.pop(context);
        break;
      case _SearchCategory.flashcards:
        // Navigate to flashcards
        Navigator.pop(context);
        break;
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune, color: AppColors.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'ตัวกรองการค้นหา',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setSheetState(() {
                          _selectedCategories = Set.from(_SearchCategory.values);
                        });
                        setState(() {});
                      },
                      child: const Text('เลือกทั้งหมด'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'ประเภทเนื้อหา',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ..._SearchCategory.values.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      setSheetState(() {
                        if (value == true) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                      setState(() {});
                      if (_query.isNotEmpty) {
                        _performSearch(_query);
                      }
                    },
                    title: Text(
                      category.label,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    secondary: Icon(category.icon, color: category.color),
                    activeColor: category.color,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                }),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Enums and data classes
enum _SearchCategory {
  lessons('บทเรียน', Icons.menu_book, AppColors.primary),
  glossary('คำศัพท์', Icons.auto_stories, AppColors.success),
  tools('เครื่องมือ', Icons.build, AppColors.warning),
  flashcards('บัตรคำ', Icons.quiz, AppColors.tabLearning);

  final String label;
  final IconData icon;
  final Color color;

  const _SearchCategory(this.label, this.icon, this.color);
}

class _SearchResult {
  final String title;
  final String subtitle;
  final _SearchCategory category;
  final IconData icon;
  final Color color;
  final dynamic data;
  final String matchedText;

  _SearchResult({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    this.data,
    this.matchedText = '',
  });
}

class _LessonData {
  final int index;
  final String title;
  final String subtitle;
  final String keywords;

  _LessonData(this.index, this.title, this.subtitle, this.keywords);
}

class _GlossaryTerm {
  final String term;
  final String thai;
  final String definition;

  _GlossaryTerm(this.term, this.thai, this.definition);
}

class _ToolData {
  final String name;
  final String thai;
  final String keywords;

  _ToolData(this.name, this.thai, this.keywords);
}

class _FlashcardData {
  final String question;
  final String answer;

  _FlashcardData(this.question, this.answer);
}

// Bookmark Button Widget
class BookmarkButton extends StatelessWidget {
  final String itemId;
  final BookmarkType type;
  final String title;
  final String? subtitle;
  final double size;

  const BookmarkButton({
    super.key,
    required this.itemId,
    required this.type,
    required this.title,
    this.subtitle,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: bookmarkService,
      builder: (context, _) {
        final isBookmarked = bookmarkService.isBookmarked(itemId);
        return GestureDetector(
          onTap: () async {
            await bookmarkService.toggleBookmark(
              id: itemId,
              type: type,
              title: title,
              subtitle: subtitle,
            );
          },
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookmarked ? AppColors.warning : AppColors.textMuted,
            size: size,
          ),
        );
      },
    );
  }
}
