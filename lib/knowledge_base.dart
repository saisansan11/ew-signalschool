import 'package:flutter/material.dart';
import 'lessons/lesson_basics.dart';
import 'services/progress_service.dart';
import 'screens/tools/global_search_screen.dart';

// ==========================================
// 1. DATA MODEL (โครงสร้างข้อมูล)
// ==========================================
class EWLesson {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final WidgetBuilder contentBuilder;
  final List<String> learningObjectives; // วัตถุประสงค์การเรียนรู้
  final int estimatedMinutes; // เวลาโดยประมาณ (นาที)
  final String difficulty; // ระดับความยาก: 'beginner', 'intermediate', 'advanced'

  EWLesson({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.contentBuilder,
    this.learningObjectives = const [],
    this.estimatedMinutes = 15,
    this.difficulty = 'beginner',
  });
}

// ==========================================
// 2. MAIN MENU CONFIGURATION (สารบัญ)
// ==========================================
final List<EWLesson> ewLessons = [
  // บทที่ 1: ภาพรวม EW
  EWLesson(
    id: 'lesson_1',
    category: 'บทที่ 1',
    title: 'ภาพรวม EW',
    subtitle: 'นิยาม + แนะนำ 3 องค์ประกอบ',
    icon: Icons.school,
    color: Colors.blueAccent,
    contentBuilder: (c) => const Lesson1_Basics(),
    estimatedMinutes: 15,
    difficulty: 'beginner',
    learningObjectives: [
      'อธิบายความหมายของ Electronic Warfare (EW) ได้',
      'แยกแยะองค์ประกอบ 3 ส่วนของ EW: ES, EA, EP',
      'เข้าใจบทบาทของ EW ในสนามรบสมัยใหม่',
    ],
  ),
  // บทที่ 2: สเปกตรัม
  EWLesson(
    id: 'lesson_2',
    category: 'บทที่ 2',
    title: 'สเปกตรัมแม่เหล็กไฟฟ้า',
    subtitle: 'HF, VHF, UHF, SHF',
    icon: Icons.graphic_eq,
    color: Colors.purpleAccent,
    contentBuilder: (c) => const Lesson2_Spectrum(),
    estimatedMinutes: 20,
    difficulty: 'beginner',
    learningObjectives: [
      'อธิบายคุณสมบัติของคลื่นแม่เหล็กไฟฟ้าได้',
      'แยกแยะย่านความถี่ HF, VHF, UHF, SHF และการใช้งาน',
      'เข้าใจความสัมพันธ์ระหว่างความถี่ ความยาวคลื่น และระยะทาง',
    ],
  ),
  // บทที่ 3: ESM
  EWLesson(
    id: 'lesson_3',
    category: 'บทที่ 3',
    title: 'ESM (Electronic Support Measures)',
    subtitle: 'การดักรับ, DF, ELINT, COMINT',
    icon: Icons.hearing,
    color: Colors.amber,
    contentBuilder: (c) => const Lesson3_ESM(),
    estimatedMinutes: 25,
    difficulty: 'intermediate',
    learningObjectives: [
      'อธิบายหน้าที่และความสำคัญของ ESM ได้',
      'แยกแยะ SIGINT, ELINT, COMINT ได้',
      'เข้าใจหลักการ Direction Finding (DF)',
      'ประยุกต์ใช้ข้อมูล ESM ในการวางแผนภารกิจ',
    ],
  ),
  // บทที่ 4: ECM
  EWLesson(
    id: 'lesson_4',
    category: 'บทที่ 4',
    title: 'ECM (Electronic Countermeasures)',
    subtitle: 'Jamming: Spot, Barrage, Sweep',
    icon: Icons.flash_on,
    color: Colors.redAccent,
    contentBuilder: (c) => const Lesson4_ECM(),
    estimatedMinutes: 30,
    difficulty: 'intermediate',
    learningObjectives: [
      'อธิบายหลักการทำงานของ ECM ได้',
      'แยกแยะเทคนิค Jamming: Spot, Barrage, Sweep',
      'คำนวณ J/S Ratio เบื้องต้นได้',
      'เลือกเทคนิค Jamming ที่เหมาะสมกับสถานการณ์',
    ],
  ),
  // บทที่ 5: ECCM
  EWLesson(
    id: 'lesson_5',
    category: 'บทที่ 5',
    title: 'ECCM (Electronic Counter-Countermeasures)',
    subtitle: 'การป้องกันจากการรบกวน',
    icon: Icons.shield,
    color: Colors.green,
    contentBuilder: (c) => const Lesson5_ECCM(),
    estimatedMinutes: 25,
    difficulty: 'intermediate',
    learningObjectives: [
      'อธิบายหลักการ ECCM/EPM ได้',
      'เข้าใจเทคนิค Frequency Hopping (FHSS)',
      'ปฏิบัติตามขั้นตอนป้องกันเมื่อถูกรบกวน',
      'เลือกมาตรการ EPM ที่เหมาะสมกับภัยคุกคาม',
    ],
  ),
  // บทที่ 6: วิทยุสื่อสาร
  EWLesson(
    id: 'lesson_6',
    category: 'บทที่ 6',
    title: 'วิทยุสื่อสารทางยุทธวิธี',
    subtitle: 'ประเภทวิทยุ และ COMSEC',
    icon: Icons.radio,
    color: Colors.teal,
    contentBuilder: (c) => const Lesson6_Radio(),
    estimatedMinutes: 25,
    difficulty: 'beginner',
    learningObjectives: [
      'แยกแยะประเภทวิทยุสื่อสารทางทหารได้',
      'เข้าใจหลักการ COMSEC และ TRANSEC',
      'ปฏิบัติตามระเบียบวิทยุสื่อสารได้ถูกต้อง',
    ],
  ),
  // บทที่ 7: Anti-Drone
  EWLesson(
    id: 'lesson_7',
    category: 'บทที่ 7',
    title: 'Anti-Drone EW',
    subtitle: 'การตรวจจับและต่อต้านโดรน',
    icon: Icons.airplanemode_active,
    color: Colors.cyan,
    contentBuilder: (c) => const Lesson7_AntiDrone(),
    estimatedMinutes: 30,
    difficulty: 'intermediate',
    learningObjectives: [
      'อธิบายภัยคุกคามจากโดรนในสนามรบได้',
      'แยกแยะวิธีการตรวจจับโดรน: RF, Radar, Optical',
      'เข้าใจเทคนิคต่อต้านโดรนด้วย EW',
      'ประเมินภัยคุกคามและเลือกมาตรการตอบโต้',
    ],
  ),
  // บทที่ 8: GPS Warfare
  EWLesson(
    id: 'lesson_8',
    category: 'บทที่ 8',
    title: 'GPS Warfare',
    subtitle: 'Jamming, Spoofing และการป้องกัน',
    icon: Icons.gps_fixed,
    color: Colors.green,
    contentBuilder: (c) => const Lesson8_GPS(),
    estimatedMinutes: 25,
    difficulty: 'advanced',
    learningObjectives: [
      'อธิบายหลักการทำงานของระบบ GPS ได้',
      'แยกแยะ GPS Jamming และ Spoofing',
      'ตรวจจับสัญญาณ GPS ถูกรบกวนหรือหลอก',
      'ใช้วิธีนำทางทางเลือกเมื่อ GPS ใช้งานไม่ได้',
    ],
  ),
  // บทที่ 9: กรณีศึกษา
  EWLesson(
    id: 'lesson_9',
    category: 'บทที่ 9',
    title: 'กรณีศึกษา EW',
    subtitle: 'เรียนรู้จากปฏิบัติการจริง',
    icon: Icons.cases,
    color: Colors.deepPurple,
    contentBuilder: (c) => const Lesson9_CaseStudies(),
    estimatedMinutes: 25,
    difficulty: 'advanced',
    learningObjectives: [
      'วิเคราะห์กรณีศึกษา EW จากสงครามจริงได้',
      'ระบุบทเรียนที่ได้จากปฏิบัติการ EW',
      'ประยุกต์ใช้บทเรียนในการวางแผนภารกิจ',
    ],
  ),
  // บทที่ 10: ระบบเรดาร์
  EWLesson(
    id: 'lesson_10',
    category: 'บทที่ 10',
    title: 'ระบบเรดาร์ (Radar Systems)',
    subtitle: 'Pulse, Doppler, SAR และสมการเรดาร์',
    icon: Icons.radar,
    color: Colors.cyan,
    contentBuilder: (c) => const Lesson10_Radar(),
    estimatedMinutes: 35,
    difficulty: 'advanced',
    learningObjectives: [
      'อธิบายหลักการทำงานของเรดาร์ได้',
      'แยกแยะประเภทเรดาร์: Pulse, CW, Doppler, SAR',
      'เข้าใจสมการเรดาร์เบื้องต้น',
      'วิเคราะห์จุดอ่อนของเรดาร์สำหรับการรบกวน',
    ],
  ),
];

// ==========================================
// 3. MAIN PAGE (หน้าเมนูหลัก)
// ==========================================
class KnowledgeBasePage extends StatelessWidget {
  const KnowledgeBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: AppBar(
        title: const Text("คลังความรู้ EW"),
        backgroundColor: const Color(0xFF263238),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'ค้นหา',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GlobalSearchScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ewLessons.length,
        itemBuilder: (context, index) {
          final lesson = ewLessons[index];
          return Card(
            color: Colors.white10,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailPage(lesson: lesson),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: lesson.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: lesson.color.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(lesson.icon, color: lesson.color, size: 30),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.category,
                            style: TextStyle(
                              color: lesson.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lesson.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            lesson.subtitle,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white24,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. DETAIL PAGE (หน้ารายละเอียด)
// ==========================================
class LessonDetailPage extends StatefulWidget {
  final EWLesson lesson;
  const LessonDetailPage({super.key, required this.lesson});

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  bool _showObjectives = true;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B1B1B),
        appBar: AppBar(
          elevation: 2,
          title: Text(
            widget.lesson.title,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: const Color(0xFF263238),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          toolbarHeight: 50,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Learning Objectives Card
              if (widget.lesson.learningObjectives.isNotEmpty)
                _buildLearningObjectivesCard(),

              // Lesson Content
              widget.lesson.contentBuilder(context),

              const SizedBox(height: 30),

              // Complete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.lesson.color.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ProgressService.completeLesson(widget.lesson.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  label: const Text(
                    "เข้าใจแล้ว",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningObjectivesCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.lesson.color.withOpacity(0.15),
            widget.lesson.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.lesson.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          // Header with toggle
          InkWell(
            onTap: () => setState(() => _showObjectives = !_showObjectives),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.flag,
                    color: widget.lesson.color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'วัตถุประสงค์การเรียนรู้',
                          style: TextStyle(
                            color: widget.lesson.color,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'เมื่อจบบทเรียนนี้ ผู้เรียนจะสามารถ:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Metadata badges
                  _buildBadge(
                    '${widget.lesson.estimatedMinutes} นาที',
                    Icons.timer_outlined,
                  ),
                  const SizedBox(width: 6),
                  _buildDifficultyBadge(),
                  const SizedBox(width: 8),
                  Icon(
                    _showObjectives ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white54,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Objectives List (collapsible)
          if (_showObjectives)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: widget.lesson.learningObjectives.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: widget.lesson.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: TextStyle(
                                color: widget.lesson.color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white54),
          const SizedBox(width: 3),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    String label;
    switch (widget.lesson.difficulty) {
      case 'beginner':
        badgeColor = Colors.green;
        label = 'พื้นฐาน';
        break;
      case 'intermediate':
        badgeColor = Colors.orange;
        label = 'กลาง';
        break;
      case 'advanced':
        badgeColor = Colors.red;
        label = 'สูง';
        break;
      default:
        badgeColor = Colors.grey;
        label = widget.lesson.difficulty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// --- Placeholder ---
class PlaceholderLesson extends StatelessWidget {
  final String title;
  const PlaceholderLesson({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "เนื้อหาส่วนนี้กำลังอยู่ระหว่างการพัฒนา\nโปรดติดตามการอัปเดตครั้งถัดไป",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
