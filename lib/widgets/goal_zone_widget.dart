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
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nome compacto
                    Text(
                      zone.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    // Indicador circular
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: zone.attempts == 0 ? 0 : successRate / 100,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(bgColor),
                            strokeWidth: 1.6,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${zone.goals}/${zone.attempts}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${successRate.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 9,
                                color: bgColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Botões compactos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                            mini: true,
                            onPressed: () => goalModel.recordGoal(zone.id),
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.check, size: 12),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: FloatingActionButton(
                            mini: true,
                            onPressed: () => goalModel.recordMiss(zone.id),
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.close, size: 12),
                          ),
                        ),
                      ],
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
