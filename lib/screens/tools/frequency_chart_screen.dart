import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../services/theme_provider.dart';

class FrequencyChartScreen extends StatelessWidget {
  FrequencyChartScreen({super.key});

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
              'FREQUENCY CHART',
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
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildInfoBanner(isDark),
              const SizedBox(height: 20),
              ..._frequencyBands.map((band) => _buildBandCard(band, isDark)),
            ],
          ),
        );
      },
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
          Icon(Icons.info_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ตารางความถี่ตามมาตรฐาน ITU Radio Regulations และ IEEE',
              style: TextStyle(
                color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBandCard(_FreqBand band, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : AppColorsLight.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.border : AppColorsLight.border,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: band.color.withAlpha(30),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            band.designation,
            style: TextStyle(
              color: band.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          band.name,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          band.range,
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Wavelength', band.wavelength, isDark),
                _buildDetailRow('ITU Band', band.ituBand, isDark),
                const Divider(height: 24),
                Text(
                  'การใช้งานหลัก',
                  style: TextStyle(
                    color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                ...band.applications.map((app) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right, size: 16, color: band.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          app,
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColorsLight.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                if (band.ewNotes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withAlpha(15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.danger.withAlpha(30)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber, size: 16, color: AppColors.danger),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            band.ewNotes!,
                            style: TextStyle(
                              color: AppColors.danger,
                              fontSize: 12,
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
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColorsLight.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColorsLight.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  final List<_FreqBand> _frequencyBands = [
    _FreqBand(
      designation: 'VLF',
      name: 'Very Low Frequency',
      range: '3 - 30 kHz',
      wavelength: '100 - 10 km',
      ituBand: 'Band 4',
      color: Colors.purple,
      applications: [
        'การสื่อสารใต้น้ำกับเรือดำน้ำ',
        'การนำทาง (OMEGA - เลิกใช้แล้ว)',
        'การสื่อสารระยะไกลมาก',
      ],
      ewNotes: 'ใช้ในการสื่อสารกับเรือดำน้ำ ยากต่อการ Jam เนื่องจากต้องใช้พลังงานสูงมาก',
    ),
    _FreqBand(
      designation: 'LF',
      name: 'Low Frequency',
      range: '30 - 300 kHz',
      wavelength: '10 - 1 km',
      ituBand: 'Band 5',
      color: Colors.indigo,
      applications: [
        'วิทยุกระจายเสียง AM (Long Wave)',
        'การนำทางทางอากาศ (NDB)',
        'LORAN-C Navigation',
      ],
    ),
    _FreqBand(
      designation: 'MF',
      name: 'Medium Frequency',
      range: '300 kHz - 3 MHz',
      wavelength: '1000 - 100 m',
      ituBand: 'Band 6',
      color: Colors.blue,
      applications: [
        'วิทยุกระจายเสียง AM (Medium Wave)',
        'วิทยุสมัครเล่น (160m band)',
        'Maritime Radio',
      ],
    ),
    _FreqBand(
      designation: 'HF',
      name: 'High Frequency',
      range: '3 - 30 MHz',
      wavelength: '100 - 10 m',
      ituBand: 'Band 7',
      color: Colors.cyan,
      applications: [
        'วิทยุคลื่นสั้น (Shortwave)',
        'การสื่อสารทางทหารระยะไกล',
        'วิทยุสมัครเล่น (80m-10m)',
        'Over-the-Horizon Radar (OTH)',
        'ALE (Automatic Link Establishment)',
      ],
      ewNotes: 'ความถี่สำคัญทางทหาร - ใช้ในการสื่อสาร tactical และ strategic',
    ),
    _FreqBand(
      designation: 'VHF',
      name: 'Very High Frequency',
      range: '30 - 300 MHz',
      wavelength: '10 - 1 m',
      ituBand: 'Band 8',
      color: Colors.green,
      applications: [
        'วิทยุ FM (88-108 MHz)',
        'โทรทัศน์ช่อง 2-13',
        'การบินพลเรือน (118-137 MHz)',
        'วิทยุทหาร (30-88 MHz)',
        'Maritime VHF (156-162 MHz)',
      ],
      ewNotes: 'ย่านความถี่ 30-88 MHz เป็นย่าน Combat Net Radio (CNR) หลักของทหาร',
    ),
    _FreqBand(
      designation: 'UHF',
      name: 'Ultra High Frequency',
      range: '300 MHz - 3 GHz',
      wavelength: '1 m - 10 cm',
      ituBand: 'Band 9',
      color: Colors.orange,
      applications: [
        'โทรทัศน์ช่อง 14-83',
        'โทรศัพท์มือถือ (700-2600 MHz)',
        'WiFi 2.4 GHz',
        'GPS L-Band (1.2-1.6 GHz)',
        'SATCOM Military',
        'Drone Control Links',
      ],
      ewNotes: 'ย่านความถี่สำคัญมากสำหรับ Counter-UAS และ GPS Jamming/Spoofing',
    ),
    _FreqBand(
      designation: 'SHF',
      name: 'Super High Frequency',
      range: '3 - 30 GHz',
      wavelength: '10 - 1 cm',
      ituBand: 'Band 10',
      color: Colors.red,
      applications: [
        'Radar (S, C, X, Ku bands)',
        'Satellite Communications',
        'WiFi 5 GHz',
        'Point-to-Point Microwave',
        'Weather Radar',
      ],
      ewNotes: 'ย่านความถี่หลักของ Radar - เป้าหมายหลักของ Electronic Attack',
    ),
    _FreqBand(
      designation: 'EHF',
      name: 'Extremely High Frequency',
      range: '30 - 300 GHz',
      wavelength: '10 - 1 mm',
      ituBand: 'Band 11',
      color: Colors.pink,
      applications: [
        'Millimeter Wave Radar',
        '5G (mmWave)',
        'Security Scanning',
        'Radio Astronomy',
        'Satellite Crosslinks',
      ],
      ewNotes: 'ใช้ใน Advanced Seekers และ Missile Guidance',
    ),
  ];
}

class _FreqBand {
  final String designation;
  final String name;
  final String range;
  final String wavelength;
  final String ituBand;
  final Color color;
  final List<String> applications;
  final String? ewNotes;

  _FreqBand({
    required this.designation,
    required this.name,
    required this.range,
    required this.wavelength,
    required this.ituBand,
    required this.color,
    required this.applications,
    this.ewNotes,
  });
}
