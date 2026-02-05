import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../data/ew_study_data.dart';

/// หน้าจอคำศัพท์ EW สำหรับนักเรียนทบทวนก่อนสอบ
class EWGlossaryScreen extends StatefulWidget {
  const EWGlossaryScreen({super.key});

  @override
  State<EWGlossaryScreen> createState() => _EWGlossaryScreenState();
}

class _EWGlossaryScreenState extends State<EWGlossaryScreen> {
  String _selectedCategory = 'ทั้งหมด';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> get _categories => ['ทั้งหมด', ...EWGlossary.categories];

  List<GlossaryTerm> get _filteredTerms {
    List<GlossaryTerm> terms = EWGlossary.terms;

    // Filter by category
    if (_selectedCategory != 'ทั้งหมด') {
      terms = terms.where((t) => t.category == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      terms = terms.where((t) {
        final lowerQuery = _searchQuery.toLowerCase();
        return t.term.toLowerCase().contains(lowerQuery) ||
            t.definition.toLowerCase().contains(lowerQuery) ||
            (t.fullForm?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    return terms;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('คำศัพท์ EW'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            tooltip: 'ทดสอบคำศัพท์',
            onPressed: () => _showVocabQuiz(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'ค้นหาคำศัพท์...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
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
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    backgroundColor: AppColors.surfaceLight,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'พบ ${_filteredTerms.length} คำ',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Terms List
          Expanded(
            child: _filteredTerms.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTerms.length,
                    itemBuilder: (context, index) {
                      return _buildTermCard(_filteredTerms[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
          const Text(
            'ไม่พบคำศัพท์',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermCard(GlossaryTerm term) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor(term.category).withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              term.term.length > 4 ? term.term.substring(0, 4) : term.term,
              style: TextStyle(
                color: _getCategoryColor(term.category),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              term.term,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (term.fullForm != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '(${term.fullForm})',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _getCategoryColor(term.category).withAlpha(20),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            term.category,
            style: TextStyle(
              color: _getCategoryColor(term.category),
              fontSize: 10,
            ),
          ),
        ),
        iconColor: AppColors.textMuted,
        collapsedIconColor: AppColors.textMuted,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ความหมาย:',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  term.definition,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'พื้นฐาน':
        return Colors.blue;
      case '3 เสาหลัก':
        return Colors.amber;
      case 'การป้องกัน':
        return Colors.green;
      case 'ECM':
        return Colors.red;
      case 'ข่าวกรอง':
        return Colors.purple;
      case 'ยุทธวิธี':
        return Colors.orange;
      case 'ความถี่':
        return Colors.cyan;
      default:
        return AppColors.primary;
    }
  }

  void _showVocabQuiz(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _VocabQuizSheet(),
    );
  }
}

/// Quiz Sheet สำหรับทดสอบคำศัพท์
class _VocabQuizSheet extends StatefulWidget {
  const _VocabQuizSheet();

  @override
  State<_VocabQuizSheet> createState() => _VocabQuizSheetState();
}

class _VocabQuizSheetState extends State<_VocabQuizSheet> {
  late List<GlossaryTerm> _quizTerms;
  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswer;
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _initQuiz();
  }

  void _initQuiz() {
    // Shuffle and take 10 terms for quiz
    _quizTerms = List.from(EWGlossary.terms)..shuffle();
    _quizTerms = _quizTerms.take(10).toList();
    _generateOptions();
  }

  void _generateOptions() {
    final currentTerm = _quizTerms[_currentIndex];
    final allDefinitions = EWGlossary.terms.map((t) => t.definition).toList();
    allDefinitions.shuffle();

    // Get 3 wrong answers
    _options = allDefinitions
        .where((d) => d != currentTerm.definition)
        .take(3)
        .toList();

    // Add correct answer and shuffle
    _options.add(currentTerm.definition);
    _options.shuffle();
  }

  void _checkAnswer(int index) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = index;
      if (_options[index] == _quizTerms[_currentIndex].definition) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _quizTerms.length - 1) {
      setState(() {
        _currentIndex++;
        _answered = false;
        _selectedAnswer = null;
        _generateOptions();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          _score >= 7 ? 'ยอดเยี่ยม!' : _score >= 5 ? 'ดีมาก!' : 'พยายามต่อไป!',
          style: const TextStyle(color: AppColors.textPrimary),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_score / ${_quizTerms.length}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _score >= 7
                    ? AppColors.success
                    : _score >= 5
                        ? AppColors.warning
                        : AppColors.danger,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'คะแนน ${(_score * 10)}%',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('ปิด'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _answered = false;
                _selectedAnswer = null;
                _initQuiz();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('เล่นอีกครั้ง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTerm = _quizTerms[_currentIndex];
    final correctIndex = _options.indexOf(currentTerm.definition);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ทดสอบคำศัพท์',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${_quizTerms.length}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _quizTerms.length,
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Term Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withAlpha(30),
                          AppColors.primary.withAlpha(10),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withAlpha(50)),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'คำศัพท์',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentTerm.term,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (currentTerm.fullForm != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            currentTerm.fullForm!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'เลือกความหมายที่ถูกต้อง:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options
                  ...List.generate(_options.length, (index) {
                    final isSelected = _selectedAnswer == index;
                    final isCorrect = index == correctIndex;
                    Color bgColor = AppColors.surfaceLight;
                    Color borderColor = AppColors.border;

                    if (_answered) {
                      if (isCorrect) {
                        bgColor = AppColors.success.withAlpha(30);
                        borderColor = AppColors.success;
                      } else if (isSelected && !isCorrect) {
                        bgColor = AppColors.danger.withAlpha(30);
                        borderColor = AppColors.danger;
                      }
                    } else if (isSelected) {
                      borderColor = AppColors.primary;
                    }

                    return GestureDetector(
                      onTap: () => _checkAnswer(index),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: borderColor.withAlpha(30),
                                border: Border.all(color: borderColor),
                              ),
                              child: Center(
                                child: _answered
                                    ? Icon(
                                        isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                                        size: 16,
                                        color: isCorrect ? AppColors.success : AppColors.danger,
                                      )
                                    : Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _options[index],
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Next Button
          if (_answered)
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _quizTerms.length - 1 ? 'ถัดไป' : 'ดูผลลัพธ์',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}