import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';
import '../../services/progress_service.dart';

// ==========================================
// CERTIFICATE SYSTEM
// ระบบประกาศนียบัตร EW Training
// ==========================================

enum CertificateLevel { basic, intermediate, advanced, expert, master }

enum CertificateStatus { locked, inProgress, earned }

class CertificateData {
  final String id;
  final String title;
  final String titleThai;
  final String description;
  final CertificateLevel level;
  final List<String> requirements;
  final int requiredXP;
  final String issuer;
  final String? earnedDate;
  final String? certificateNumber;
  final Color color;
  final IconData icon;

  const CertificateData({
    required this.id,
    required this.title,
    required this.titleThai,
    required this.description,
    required this.level,
    required this.requirements,
    required this.requiredXP,
    required this.issuer,
    this.earnedDate,
    this.certificateNumber,
    required this.color,
    required this.icon,
  });
}

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CertificateStatus _getCertificateStatus(CertificateData cert) {
    final totalXP = ProgressService.getTotalXp();
    final level1 = ProgressService.getLevelProgress(1);
    final level2 = ProgressService.getLevelProgress(2);
    final level3 = ProgressService.getLevelProgress(3);
    final quizScores = ProgressService.getQuizScorePercentages();
    final quizzesPassed = quizScores.values.where((s) => s >= 80).length;

    switch (cert.id) {
      case 'cert_basic':
        if (level1 >= 1.0 && totalXP >= 100) return CertificateStatus.earned;
        if (level1 > 0 || totalXP > 0) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_intermediate':
        if (level2 >= 1.0 && quizzesPassed >= 1) return CertificateStatus.earned;
        if (level1 >= 1.0) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_advanced':
        if (level3 >= 1.0 && quizzesPassed >= 2) return CertificateStatus.earned;
        if (level2 >= 1.0) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_sigint':
        if (level2 >= 0.5 && totalXP >= 300) return CertificateStatus.earned;
        if (totalXP >= 100) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_ecm':
        if (level2 >= 0.5 && totalXP >= 400) return CertificateStatus.earned;
        if (totalXP >= 150) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_cuav':
        if (totalXP >= 500) return CertificateStatus.earned;
        if (totalXP >= 200) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      case 'cert_master':
        if (level1 >= 1.0 && level2 >= 1.0 && level3 >= 1.0 && quizzesPassed >= 3) {
          return CertificateStatus.earned;
        }
        if (level3 >= 0.5) return CertificateStatus.inProgress;
        return CertificateStatus.locked;

      default:
        return CertificateStatus.locked;
    }
  }

  double _getCertificateProgress(CertificateData cert) {
    final totalXP = ProgressService.getTotalXp();
    final level1 = ProgressService.getLevelProgress(1);
    final level2 = ProgressService.getLevelProgress(2);
    final level3 = ProgressService.getLevelProgress(3);
    final quizScores = ProgressService.getQuizScorePercentages();
    final quizzesPassed = quizScores.values.where((s) => s >= 80).length;

    switch (cert.id) {
      case 'cert_basic':
        return ((level1 + (totalXP / 100).clamp(0.0, 1.0)) / 2).clamp(0.0, 1.0);
      case 'cert_intermediate':
        return ((level2 + (quizzesPassed >= 1 ? 1.0 : 0.0)) / 2).clamp(0.0, 1.0);
      case 'cert_advanced':
        return ((level3 + (quizzesPassed / 2).clamp(0.0, 1.0)) / 2).clamp(0.0, 1.0);
      case 'cert_sigint':
        return ((level2 / 2) + (totalXP / 300).clamp(0.0, 0.5)).clamp(0.0, 1.0);
      case 'cert_ecm':
        return ((level2 / 2) + (totalXP / 400).clamp(0.0, 0.5)).clamp(0.0, 1.0);
      case 'cert_cuav':
        return (totalXP / 500).clamp(0.0, 1.0);
      case 'cert_master':
        return ((level1 + level2 + level3 + (quizzesPassed / 3).clamp(0.0, 1.0)) / 4)
            .clamp(0.0, 1.0);
      default:
        return 0.0;
    }
  }

  final List<CertificateData> _certificates = [
    const CertificateData(
      id: 'cert_basic',
      title: 'EW Fundamentals',
      titleThai: 'พื้นฐานสงครามอิเล็กทรอนิกส์',
      description: 'ประกาศนียบัตรรับรองความรู้พื้นฐานด้าน Electronic Warfare',
      level: CertificateLevel.basic,
      requirements: [
        'จบบทเรียนระดับ 1 ทั้งหมด',
        'สะสม XP อย่างน้อย 100',
      ],
      requiredXP: 100,
      issuer: 'RTA Signal School',
      color: AppColors.success,
      icon: Icons.school,
    ),
    const CertificateData(
      id: 'cert_intermediate',
      title: 'EW Practitioner',
      titleThai: 'ผู้ปฏิบัติงาน EW',
      description: 'ประกาศนียบัตรรับรองความสามารถในการปฏิบัติงาน EW ระดับกลาง',
      level: CertificateLevel.intermediate,
      requirements: [
        'จบบทเรียนระดับ 2 ทั้งหมด',
        'ผ่านแบบทดสอบอย่างน้อย 1 ระดับ',
      ],
      requiredXP: 300,
      issuer: 'RTA Signal School',
      color: AppColors.primary,
      icon: Icons.engineering,
    ),
    const CertificateData(
      id: 'cert_advanced',
      title: 'EW Specialist',
      titleThai: 'ผู้เชี่ยวชาญ EW',
      description: 'ประกาศนียบัตรรับรองความเชี่ยวชาญด้าน Electronic Warfare',
      level: CertificateLevel.advanced,
      requirements: [
        'จบบทเรียนระดับ 3 ทั้งหมด',
        'ผ่านแบบทดสอบอย่างน้อย 2 ระดับ',
      ],
      requiredXP: 500,
      issuer: 'RTA Signal School',
      color: AppColors.warning,
      icon: Icons.psychology,
    ),
    const CertificateData(
      id: 'cert_sigint',
      title: 'SIGINT Operator',
      titleThai: 'ผู้ปฏิบัติงาน SIGINT',
      description: 'ประกาศนียบัตรรับรองความรู้ด้าน Signals Intelligence',
      level: CertificateLevel.intermediate,
      requirements: [
        'จบบทเรียน SIGINT/ELINT/COMINT',
        'สะสม XP อย่างน้อย 300',
      ],
      requiredXP: 300,
      issuer: 'RTA Intelligence Division',
      color: Colors.purple,
      icon: Icons.radar,
    ),
    const CertificateData(
      id: 'cert_ecm',
      title: 'ECM Technician',
      titleThai: 'ช่าง ECM',
      description: 'ประกาศนียบัตรรับรองความรู้ด้าน Electronic Countermeasures',
      level: CertificateLevel.intermediate,
      requirements: [
        'จบบทเรียน ECM/Jamming',
        'สะสม XP อย่างน้อย 400',
      ],
      requiredXP: 400,
      issuer: 'RTA Signal School',
      color: AppColors.danger,
      icon: Icons.flash_on,
    ),
    const CertificateData(
      id: 'cert_cuav',
      title: 'Counter-UAS Operator',
      titleThai: 'ผู้ปฏิบัติงานต่อต้านโดรน',
      description: 'ประกาศนียบัตรรับรองความสามารถในการต่อต้าน UAV',
      level: CertificateLevel.advanced,
      requirements: [
        'จบบทเรียน Anti-Drone',
        'สะสม XP อย่างน้อย 500',
      ],
      requiredXP: 500,
      issuer: 'RTA Air Defense Command',
      color: Colors.cyan,
      icon: Icons.flight,
    ),
    const CertificateData(
      id: 'cert_master',
      title: 'EW Master',
      titleThai: 'ปรมาจารย์สงครามอิเล็กทรอนิกส์',
      description: 'ประกาศนียบัตรสูงสุดด้าน Electronic Warfare',
      level: CertificateLevel.master,
      requirements: [
        'จบบทเรียนทุกระดับ',
        'ผ่านแบบทดสอบทุกระดับ',
        'สะสม XP อย่างน้อย 1000',
      ],
      requiredXP: 1000,
      issuer: 'RTA Signal Corps',
      color: Colors.amber,
      icon: Icons.workspace_premium,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, child) {
        final isDark = themeProvider.isDarkMode;
        final earnedCount =
            _certificates.where((c) => _getCertificateStatus(c) == CertificateStatus.earned).length;

        return Scaffold(
          backgroundColor: isDark ? AppColors.background : AppColorsLight.background,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surface : AppColorsLight.surface,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.card_membership,
                  size: 20,
                  color: isDark ? AppColors.warning : AppColorsLight.warning,
                ),
                const SizedBox(width: 8),
                Text(
                  'CERTIFICATES',
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            ),
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  _buildSummaryCard(earnedCount, isDark),
                  const SizedBox(height: 24),

                  // Info Banner
                  _buildInfoBanner(isDark),
                  const SizedBox(height: 24),

                  // Certificates List
                  Text(
                    'ประกาศนียบัตรทั้งหมด',
                    style: TextStyle(
                      color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ..._certificates.asMap().entries.map((entry) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + (entry.key * 100)),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: _buildCertificateCard(entry.value, isDark),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(int earnedCount, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning,
            AppColors.warning.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withAlpha(60),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_membership,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ประกาศนียบัตรที่ได้รับ',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$earnedCount / ${_certificates.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: earnedCount / _certificates.length,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เกี่ยวกับประกาศนียบัตร',
                  style: TextStyle(
                    color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ประกาศนียบัตรจะได้รับเมื่อผ่านเกณฑ์ที่กำหนด สามารถดาวน์โหลดและแชร์ได้',
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(CertificateData cert, bool isDark) {
    final status = _getCertificateStatus(cert);
    final progress = _getCertificateProgress(cert);
    final isEarned = status == CertificateStatus.earned;
    final isLocked = status == CertificateStatus.locked;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned
              ? cert.color.withAlpha(150)
              : (isDark ? AppColors.border : AppColorsLight.border),
          width: isEarned ? 2 : 1,
        ),
        boxShadow: isEarned
            ? [
                BoxShadow(
                  color: cert.color.withAlpha(30),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCertificateDetail(cert, status, progress, isDark),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? (isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight)
                            : cert.color.withAlpha(30),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isLocked
                              ? (isDark ? AppColors.border : AppColorsLight.border)
                              : cert.color,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        cert.icon,
                        color: isLocked
                            ? (isDark ? AppColors.textMuted : AppColorsLight.textMuted)
                            : cert.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cert.title,
                                  style: TextStyle(
                                    color: isLocked
                                        ? (isDark
                                            ? AppColors.textMuted
                                            : AppColorsLight.textMuted)
                                        : (isDark
                                            ? AppColors.textPrimary
                                            : AppColorsLight.textPrimary),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildLevelBadge(cert.level, isLocked),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cert.titleThai,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textSecondary
                                  : AppColorsLight.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status
                    if (isEarned)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: AppColors.success,
                          size: 20,
                        ),
                      )
                    else if (isLocked)
                      Icon(
                        Icons.lock,
                        color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                        size: 20,
                      )
                    else
                      const Icon(
                        Icons.pending,
                        color: AppColors.warning,
                        size: 20,
                      ),
                  ],
                ),

                // Progress Bar (if in progress)
                if (status == CertificateStatus.inProgress) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                      valueColor: AlwaysStoppedAnimation<Color>(cert.color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toInt()}% สำเร็จ',
                    style: TextStyle(
                      color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],

                // Earned Badge
                if (isEarned) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success, size: 14),
                        SizedBox(width: 6),
                        Text(
                          'ได้รับแล้ว',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelBadge(CertificateLevel level, bool isLocked) {
    Color color;
    String label;

    switch (level) {
      case CertificateLevel.basic:
        color = Colors.green;
        label = 'Basic';
        break;
      case CertificateLevel.intermediate:
        color = Colors.blue;
        label = 'Intermediate';
        break;
      case CertificateLevel.advanced:
        color = Colors.orange;
        label = 'Advanced';
        break;
      case CertificateLevel.expert:
        color = Colors.purple;
        label = 'Expert';
        break;
      case CertificateLevel.master:
        color = Colors.amber;
        label = 'Master';
        break;
    }

    if (isLocked) color = Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCertificateDetail(
    CertificateData cert,
    CertificateStatus status,
    double progress,
    bool isDark,
  ) {
    final isEarned = status == CertificateStatus.earned;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surface : AppColorsLight.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.border : AppColorsLight.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Certificate Preview
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Certificate Card
                    _buildCertificatePreview(cert, isEarned, isDark),
                    const SizedBox(height: 24),

                    // Requirements
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.background : AppColorsLight.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เงื่อนไขการได้รับ',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : AppColorsLight.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...cert.requirements.map((req) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      isEarned
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 18,
                                      color: isEarned
                                          ? AppColors.success
                                          : (isDark
                                              ? AppColors.textMuted
                                              : AppColorsLight.textMuted),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        req,
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondary
                                              : AppColorsLight.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Progress (if not earned)
                    if (!isEarned)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.background : AppColorsLight.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ความคืบหน้า',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : AppColorsLight.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                    color: cert.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: isDark
                                    ? AppColors.surfaceLight
                                    : AppColorsLight.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(cert.color),
                                minHeight: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.background : AppColorsLight.background,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.border : AppColorsLight.border,
                  ),
                ),
              ),
              child: SafeArea(
                child: isEarned
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ฟังก์ชันแชร์จะเปิดให้บริการเร็วๆ นี้'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('แชร์'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: cert.color,
                                side: BorderSide(color: cert.color),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ฟังก์ชันดาวน์โหลดจะเปิดให้บริการเร็วๆ นี้'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('ดาวน์โหลด'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cert.color,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight,
                            foregroundColor: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('เรียนต่อเพื่อปลดล็อก'),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificatePreview(CertificateData cert, bool isEarned, bool isDark) {
    final random = Random(cert.id.hashCode);
    final certNumber = isEarned
        ? 'CERT-${DateTime.now().year}-${(random.nextInt(9000) + 1000).toString()}'
        : '########';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isEarned
            ? LinearGradient(
                colors: [
                  cert.color.withAlpha(30),
                  cert.color.withAlpha(10),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isEarned ? null : (isDark ? AppColors.background : AppColorsLight.background),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned ? cert.color : (isDark ? AppColors.border : AppColorsLight.border),
          width: isEarned ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cert.color.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cert.issuer,
                  style: TextStyle(
                    color: cert.color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                certNumber,
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: isEarned
                  ? LinearGradient(
                      colors: [cert.color, cert.color.withAlpha(180)],
                    )
                  : null,
              color: isEarned ? null : (isDark ? AppColors.surfaceLight : AppColorsLight.surfaceLight),
              shape: BoxShape.circle,
              boxShadow: isEarned
                  ? [
                      BoxShadow(
                        color: cert.color.withAlpha(50),
                        blurRadius: 20,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              cert.icon,
              color: isEarned ? Colors.white : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'CERTIFICATE OF COMPLETION',
            style: TextStyle(
              color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cert.title,
            style: TextStyle(
              color: isEarned
                  ? cert.color
                  : (isDark ? AppColors.textMuted : AppColorsLight.textMuted),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            cert.titleThai,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            cert.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Footer
          if (isEarned)
            Column(
              children: [
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified, color: AppColors.success, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'ได้รับเมื่อ: ${_formatDate(DateTime.now())}',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ยังไม่ได้รับ',
                style: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
