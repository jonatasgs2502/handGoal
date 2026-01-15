import 'package:flutter/material.dart';
import '../models/goal_model.dart';

/// Cartão com as estatísticas gerais do projeto.
/// Agora com Layout Responsivo (FittedBox) para evitar overflow.
class StatsCardWidget extends StatelessWidget {
  final GoalModel goalModel;
  final double height;

  const StatsCardWidget(
      {super.key, required this.goalModel, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        color: Colors.grey[900],
        elevation: 4,
        // Reduzi o padding para aproveitar melhor o espaço
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Distribui o espaço
            children: [
              // 1. Título (Com FittedBox para não quebrar se a fonte for grande)
              const Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Estatísticas Gerais',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),

              // 2. Linha de Dados
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                        'Gols', '${goalModel.totalGoals}', Colors.green),
                    _buildStatItem('Tentativas', '${goalModel.totalAttempts}',
                        Colors.blue),
                    _buildStatItem(
                        'Taxa',
                        '${goalModel.totalSuccessRate.toStringAsFixed(1)}%',
                        Colors.orange),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Label (FittedBox garante que o texto "Tentativas" caiba)
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 2),
        // Valor (FittedBox garante que números grandes não estourem)
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
