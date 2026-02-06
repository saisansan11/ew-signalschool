import 'package:flutter/material.dart';
import '../app/constants.dart';

/// Thailand Map Widget with accurate shape
class ThailandMapWidget extends StatelessWidget {
  final Function(String region)? onRegionTap;
  final String? selectedRegion;

  const ThailandMapWidget({
    super.key,
    this.onRegionTap,
    this.selectedRegion,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ThailandMapPainter(selectedRegion: selectedRegion),
      size: Size.infinite,
    );
  }
}

/// Thailand Map Painter with accurate outline
class ThailandMapPainter extends CustomPainter {
  final String? selectedRegion;

  ThailandMapPainter({this.selectedRegion});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.surfaceLight
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Thailand's actual geographic bounds
    const double minLat = 5.5;
    const double maxLat = 20.5;
    const double minLng = 97.3;
    const double maxLng = 105.7;

    // Convert lat/lng to screen coordinates
    Offset latLngToScreen(double lat, double lng) {
      final x = (lng - minLng) / (maxLng - minLng) * size.width;
      final y = (1 - (lat - minLat) / (maxLat - minLat)) * size.height;
      return Offset(x, y);
    }

    // Thailand outline coordinates (simplified but accurate shape)
    // Starting from the north and going clockwise
    final thailandCoords = [
      // Northern region (Golden Triangle area)
      (20.4, 100.1), // Mae Sai
      (20.3, 100.5),
      (19.9, 100.8),
      (19.5, 101.1),

      // Northeast border with Laos (Mekong River)
      (19.0, 101.5),
      (18.5, 102.0),
      (18.0, 102.5),
      (17.5, 103.0),
      (17.0, 103.5),
      (16.5, 104.0),
      (16.0, 104.5),
      (15.5, 105.0),
      (15.2, 105.5),

      // Eastern border
      (15.0, 105.6),
      (14.5, 105.4),
      (14.0, 105.0),
      (13.5, 104.5),

      // Cambodia border
      (13.0, 103.5),
      (12.5, 103.0),
      (12.0, 102.5),

      // Gulf of Thailand coast
      (11.5, 102.8),
      (11.0, 102.5),
      (10.5, 102.0),
      (10.0, 101.5),
      (9.5, 100.5),

      // Southern peninsula (east coast)
      (9.0, 99.8),
      (8.5, 99.5),
      (8.0, 99.2),
      (7.5, 99.5),
      (7.0, 99.8),
      (6.5, 100.2),
      (6.0, 100.5),
      (5.9, 101.0),

      // Southern tip
      (5.6, 101.1),

      // West coast of peninsula
      (5.8, 100.5),
      (6.2, 100.0),
      (6.5, 99.5),
      (7.0, 99.0),
      (7.5, 98.5),
      (8.0, 98.3),
      (8.5, 98.2),
      (9.0, 98.3),
      (9.5, 98.5),

      // Andaman coast
      (10.0, 98.8),
      (10.5, 98.5),
      (11.0, 99.0),
      (11.5, 99.2),
      (12.0, 99.5),
      (12.5, 99.3),
      (13.0, 99.2),

      // Western border with Myanmar
      (13.5, 99.0),
      (14.0, 98.8),
      (14.5, 98.5),
      (15.0, 98.5),
      (15.5, 98.3),
      (16.0, 98.2),
      (16.5, 98.0),
      (17.0, 97.8),
      (17.5, 97.6),
      (18.0, 97.8),
      (18.5, 98.0),
      (19.0, 98.5),
      (19.5, 99.0),
      (19.8, 99.5),
      (20.2, 99.8),
      (20.4, 100.1), // Back to start
    ];

    // Create path
    final path = Path();
    final firstPoint = latLngToScreen(thailandCoords[0].$1, thailandCoords[0].$2);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < thailandCoords.length; i++) {
      final point = latLngToScreen(thailandCoords[i].$1, thailandCoords[i].$2);

      // Use smooth curves
      if (i > 0) {
        final prev = latLngToScreen(thailandCoords[i - 1].$1, thailandCoords[i - 1].$2);
        final controlX = (prev.dx + point.dx) / 2;
        final controlY = (prev.dy + point.dy) / 2;
        path.quadraticBezierTo(prev.dx, prev.dy, controlX, controlY);
      }
    }
    path.close();

    // Draw shadow
    canvas.drawPath(
      path.shift(const Offset(3, 3)),
      Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Draw fill
    canvas.drawPath(path, paint);

    // Draw border
    canvas.drawPath(path, borderPaint);

    // Draw region labels
    _drawRegionLabels(canvas, size, latLngToScreen);

    // Draw major cities dots
    _drawCities(canvas, latLngToScreen);
  }

  void _drawRegionLabels(Canvas canvas, Size size, Offset Function(double, double) latLngToScreen) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final regions = [
      ('ภาคเหนือ', 18.8, 99.0),
      ('ภาคตะวันออกเฉียงเหนือ', 16.0, 103.0),
      ('ภาคกลาง', 14.5, 100.5),
      ('ภาคตะวันออก', 13.0, 101.8),
      ('ภาคตะวันตก', 14.5, 98.8),
      ('ภาคใต้', 8.0, 99.5),
    ];

    for (final (label, lat, lng) in regions) {
      final pos = latLngToScreen(lat, lng);
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: AppColors.textMuted.withOpacity(0.7),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2),
      );
    }
  }

  void _drawCities(Canvas canvas, Offset Function(double, double) latLngToScreen) {
    // Major cities for reference
    final cities = [
      ('กรุงเทพฯ', 13.7563, 100.5018),
      ('เชียงใหม่', 18.7883, 98.9853),
      ('ขอนแก่น', 16.4419, 102.8360),
      ('นครราชสีมา', 14.9799, 102.0978),
      ('ภูเก็ต', 7.8804, 98.3923),
      ('หาดใหญ่', 7.0086, 100.4747),
    ];

    for (final (name, lat, lng) in cities) {
      final pos = latLngToScreen(lat, lng);

      // Draw small dot
      canvas.drawCircle(
        pos,
        3,
        Paint()..color = AppColors.textMuted.withOpacity(0.4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ThailandMapPainter oldDelegate) {
    return oldDelegate.selectedRegion != selectedRegion;
  }
}

/// Convert latitude/longitude to normalized position (0-1)
class ThailandGeoConverter {
  static const double minLat = 5.5;
  static const double maxLat = 20.5;
  static const double minLng = 97.3;
  static const double maxLng = 105.7;

  /// Convert lat/lng to screen position
  static Offset latLngToPosition(double lat, double lng, Size size) {
    final x = (lng - minLng) / (maxLng - minLng) * size.width;
    final y = (1 - (lat - minLat) / (maxLat - minLat)) * size.height;
    return Offset(x, y);
  }

  /// Convert screen position to lat/lng
  static (double lat, double lng) positionToLatLng(Offset position, Size size) {
    final lng = (position.dx / size.width) * (maxLng - minLng) + minLng;
    final lat = (1 - position.dy / size.height) * (maxLat - minLat) + minLat;
    return (lat, lng);
  }
}
