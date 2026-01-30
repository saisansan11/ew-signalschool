import 'package:flutter/material.dart';
import '../../app/constants.dart';

enum ChecklistType { pre, during, post }

class ChecklistScreen extends StatefulWidget {
  final ChecklistType type;

  const ChecklistScreen({super.key, required this.type});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late List<ChecklistItem> _items;
  late String _title;
  late Color _color;
  late IconData _icon;

  @override
  void initState() {
    super.initState();
    _initializeChecklist();
  }

  void _initializeChecklist() {
    switch (widget.type) {
      case ChecklistType.pre:
        _title = 'ก่อนปฏิบัติการ';
        _color = AppColors.primary;
        _icon = Icons.play_arrow;
        _items = [
          ChecklistItem(
            title: 'ตรวจสอบอุปกรณ์สื่อสาร',
            description: 'วิทยุ, แบตเตอรี่, สายอากาศ',
            category: 'อุปกรณ์',
          ),
          ChecklistItem(
            title: 'ทดสอบการสื่อสาร',
            description: 'Radio Check กับหน่วยเหนือและหน่วยข้างเคียง',
            category: 'สื่อสาร',
          ),
          ChecklistItem(
            title: 'บันทึกความถี่และ Call Sign',
            description: 'SOI/COMSEC ประจำวัน',
            category: 'สื่อสาร',
          ),
          ChecklistItem(
            title: 'เตรียม PACE Plan',
            description: 'Primary, Alternate, Contingency, Emergency',
            category: 'แผน',
          ),
          ChecklistItem(
            title: 'ตรวจแผนที่และเข็มทิศ',
            description: 'การนำทางสำรองเมื่อไม่มี GPS',
            category: 'นำทาง',
          ),
          ChecklistItem(
            title: 'ตรวจอุปกรณ์ต่อต้านโดรน',
            description: 'Jammer, RF Detector (ถ้ามี)',
            category: 'C-UAS',
          ),
          ChecklistItem(
            title: 'ซักซ้อมขั้นตอนฉุกเฉิน',
            description: 'GPS Jam, Comm Jam, พบโดรน',
            category: 'ฉุกเฉิน',
          ),
          ChecklistItem(
            title: 'ตรวจการพราง',
            description: 'Signature Management - IR, RF, Visual',
            category: 'พราง',
          ),
        ];
        break;

      case ChecklistType.during:
        _title = 'ระหว่างปฏิบัติการ';
        _color = AppColors.warning;
        _icon = Icons.loop;
        _items = [
          ChecklistItem(
            title: 'รักษาการสื่อสาร',
            description: 'Radio Check ตามกำหนด',
            category: 'สื่อสาร',
          ),
          ChecklistItem(
            title: 'เฝ้าระวังโดรน',
            description: 'ฟังเสียง/สังเกตท้องฟ้า',
            category: 'C-UAS',
          ),
          ChecklistItem(
            title: 'ตรวจสอบ GPS อยู่เสมอ',
            description: 'สังเกตความผิดปกติ',
            category: 'นำทาง',
          ),
          ChecklistItem(
            title: 'รักษาวินัยสัญญาณ',
            description: 'EMCON, ความยาวข้อความ, การเข้ารหัส',
            category: 'สื่อสาร',
          ),
          ChecklistItem(
            title: 'บันทึกเหตุการณ์',
            description: 'เวลา, พิกัด, สิ่งที่พบ',
            category: 'บันทึก',
          ),
          ChecklistItem(
            title: 'รักษาการพราง',
            description: 'หลีกเลี่ยงการส่งสัญญาณเกินจำเป็น',
            category: 'พราง',
          ),
        ];
        break;

      case ChecklistType.post:
        _title = 'หลังปฏิบัติการ';
        _color = AppColors.success;
        _icon = Icons.stop;
        _items = [
          ChecklistItem(
            title: 'รายงานสรุปภารกิจ',
            description: 'สิ่งที่พบ, ปัญหา, ข้อเสนอแนะ',
            category: 'รายงาน',
          ),
          ChecklistItem(
            title: 'ตรวจนับอุปกรณ์',
            description: 'ครบถ้วน, สภาพ, ความเสียหาย',
            category: 'อุปกรณ์',
          ),
          ChecklistItem(
            title: 'ชาร์จแบตเตอรี่',
            description: 'เตรียมพร้อมสำหรับภารกิจหน้า',
            category: 'อุปกรณ์',
          ),
          ChecklistItem(
            title: 'รายงานเหตุการณ์ EW',
            description: 'GPS Jam, Comm Jam, โดรน ที่พบ',
            category: 'รายงาน',
          ),
          ChecklistItem(
            title: 'บันทึกบทเรียน',
            description: 'Lessons Learned สำหรับปรับปรุง',
            category: 'บันทึก',
          ),
        ];
        break;
    }
  }

  int get _completedCount => _items.where((item) => item.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: _color,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 24),
            const SizedBox(width: 8),
            Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_completedCount/${_items.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) => _buildChecklistItem(_items[index], index),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProgressBar() {
    final progress = _items.isEmpty ? 0.0 : _completedCount / _items.length;
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ความคืบหน้า',
                style: TextStyle(color: _color, fontWeight: FontWeight.bold),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: _color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(_color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(ChecklistItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isCompleted ? _color.withValues(alpha: 0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted ? _color : AppColors.border,
          width: item.isCompleted ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              item.isCompleted = !item.isCompleted;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.isCompleted ? _color : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: item.isCompleted ? _color : AppColors.textMuted,
                width: 2,
              ),
            ),
            child: item.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.isCompleted ? _color : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.description,
              style: TextStyle(
                color: item.isCompleted ? _color.withValues(alpha: 0.7) : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.category,
                style: TextStyle(color: _color, fontSize: 11),
              ),
            ),
          ],
        ),
        trailing: Text(
          '${index + 1}',
          style: TextStyle(
            color: item.isCompleted ? _color : AppColors.textMuted,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final allCompleted = _completedCount == _items.length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  for (var item in _items) {
                    item.isCompleted = false;
                  }
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('รีเซ็ต'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: allCompleted
                  ? () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$_title เสร็จสมบูรณ์!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  : () {
                      setState(() {
                        for (var item in _items) {
                          item.isCompleted = true;
                        }
                      });
                    },
              icon: Icon(allCompleted ? Icons.check : Icons.checklist),
              label: Text(allCompleted ? 'เสร็จสิ้น' : 'ทำเครื่องหมายทั้งหมด'),
              style: ElevatedButton.styleFrom(
                backgroundColor: allCompleted ? AppColors.success : _color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistItem {
  final String title;
  final String description;
  final String category;
  bool isCompleted;

  ChecklistItem({
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });
}
