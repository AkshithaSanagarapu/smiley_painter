// In-Class Activity 06 — Drawing with Flutter
// Student: Akshitha Sainath Sanagarapu
// Date: September 30, 2026

import 'dart:math' show pi;
import 'package:flutter/material.dart';

void main() {
  runApp(const SmileyApp());
}

enum FaceType {
  classic,
  sleepy,
  surprised,
}

// Stores one complete version of the face state.
class FaceConfig {
  final FaceType faceType;
  final double mood;

  const FaceConfig({
    required this.faceType,
    required this.mood,
  });
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType selectedFace = FaceType.classic;

  // Stores previous face configurations.
  final List<FaceConfig> _history = [];

  String get faceName {
    switch (selectedFace) {
      case FaceType.classic:
        return 'Classic';
      case FaceType.sleepy:
        return 'Sleepy';
      case FaceType.surprised:
        return 'Surprised';
    }
  }

  // Save the current state before changing it.
  void _saveCurrentState() {
    _history.add(
      FaceConfig(
        faceType: selectedFace,
        mood: mood,
      ),
    );
  }

  // Change face by tapping the drawing.
  void _cycleFace() {
    _saveCurrentState();

    setState(() {
      switch (selectedFace) {
        case FaceType.classic:
          selectedFace = FaceType.sleepy;
          break;
        case FaceType.sleepy:
          selectedFace = FaceType.surprised;
          break;
        case FaceType.surprised:
          selectedFace = FaceType.classic;
          break;
      }
    });
  }

  // Long-press resets the face to Classic.
  void _resetFace() {
    if (selectedFace == FaceType.classic) {
      return;
    }

    _saveCurrentState();

    setState(() {
      selectedFace = FaceType.classic;
    });
  }

  // Change face using the segmented buttons.
  void _selectFace(FaceType newFace) {
    if (newFace == selectedFace) {
      return;
    }

    _saveCurrentState();

    setState(() {
      selectedFace = newFace;
    });
  }

  // Save ONE state when the slider drag begins.
  void _startMoodChange(double value) {
    _saveCurrentState();

    // Rebuild immediately so Undo count updates.
    setState(() {});
  }

  // Update mood while dragging without repeatedly saving history.
  void _changeMood(double newMood) {
    setState(() {
      mood = newMood;
    });
  }

  // Restore the most recent saved configuration.
  void _undo() {
    if (_history.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nothing to undo.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final previous = _history.removeLast();

    setState(() {
      selectedFace = previous.faceType;
      mood = previous.mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _cycleFace,
                  onLongPress: _resetFace,
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: SmileyPainter(
                        mood: mood,
                        faceType: selectedFace,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Text(
              'Tap face to change • Long-press to reset',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Face: $faceName',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedButton<FaceType>(
                segments: const [
                  ButtonSegment<FaceType>(
                    value: FaceType.classic,
                    label: Text('Classic'),
                  ),
                  ButtonSegment<FaceType>(
                    value: FaceType.sleepy,
                    label: Text('Sleepy'),
                  ),
                  ButtonSegment<FaceType>(
                    value: FaceType.surprised,
                    label: Text('Surprised'),
                  ),
                ],
                selected: {selectedFace},
                onSelectionChanged: (Set<FaceType> selection) {
                  _selectFace(selection.first);
                },
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Mood: ${mood.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Slider(
                value: mood,
                min: 0.0,
                max: 1.0,

                // Save history once when user starts dragging.
                onChangeStart: _startMoodChange,

                // Update continuously without creating more history.
                onChanged: _changeMood,
              ),
            ),

            const SizedBox(height: 4),

            OutlinedButton.icon(
              onPressed: _undo,
              icon: const Icon(Icons.undo),
              label: Text(
                'Undo (${_history.length})',
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
  });

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.38;

    // --------------------------------------------------
    // FACE COLOR BASED ON MOOD
    // --------------------------------------------------

    Color faceColor;

    if (mood < 0.33) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood < 0.66) {
      faceColor = Colors.yellow.shade500;
    } else {
      faceColor = Colors.orange.shade300;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // --------------------------------------------------
    // FACE BORDER
    // --------------------------------------------------

    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // --------------------------------------------------
    // EYES
    // --------------------------------------------------

    final featurePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final featureStrokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.18;
    final eyeDx = radius * 0.35;
    final eyeRadius = radius * 0.09;

    final leftEye = Offset(
      center.dx - eyeDx,
      eyeY,
    );

    final rightEye = Offset(
      center.dx + eyeDx,
      eyeY,
    );

    if (faceType == FaceType.sleepy) {
      // Sleepy face: closed eyes.
      canvas.drawLine(
        Offset(
          leftEye.dx - eyeRadius,
          leftEye.dy,
        ),
        Offset(
          leftEye.dx + eyeRadius,
          leftEye.dy,
        ),
        featureStrokePaint,
      );

      canvas.drawLine(
        Offset(
          rightEye.dx - eyeRadius,
          rightEye.dy,
        ),
        Offset(
          rightEye.dx + eyeRadius,
          rightEye.dy,
        ),
        featureStrokePaint,
      );
    } else if (faceType == FaceType.surprised) {
      // Surprised face: larger eyes.
      canvas.drawCircle(
        leftEye,
        eyeRadius * 1.35,
        featurePaint,
      );

      canvas.drawCircle(
        rightEye,
        eyeRadius * 1.35,
        featurePaint,
      );
    } else {
      // Classic face.
      canvas.drawCircle(
        leftEye,
        eyeRadius,
        featurePaint,
      );

      canvas.drawCircle(
        rightEye,
        eyeRadius,
        featurePaint,
      );
    }

    // --------------------------------------------------
    // MOUTH
    // --------------------------------------------------

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (faceType == FaceType.surprised) {
      final surprisedMouthPaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          center.dx,
          center.dy + radius * 0.35,
        ),
        radius * 0.14,
        surprisedMouthPaint,
      );
    } else if (faceType == FaceType.sleepy) {
      final sleepyMouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.30,
        ),
        width: radius * 0.55,
        height: radius * 0.25,
      );

      canvas.drawArc(
        sleepyMouthRect,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else {
      // Classic mouth changes according to mood.
      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.15,
        ),
        width: radius,
        height: radius * (0.4 + mood * 0.5),
      );

      if (mood >= 0.5) {
        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else {
        final frownRect = mouthRect.translate(
          0,
          radius * 0.25,
        );

        canvas.drawArc(
          frownRect,
          1.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }
    }

    // --------------------------------------------------
    // HAT
    // --------------------------------------------------

    final hatPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final hatTop = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy - radius * 0.95,
      ),
      width: radius * 1.15,
      height: radius * 0.45,
    );

    canvas.drawRect(
      hatTop,
      hatPaint,
    );

    final hatBrim = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy - radius * 0.72,
      ),
      width: radius * 1.55,
      height: radius * 0.15,
    );

    canvas.drawRect(
      hatBrim,
      hatPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}