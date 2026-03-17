import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(60, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..addListener(() {
        setState(() {
          for (var p in particles) {
            p.move();
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: ParticlePainter(particles),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x = Random().nextDouble() * 400;
  double y = Random().nextDouble() * 800;
  
  // Random directions: velocity between -0.8 and 0.8
  double vx = (Random().nextDouble() - 0.7) * 1.6;
  double vy = (Random().nextDouble() - 0.7) * 1.6;
  
  double radius = Random().nextDouble() * 2 + 1;

  void move() {
    x += vx;
    y += vy;

    // Screen wrapping logic
    if (x < -10) x = 410;
    else if (x > 410) x = -10;
    
    if (y < -10) y = 810;
    else if (y > 810) y = -10;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    // Updated to .withValues to satisfy latest Flutter linter
    final paint = Paint()..color = const Color.fromARGB(255, 202, 18, 18).withValues(alpha: 0.15);
    
    for (var p in particles) {
      canvas.drawCircle(
        Offset(p.x * (size.width / 400), p.y * (size.height / 800)), 
        p.radius, 
        paint
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}