import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../data/ew_study_data.dart';

/// หน้าจอสถานการณ์จำลอง EW สำหรับฝึกปฏิบัติ
class EWScenariosScreen extends StatefulWidget {
  const EWScenariosScreen({super.key});

  @override
  State<EWScenariosScreen> createState() => _EWScenariosScreenState();
}

class _EWScenariosScreenState extends State<EWScenariosScreen> {
  int _selectedScenarioIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('สถานการณ์จำลอง'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Scenario Selector
          Container(
            height: 100,
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: EWStudyScenarios.scenarios.length,
              itemBuilder: (context, index) {
                final scenario = EWStudyScenarios.scenarios[index];
                final isSelected = index == _selectedScenarioIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedScenarioIndex = index),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'สถานการณ์ ${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          scenario.title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Scenario Content
          Expanded(
            child: _ScenarioDetail(
              scenario: EWStudyScenarios.scenarios[_selectedScenarioIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioDetail extends StatefulWidget {
  final StudyScenario scenario;

  const _ScenarioDetail({required this.scenario});

  @override
  State<_ScenarioDetail> createState() => _ScenarioDetailState();
}

class _ScenarioDetailState extends State<_ScenarioDetail> {
  bool _showHints = false;
  int _currentStep = 0; // 0=situation, 1=questions, 2=answers

  @override
  void didUpdateWidget(covariant _ScenarioDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scenario.id != widget.scenario.id) {
      setState(() {
        _showHints = false;
        _currentStep = 0;
      });
    }
  }

  Color get _difficultyColor {
    switch (widget.scenario.difficulty) {
      case 'พื้นฐาน':
        return Colors.green;
      case 'กลาง':
        return Colors.orange;
      case 'สูง':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.scenario.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _difficultyColor.withAlpha(30),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ระดับ: ${widget.scenario.difficulty}',
                        style: TextStyle(
                          color: _difficultyColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Step Indicator
          _buildStepIndicator(),

          const SizedBox(height: 24),

          // Content based on step
          if (_currentStep == 0) _buildSituationCard(),
          if (_currentStep >= 1) _buildQuestionsCard(),
          if (_currentStep >= 2) _buildAnswersCard(),

          const SizedBox(height: 24),

          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepDot(0, 'สถานการณ์'),
        Expanded(child: Container(height: 2, color: _currentStep >= 1 ? AppColors.primary : AppColors.border)),
        _buildStepDot(1, 'คำถาม'),
        Expanded(child: Container(height: 2, color: _currentStep >= 2 ? AppColors.primary : AppColors.border)),
        _buildStepDot(2, 'เฉลย'),
      ],
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSituationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withAlpha(30),
            Colors.blue.withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'สถานการณ์',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.scenario.situation,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'คำถามที่ต้องตอบ',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Hint Button
              TextButton.icon(
                onPressed: () => setState(() => _showHints = !_showHints),
                icon: Icon(
                  _showHints ? Icons.lightbulb : Icons.lightbulb_outline,
                  size: 18,
                  color: _showHints ? Colors.yellow : AppColors.textMuted,
                ),
                label: Text(
                  _showHints ? 'ซ่อนคำใบ้' : 'ดูคำใบ้',
                  style: TextStyle(
                    color: _showHints ? Colors.yellow : AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Questions
          ...widget.scenario.questions.asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
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
                          entry.value,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        // Hint
                        if (_showHints && entry.key < widget.scenario.hints.length) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.yellow.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.yellow.withAlpha(50)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lightbulb, size: 14, color: Colors.yellow),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.scenario.hints[entry.key],
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
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
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswersCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withAlpha(30),
            Colors.green.withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Text(
                'เฉลยและคำอธิบาย',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Answers
          ...widget.scenario.answers.entries.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final answer = entry.value.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 14, color: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คำตอบข้อ ${index + 1}:',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          answer,
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
          }),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _currentStep--),
              icon: const Icon(Icons.arrow_back),
              label: const Text('ย้อนกลับ'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentStep < 2
                ? () => setState(() => _currentStep++)
                : null,
            icon: Icon(_currentStep < 2 ? Icons.arrow_forward : Icons.check),
            label: Text(_currentStep == 0
                ? 'ดูคำถาม'
                : _currentStep == 1
                    ? 'ดูเฉลย'
                    : 'เสร็จสิ้น'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentStep < 2 ? AppColors.primary : AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}