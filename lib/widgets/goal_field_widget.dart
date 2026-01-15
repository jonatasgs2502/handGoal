import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart';

//calculos matematicos para desenhar e interagir com a quadra

class GoalFieldWidget extends StatelessWidget {
  const GoalFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  onTapUp: (details) => _handleTap(context, details,
                      constraints.maxWidth, constraints.maxHeight, goalModel),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B2338),
                      border: Border.all(
                          color: const Color.fromARGB(255, 127, 146, 220),
                          width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: CustomPaint(
                      size: Size.infinite,
                      // Passamos o MODELO inteiro para o Painter puxar os números reais
                      painter: _InteractiveZonePainter(
                        selectedZone: goalModel.selectedCourtZone,
                        goalModel: goalModel,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, TapUpDetails details, double w,
      double h, GoalModel model) {
    // --- CONFIGURAÇÃO MATEMÁTICA ---
    const double startYInMeters = 2.5;
    const double visibleDepthInMeters = 11.0;
    final double pixelsPerMeter = h / visibleDepthInMeters;
    final double originY = -(startYInMeters * pixelsPerMeter);
    final Offset centerGoal = Offset(w / 2, originY);
    final double p9 = 9.0 * pixelsPerMeter;

    final double dx = details.localPosition.dx - centerGoal.dx;
    final double dy = details.localPosition.dy - centerGoal.dy;
    final double angle = math.atan2(dy, dx);
    final double touchRadius = math.sqrt(dx * dx + dy * dy);

    final double a1 = math.pi * 0.26;
    final double a2 = math.pi * 0.42;
    final double a3 = math.pi * 0.58;
    final double a4 = math.pi * 0.74;

    String baseZone = '';
    bool isCentralPosition = false;

    if (angle < a1) {
      baseZone = 'Ponta Direita';
    } else if (angle >= a1 && angle < a2) {
      baseZone = 'Meia Direita';
      isCentralPosition = true;
    } else if (angle >= a2 && angle < a3) {
      baseZone = 'Centro';
      isCentralPosition = true;
    } else if (angle >= a3 && angle < a4) {
      baseZone = 'Meia Esquerda';
      isCentralPosition = true;
    } else {
      baseZone = 'Ponta Esquerda';
    }

    String finalZoneName = baseZone;

    if (isCentralPosition) {
      if (touchRadius <= p9) {
        finalZoneName = '$baseZone (6-9m)';
      } else {
        finalZoneName = '$baseZone (9m+)';
      }
    }
    model.selectCourtZone(finalZoneName);
  }
}

class _InteractiveZonePainter extends CustomPainter {
  final String? selectedZone;
  final GoalModel goalModel;

  _InteractiveZonePainter({this.selectedZone, required this.goalModel});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // --- CONFIG ---
    const double startYInMeters = 2.5;
    const double visibleDepthInMeters = 11.0;
    final double pixelsPerMeter = h / visibleDepthInMeters;

    const double r6 = 6.0;
    const double r9 = 9.0;
    const double goalWidth = 3.0;
    const double dist7m = 7.0;

    final double p6 = r6 * pixelsPerMeter;
    final double p9 = r9 * pixelsPerMeter;
    final double p7m = dist7m * pixelsPerMeter;
    final double pGoalHalf = (goalWidth * pixelsPerMeter) / 2.0;

    final double originY = -(startYInMeters * pixelsPerMeter);
    final Offset centerGoal = Offset(w / 2, originY);
    final Offset leftPost = Offset(centerGoal.dx - pGoalHalf, originY);
    final Offset rightPost = Offset(centerGoal.dx + pGoalHalf, originY);

    // Pincéis
    final Paint linePaint = Paint()
      ..color =
          const Color.fromRGBO(255, 255, 255, 0.3) // Linhas mais discretas
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final Paint dashedPaint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final Paint area6mPaint = Paint()
      ..color = const Color(0xFF205582)
      ..style = PaintingStyle.fill;
    final Paint highlightPaint = Paint()
      ..color = const Color.fromRGBO(255, 165, 0, 0.6)
      ..style = PaintingStyle.fill;

    // --- GEOMETRIA ---
    final Path path6m = Path();
    path6m.moveTo(leftPost.dx - p6, originY);
    path6m.arcToPoint(Offset(leftPost.dx, originY + p6),
        radius: Radius.circular(p6), clockwise: false);
    path6m.lineTo(rightPost.dx, originY + p6);
    path6m.arcToPoint(Offset(rightPost.dx + p6, originY),
        radius: Radius.circular(p6), clockwise: false);
    path6m.close();

    final Path path9m = Path();
    path9m.moveTo(leftPost.dx - p9, originY);
    path9m.arcToPoint(Offset(leftPost.dx, originY + p9),
        radius: Radius.circular(p9), clockwise: false);
    path9m.lineTo(rightPost.dx, originY + p9);
    path9m.arcToPoint(Offset(rightPost.dx + p9, originY),
        radius: Radius.circular(p9), clockwise: false);

    // 1. Highlight (Destaque da seleção)
    if (selectedZone != null) {
      _drawZoneHighlight(canvas, centerGoal, h, highlightPaint, p6, p9);
    }

    // 2. Linhas Divisórias
    final angles = [
      math.pi * 0.26,
      math.pi * 0.42,
      math.pi * 0.58,
      math.pi * 0.74
    ];
    final double startRadius = p6;
    final double endRadius = h * 2.5;

    for (double angle in angles) {
      final p1 = Offset(centerGoal.dx + startRadius * math.cos(angle),
          centerGoal.dy + startRadius * math.sin(angle));
      final p2 = Offset(centerGoal.dx + endRadius * math.cos(angle),
          centerGoal.dy + endRadius * math.sin(angle));
      canvas.drawLine(p1, p2, linePaint);
    }

    // 3. Áreas e Bordas
    canvas.drawPath(path6m, area6mPaint);
    canvas.drawPath(
        path6m,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white
          ..strokeWidth = 2);
    _drawDashedPath(canvas, path9m, dashedPaint);

    // 4. Marca 7m
    canvas.drawLine(
        Offset(centerGoal.dx - 10, originY + p7m),
        Offset(centerGoal.dx + 10, originY + p7m),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3);

    // --- 5. DESENHAR AS ESTATÍSTICAS (GOLS / TENTATIVAS) ---
    _drawStatsOverlay(canvas, centerGoal, p6, p9, h);

    // 6. Label Seleção (Rodapé)
    if (selectedZone != null) {
      _drawSelectionLabel(canvas, size, selectedZone!);
    }
  }

  // Renderiza os números em cada zona
  void _drawStatsOverlay(
      Canvas canvas, Offset center, double p6, double p9, double h) {
    final double a1 = math.pi * 0.26;
    final double a2 = math.pi * 0.42;
    final double a3 = math.pi * 0.58;
    final double a4 = math.pi * 0.74;
    final double maxA = math.pi;

    final zones = [
      _ZoneConfig('Ponta Direita', 0, a1, (p6 + p9) / 1.8),
      _ZoneConfig('Meia Direita (6-9m)', a1, a2, (p6 + p9) / 2),
      _ZoneConfig('Meia Direita (9m+)', a1, a2, p9 + 40),
      _ZoneConfig('Centro (6-9m)', a2, a3, (p6 + p9) / 2),
      _ZoneConfig('Centro (9m+)', a2, a3, p9 + 40),
      _ZoneConfig('Meia Esquerda (6-9m)', a3, a4, (p6 + p9) / 2),
      _ZoneConfig('Meia Esquerda (9m+)', a3, a4, p9 + 40),
      _ZoneConfig('Ponta Esquerda', a4, maxA, (p6 + p9) / 1.8),
    ];

    for (var z in zones) {
      final midAngle = (z.startAngle + z.endAngle) / 2;
      final double x = center.dx + z.radius * math.cos(midAngle);
      final double y = center.dy + z.radius * math.sin(midAngle);

      // Busca os dados REAIS do Model
      final stats = _getStats(z.name);

      _drawStatText(canvas, Offset(x, y), stats);
    }
  }

  _Stats _getStats(String zoneName) {
    final statsMap = goalModel.getCourtStats(zoneName);
    return _Stats(statsMap['goals']!, statsMap['attempts']!);
  }

  void _drawStatText(Canvas canvas, Offset pos, _Stats stats) {
    // Se não tem chute, desenha traço ou vazio
    if (stats.attempts == 0) return;

    final textSpan = TextSpan(children: [
      TextSpan(
        text: "${stats.goals}/${stats.attempts}\n",
        style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 2, color: Colors.black)]),
      ),
      TextSpan(
        text: "${((stats.goals / stats.attempts) * 100).toStringAsFixed(0)}%",
        style: TextStyle(
            color: _getColorForRate(stats.goals, stats.attempts),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            shadows: [const Shadow(blurRadius: 2, color: Colors.black)]),
      ),
    ]);

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
        canvas,
        Offset(
            pos.dx - textPainter.width / 2, pos.dy - textPainter.height / 2));
  }

  Color _getColorForRate(int goals, int attempts) {
    if (attempts == 0) return Colors.grey;
    final rate = goals / attempts;
    if (rate >= 0.6) return Colors.greenAccent;
    if (rate >= 0.4) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  void _drawZoneHighlight(Canvas canvas, Offset center, double h, Paint paint,
      double r6, double r9) {
    double startAngle = 0;
    double sweepAngle = 0;
    double innerR = 0;
    double outerR = h * 2.5;

    final double a1 = math.pi * 0.26;
    final double a2 = math.pi * 0.42;
    final double a3 = math.pi * 0.58;
    final double a4 = math.pi * 0.74;
    final double maxAngle = math.pi;

    String baseName = selectedZone!;
    bool isShort = baseName.contains('(6-9m)');
    bool isLong = baseName.contains('(9m+)');
    String cleanName =
        baseName.replaceAll(' (6-9m)', '').replaceAll(' (9m+)', '');

    switch (cleanName) {
      case 'Ponta Direita':
        startAngle = 0;
        sweepAngle = a1;
        innerR = 0;
        break;
      case 'Meia Direita':
        startAngle = a1;
        sweepAngle = a2 - a1;
        break;
      case 'Centro':
        startAngle = a2;
        sweepAngle = a3 - a2;
        break;
      case 'Meia Esquerda':
        startAngle = a3;
        sweepAngle = a4 - a3;
        break;
      case 'Ponta Esquerda':
        startAngle = a4;
        sweepAngle = maxAngle - a4;
        innerR = 0;
        break;
    }

    if (isShort) {
      innerR = r6;
      outerR = r9;
    } else if (isLong) {
      innerR = r9;
      outerR = h * 2.5;
    } else {
      if (innerR == 0) innerR = r6;
    }

    final Path path = Path();
    path.arcTo(Rect.fromCircle(center: center, radius: outerR), startAngle,
        sweepAngle, false);
    path.arcTo(Rect.fromCircle(center: center, radius: innerR),
        startAngle + sweepAngle, -sweepAngle, false);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSelectionLabel(Canvas canvas, Size size, String text) {
    final textSpan = TextSpan(
      text: "Posição: $text",
      style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black54),
    );
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    textPainter.paint(
        canvas, Offset((size.width - textPainter.width) / 2, size.height - 25));
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dashWidth = 10.0;
    const double dashSpace = 8.0;
    double distance = 0.0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double len = (distance + dashWidth < pathMetric.length)
            ? dashWidth
            : pathMetric.length - distance;
        canvas.drawPath(
            pathMetric.extractPath(distance, distance + len), paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveZonePainter oldDelegate) {
    // Repinta se mudar a seleção OU se o modelo mudar (novos gols registrados)
    return oldDelegate.selectedZone != selectedZone ||
        oldDelegate.goalModel != goalModel;
  }
}

// Classes auxiliares internas
class _ZoneConfig {
  final String name;
  final double startAngle;
  final double endAngle;
  final double radius;
  _ZoneConfig(this.name, this.startAngle, this.endAngle, this.radius);
}

class _Stats {
  final int goals;
  final int attempts;
  _Stats(this.goals, this.attempts);
}
