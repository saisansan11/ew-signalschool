import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/bookmark_service.dart';
import '../../services/progress_service.dart';

class PracticeModeScreen extends StatefulWidget {
  const PracticeModeScreen({super.key});

  @override
  State<PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends State<PracticeModeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _totalAnswered = 0;
  bool _showAnswer = false;
  bool _isSessionActive = false;
  List<_PracticeQuestion> _questions = [];
  _PracticeMode _selectedMode = _PracticeMode.quickReview;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    bookmarkService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              'PRACTICE MODE',
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
            bottom: _isSessionActive
                ? null
                : TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor:
                        isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    indicatorColor: AppColors.primary,
                    tabs: const [
                      Tab(icon: Icon(Icons.flash_on), text: 'Quick'),
                      Tab(icon: Icon(Icons.repeat), text: 'Spaced'),
                      Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
                      Tab(icon: Icon(Icons.abc), text: 'Terms'),
                    ],
                  ),
          ),
          body: _isSessionActive
              ? _buildPracticeSession(isDark)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildQuickReviewTab(isDark),
                    _buildSpacedRepetitionTab(isDark),
                    _buildQuizPracticeTab(isDark),
                    _buildTermsReviewTab(isDark),
                  ],
                ),
        );
      },
    );
  }

  // Quick Review Tab - Review bookmarked items
  Widget _buildQuickReviewTab(bool isDark) {
    final bookmarks = bookmarkService.bookmarks;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModeCard(
            isDark: isDark,
            icon: Icons.flash_on,
            title: 'Quick Review',
            description: 'ทบทวนเนื้อหาที่ Bookmark ไว้อย่างรวดเร็ว',
            color: Colors.amber,
            stats: '${bookmarks.length} รายการ',
            onStart: bookmarks.isNotEmpty
                ? () => _startQuickReview()
                : null,
          ),
          const SizedBox(height: 24),

          // Bookmarked items preview
          Text(
            'รายการที่ Bookmark ล่าสุด',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (bookmarks.isEmpty)
            _buildEmptyState(
              isDark: isDark,
              icon: Icons.bookmark_border,
              message: 'ยังไม่มีรายการที่ Bookmark\nเพิ่ม Bookmark เพื่อทบทวน',
            )
          else
            ...bookmarks.take(5).map((b) => _buildBookmarkPreview(b, isDark)),
        ],
      ),
    );
  }

  // Spaced Repetition Tab
  Widget _buildSpacedRepetitionTab(bool isDark) {
    final dueItems = _getDueForReview();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModeCard(
            isDark: isDark,
            icon: Icons.repeat,
            title: 'Spaced Repetition',
            description: 'ทบทวนตามหลักการเว้นระยะเพื่อจำได้นานขึ้น',
            color: Colors.purple,
            stats: '${dueItems.length} รายการ ครบกำหนด',
            onStart: () => _startSpacedRepetition(),
          ),
          const SizedBox(height: 24),

          // Explanation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withAlpha(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.purple, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Spaced Repetition คืออะไร?',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'หลักการทบทวนที่เว้นระยะห่างเพิ่มขึ้นเรื่อยๆ ช่วยให้จำได้นานขึ้น โดยระบบจะคำนวณเวลาที่เหมาะสมในการทบทวนแต่ละหัวข้อ',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Progress Stats
          _buildProgressStats(isDark),
        ],
      ),
    );
  }

  // Quiz Practice Tab
  Widget _buildQuizPracticeTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModeCard(
            isDark: isDark,
            icon: Icons.quiz,
            title: 'Quiz Practice',
            description: 'ฝึกทำ Quiz แบบสุ่มจากหลายหัวข้อ',
            color: Colors.blue,
            stats: '${_getAvailableQuizQuestions()} คำถาม',
            onStart: () => _startQuizPractice(),
          ),
          const SizedBox(height: 24),

          Text(
            'เลือกจำนวนคำถาม',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _buildQuizCountOption(5, isDark),
              const SizedBox(width: 12),
              _buildQuizCountOption(10, isDark),
              const SizedBox(width: 12),
              _buildQuizCountOption(20, isDark),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'หมวดหมู่',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildCategoryChip('ทุกหมวด', true, isDark),
              _buildCategoryChip('EW พื้นฐาน', false, isDark),
              _buildCategoryChip('ESM/ELINT', false, isDark),
              _buildCategoryChip('ECM/Jamming', false, isDark),
              _buildCategoryChip('Radar', false, isDark),
            ],
          ),
        ],
      ),
    );
  }

  // Terms Review Tab
  Widget _buildTermsReviewTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildModeCard(
            isDark: isDark,
            icon: Icons.abc,
            title: 'Terms Review',
            description: 'ทบทวนคำศัพท์ EW แบบ Flashcard',
            color: Colors.green,
            stats: '96 คำศัพท์',
            onStart: () => _startTermsReview(),
          ),
          const SizedBox(height: 24),

          Text(
            'เลือกหมวดคำศัพท์',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          _buildTermCategoryList(isDark),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String stats,
    VoidCallback? onStart,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withAlpha(30),
            color.withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stats,
                      style: TextStyle(
                        color: color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: const Text('เริ่มทบทวน'),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkPreview(BookmarkItem bookmark, bool isDark) {
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
          Icon(
            _getBookmarkIcon(bookmark.type),
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookmark.title,
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                if (bookmark.subtitle != null)
                  Text(
                    bookmark.subtitle!,
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

  Widget _buildEmptyState({
    required bool isDark,
    required IconData icon,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStats(bool isDark) {
    return Container(
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
          Text(
            'สถิติการทบทวน',
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.check_circle,
                  value: '24',
                  label: 'เรียนรู้แล้ว',
                  color: Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.refresh,
                  value: '8',
                  label: 'ต้องทบทวน',
                  color: Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  isDark: isDark,
                  icon: Icons.trending_up,
                  value: '85%',
                  label: 'ความแม่นยำ',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required bool isDark,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizCountOption(int count, bool isDark) {
    final isSelected = count == 10; // Default selection

    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue.withAlpha(30)
                : (isDark ? AppColors.surface : AppColorsLight.surface),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : (isDark ? AppColors.border : AppColorsLight.border),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: isSelected
                      ? Colors.blue
                      : (isDark ? AppColors.textPrimary : AppColorsLight.textPrimary),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'คำถาม',
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, bool isDark) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
      selectedColor: Colors.blue.withAlpha(30),
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.blue
            : (isDark ? AppColors.textSecondary : AppColorsLight.textSecondary),
      ),
      side: BorderSide(
        color: isSelected ? Colors.blue : (isDark ? AppColors.border : AppColorsLight.border),
      ),
    );
  }

  Widget _buildTermCategoryList(bool isDark) {
    final categories = [
      ('EW พื้นฐาน', 12, Colors.blue),
      ('ESM/ELINT', 12, Colors.purple),
      ('ECM/Jamming', 18, Colors.red),
      ('ECCM/EP', 11, Colors.green),
      ('Radar', 14, Colors.orange),
      ('Communications', 12, Colors.cyan),
      ('Anti-Drone/C-UAS', 11, Colors.teal),
      ('Cyber EW', 11, Colors.pink),
    ];

    return Column(
      children: categories.map((cat) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surface : AppColorsLight.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.border : AppColorsLight.border,
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cat.$3.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.folder, color: cat.$3),
            ),
            title: Text(
              cat.$1,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${cat.$2} คำศัพท์',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
            ),
            onTap: () => _startTermsReviewByCategory(cat.$1),
          ),
        );
      }).toList(),
    );
  }

  // Practice Session UI
  Widget _buildPracticeSession(bool isDark) {
    if (_questions.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),

        // Question counter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'คำถามที่ ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(
                  color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$_correctAnswers',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Question
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surface : AppColorsLight.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.border : AppColorsLight.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        question.question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      if (_showAnswer) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withAlpha(50)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'คำตอบ',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.answer,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                if (!_showAnswer)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _showAnswer = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'แสดงคำตอบ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _answerQuestion(false),
                          icon: const Icon(Icons.close),
                          label: const Text('ยังไม่แม่น'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _answerQuestion(true),
                          icon: const Icon(Icons.check),
                          label: const Text('จำได้'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  IconData _getBookmarkIcon(BookmarkType type) {
    switch (type) {
      case BookmarkType.lesson:
        return Icons.school;
      case BookmarkType.flashcard:
        return Icons.style;
      case BookmarkType.glossaryTerm:
        return Icons.abc;
      case BookmarkType.referenceCard:
        return Icons.dashboard;
      case BookmarkType.scenario:
        return Icons.map;
    }
  }

  List<String> _getDueForReview() {
    // Simplified - in production, use actual spaced repetition algorithm
    return ['item1', 'item2', 'item3', 'item4', 'item5', 'item6', 'item7', 'item8'];
  }

  int _getAvailableQuizQuestions() {
    return 50; // Simplified
  }

  void _startQuickReview() {
    final bookmarks = bookmarkService.bookmarks;
    _questions = bookmarks.map((b) => _PracticeQuestion(
      question: b.title,
      answer: b.subtitle ?? 'ไม่มีคำอธิบาย',
      type: _PracticeType.flashcard,
    )).toList();

    if (_questions.isNotEmpty) {
      setState(() {
        _selectedMode = _PracticeMode.quickReview;
        _isSessionActive = true;
        _currentQuestionIndex = 0;
        _correctAnswers = 0;
        _totalAnswered = 0;
        _showAnswer = false;
      });
    }
  }

  void _startSpacedRepetition() {
    // Generate sample questions for spaced repetition
    _questions = _generateSampleQuestions();
    _questions.shuffle();

    setState(() {
      _selectedMode = _PracticeMode.spacedRepetition;
      _isSessionActive = true;
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _totalAnswered = 0;
      _showAnswer = false;
    });
  }

  void _startQuizPractice() {
    _questions = _generateSampleQuestions();
    _questions.shuffle();
    _questions = _questions.take(10).toList();

    setState(() {
      _selectedMode = _PracticeMode.quizPractice;
      _isSessionActive = true;
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _totalAnswered = 0;
      _showAnswer = false;
    });
  }

  void _startTermsReview() {
    _questions = _generateTermQuestions();
    _questions.shuffle();

    setState(() {
      _selectedMode = _PracticeMode.termsReview;
      _isSessionActive = true;
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _totalAnswered = 0;
      _showAnswer = false;
    });
  }

  void _startTermsReviewByCategory(String category) {
    _questions = _generateTermQuestions(category: category);
    _questions.shuffle();

    setState(() {
      _selectedMode = _PracticeMode.termsReview;
      _isSessionActive = true;
      _currentQuestionIndex = 0;
      _correctAnswers = 0;
      _totalAnswered = 0;
      _showAnswer = false;
    });
  }

  void _answerQuestion(bool correct) {
    setState(() {
      _totalAnswered++;
      if (correct) _correctAnswers++;
      _showAnswer = false;

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // End of session
        _showSessionComplete();
      }
    });
  }

  void _showSessionComplete() {
    final percentage = (_correctAnswers / _totalAnswered * 100).round();
    final xpEarned = _correctAnswers * 5;

    ProgressService.addXp(xpEarned);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode ? AppColors.surface : AppColorsLight.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.sentiment_satisfied,
              color: percentage >= 70 ? Colors.amber : Colors.blue,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              'จบการทบทวน!',
              style: TextStyle(
                color: themeProvider.isDarkMode ? AppColors.textPrimary : AppColorsLight.textPrimary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'คุณตอบถูก $_correctAnswers จาก $_totalAnswered ข้อ',
              style: TextStyle(
                color: themeProvider.isDarkMode ? AppColors.textSecondary : AppColorsLight.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildResultStat('$percentage%', 'ความแม่นยำ', Colors.blue),
                const SizedBox(width: 24),
                _buildResultStat('+$xpEarned', 'XP', Colors.amber),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSessionActive = false;
              });
            },
            child: const Text('กลับหน้าหลัก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Restart same mode
              switch (_selectedMode) {
                case _PracticeMode.quickReview:
                  _startQuickReview();
                  break;
                case _PracticeMode.spacedRepetition:
                  _startSpacedRepetition();
                  break;
                case _PracticeMode.quizPractice:
                  _startQuizPractice();
                  break;
                case _PracticeMode.termsReview:
                  _startTermsReview();
                  break;
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('ทบทวนอีกครั้ง', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: themeProvider.isDarkMode ? AppColors.textMuted : AppColorsLight.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<_PracticeQuestion> _generateSampleQuestions() {
    return [
      _PracticeQuestion(
        question: 'Electronic Warfare (EW) คืออะไร?',
        answer: 'การปฏิบัติการทางทหารที่ใช้พลังงานแม่เหล็กไฟฟ้าเพื่อควบคุมสเปกตรัม หรือโจมตีศัตรู',
        type: _PracticeType.definition,
      ),
      _PracticeQuestion(
        question: 'ESM ย่อมาจากอะไร?',
        answer: 'Electronic Support Measures - มาตรการสนับสนุนอิเล็กทรอนิกส์',
        type: _PracticeType.abbreviation,
      ),
      _PracticeQuestion(
        question: 'Jamming คืออะไร?',
        answer: 'การแผ่พลังงานแม่เหล็กไฟฟ้าเพื่อรบกวนระบบอิเล็กทรอนิกส์ของศัตรู',
        type: _PracticeType.definition,
      ),
      _PracticeQuestion(
        question: 'PRF ย่อมาจากอะไร?',
        answer: 'Pulse Repetition Frequency - ความถี่ซ้ำของพัลส์',
        type: _PracticeType.abbreviation,
      ),
      _PracticeQuestion(
        question: 'ECCM มีจุดประสงค์อะไร?',
        answer: 'ลดผลกระทบของ ECM ของศัตรู ทำให้ระบบทำงานได้แม้มีการรบกวน',
        type: _PracticeType.definition,
      ),
      _PracticeQuestion(
        question: 'GPS Spoofing คืออะไร?',
        answer: 'การส่งสัญญาณ GPS ปลอมเพื่อหลอกเครื่องรับให้คำนวณตำแหน่งผิด',
        type: _PracticeType.definition,
      ),
      _PracticeQuestion(
        question: 'DRFM ใช้ทำอะไร?',
        answer: 'บันทึกสัญญาณเรดาร์แล้วส่งกลับในรูปแบบที่ดัดแปลง สร้างเป้าหมายปลอม',
        type: _PracticeType.definition,
      ),
      _PracticeQuestion(
        question: 'RWR ย่อมาจากอะไร?',
        answer: 'Radar Warning Receiver - เครื่องเตือนเรดาร์',
        type: _PracticeType.abbreviation,
      ),
    ];
  }

  List<_PracticeQuestion> _generateTermQuestions({String? category}) {
    // Sample terms - in production, load from glossary
    final allTerms = [
      ('Electronic Warfare', 'สงครามอิเล็กทรอนิกส์', 'EW พื้นฐาน'),
      ('Electronic Support', 'การสนับสนุนอิเล็กทรอนิกส์', 'EW พื้นฐาน'),
      ('Electronic Attack', 'การโจมตีอิเล็กทรอนิกส์', 'EW พื้นฐาน'),
      ('Electronic Protection', 'การป้องกันอิเล็กทรอนิกส์', 'EW พื้นฐาน'),
      ('Jamming', 'การรบกวนสัญญาณ', 'ECM/Jamming'),
      ('Noise Jamming', 'การรบกวนแบบสัญญาณรบกวน', 'ECM/Jamming'),
      ('Deception Jamming', 'การรบกวนแบบหลอกลวง', 'ECM/Jamming'),
      ('Direction Finding', 'การหาทิศทาง', 'ESM/ELINT'),
      ('Pulse Repetition Frequency', 'ความถี่ซ้ำของพัลส์', 'Radar'),
      ('Phased Array', 'เฟสอาร์เรย์', 'Radar'),
      ('Frequency Hopping', 'การกระโดดความถี่', 'ECCM/EP'),
      ('GPS Spoofing', 'การหลอก GPS', 'ECM/Jamming'),
    ];

    final filtered = category != null
        ? allTerms.where((t) => t.$3 == category).toList()
        : allTerms;

    return filtered.map((t) => _PracticeQuestion(
      question: '${t.$1} ภาษาไทยคืออะไร?',
      answer: t.$2,
      type: _PracticeType.translation,
    )).toList();
  }
}

// Helper classes
enum _PracticeMode {
  quickReview,
  spacedRepetition,
  quizPractice,
  termsReview,
}

enum _PracticeType {
  flashcard,
  definition,
  abbreviation,
  translation,
}

class _PracticeQuestion {
  final String question;
  final String answer;
  final _PracticeType type;

  _PracticeQuestion({
    required this.question,
    required this.answer,
    required this.type,
  });
}
