import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart';

//zona do gol widget

class GoalZoneWidget extends StatelessWidget {
  final GoalZone zone;

  const GoalZoneWidget({
    super.key,
    required this.zone,
  });

  Color _getSuccessColor(double successRate) {
    if (zone.attempts == 0) return Colors.grey[800]!;
    if (successRate >= 70) return Colors.green;
    if (successRate >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth / 15; // Reduced button size

    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        final successRate = zone.successRate;
        final bgColor = _getSuccessColor(successRate);

        return Card(
          margin: EdgeInsets.zero,
          color: const Color.fromARGB(255, 211, 211, 211),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('images/goalzone.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: InkWell(
              onTap: () => _showOptionsDialog(context, goalModel),
              borderRadius: BorderRadius.zero,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nome compacto
                    Flexible(
                      flex: 2,
                      child: Text(
                        zone.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    // Indicador circular
                    Flexible(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              value: zone.attempts == 0 ? 0 : successRate / 100,
                              backgroundColor: Colors.grey[800],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(bgColor),
                              strokeWidth: 1.6,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${zone.goals}/${zone.attempts}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${successRate.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: bgColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Botões compactos
                    Flexible(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: buttonSize,
                            width: buttonSize,
                            child: FloatingActionButton(
                              mini: true,
                              heroTag: 'goal_${zone.id}',
                              onPressed: () => goalModel.recordGoal(zone.id),
                              backgroundColor: Colors.green,
                              child: const Icon(Icons.check, size: 12),
                            ),
                          ),
                          SizedBox(width: 2),
                          SizedBox(
                            height: buttonSize,
                            width: buttonSize,
                            child: FloatingActionButton(
                              mini: true,
                              heroTag: 'miss_${zone.id}',
                              onPressed: () => goalModel.recordMiss(zone.id),
                              backgroundColor: Colors.red,
                              child: const Icon(Icons.close, size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOptionsDialog(BuildContext context, GoalModel goalModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(zone.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gols: ${zone.goals}'),
            Text('Tentativas: ${zone.attempts}'),
            Text('Taxa de sucesso: ${zone.successRate.toStringAsFixed(2)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              goalModel.recordGoal(zone.id);
              Navigator.pop(context);
            },
            child: const Text('Registrar Gol'),
          ),
          TextButton(
            onPressed: () {
              goalModel.recordMiss(zone.id);
              Navigator.pop(context);
            },
            child: const Text('Registrar Erro'),
          ),
        ],
      ),
    );
  }
}
