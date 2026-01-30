import 'package:flutter/material.dart';

class Particle {
  Offset position;
  Offset velocity;
  double life;
  Color color;
  double size;
  Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.color,
    required this.size,
  });
}
