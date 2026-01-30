import 'package:flutter/material.dart';
import 'lessons/lesson_basics.dart';
import 'services/progress_service.dart';

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

  EWLesson({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.contentBuilder,
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
class LessonDetailPage extends StatelessWidget {
  final EWLesson lesson;
  const LessonDetailPage({super.key, required this.lesson});

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
            lesson.title,
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
              lesson.contentBuilder(context),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lesson.color.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Mark lesson as completed
                    ProgressService.completeLesson(lesson.id);
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
