import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import 'goal_zone_widget.dart';

class GoalGridWidget extends StatelessWidget {
  final List<GoalZone> zones;

  //area grade do gol divida em 9 zonas

  const GoalGridWidget({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5, // Dá mais prioridade de espaço para o GOL (vs a quadra)
      child: Container(
        margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0B2338),
          // Borda grossa branca para parecer as traves
          border: Border.all(
              color: const Color.fromARGB(255, 255, 149, 2), width: 4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calcula a proporção exata para caber 3x3 no espaço disponível
            final double itemWidth = constraints.maxWidth / 3;
            final double itemHeight = constraints.maxHeight / 3;
            final double childAspectRatio = itemWidth / itemHeight;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: zones.length,
              itemBuilder: (context, index) {
                return GoalZoneWidget(zone: zones[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
