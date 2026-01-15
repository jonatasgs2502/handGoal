import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        centerTitle: true,
      ),
      body: Consumer<GoalModel>(
        builder: (context, goalModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card com resumo geral
                  _buildSummaryCard(goalModel),
                  const SizedBox(height: 20),
                  // Card com melhor zona
                  _buildBestZoneCard(goalModel),
                  const SizedBox(height: 16),
                  // Card com pior zona
                  _buildWorstZoneCard(goalModel),
                  const SizedBox(height: 20),
                  // Título da listagem de zonas
                  const Text(
                    'Detalhes por Zona',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Lista de zonas com estatísticas
                  ...goalModel.zones.map((zone) => _buildZoneStatsCard(zone)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(GoalModel goalModel) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Resumo Geral',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                    'Gols', '${goalModel.totalGoals}', Colors.green),
                _buildStatColumn(
                  'Tentativas',
                  '${goalModel.totalAttempts}',
                  Colors.blue,
                ),
                _buildStatColumn(
                  'Taxa',
                  '${goalModel.totalSuccessRate.toStringAsFixed(1)}%',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestZoneCard(GoalModel goalModel) {
    final bestZone = goalModel.getBestZone();
    if (bestZone == null) {
      return Card(
        color: Colors.grey[900],
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Nenhuma tentativa registrada ainda',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Card(
      color: Colors.green[900],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '🏆 Melhor Zona',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bestZone.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${bestZone.successRate.toStringAsFixed(2)}% de sucesso',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorstZoneCard(GoalModel goalModel) {
    final worstZone = goalModel.getWorstZone();
    if (worstZone == null) {
      return Card(
        color: Colors.grey[900],
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Nenhuma tentativa registrada ainda',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Card(
      color: Colors.red[900],
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '⚠️ Zona com Menor Taxa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              worstZone.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '${worstZone.successRate.toStringAsFixed(2)}% de sucesso',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneStatsCard(GoalZone zone) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              zone.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  'Gols',
                  '${zone.goals}',
                  Colors.green,
                ),
                _buildStatColumn(
                  'Tentativas',
                  '${zone.attempts}',
                  Colors.blue,
                ),
                _buildStatColumn(
                  'Taxa',
                  '${zone.successRate.toStringAsFixed(1)}%',
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Barra de progresso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: zone.attempts == 0 ? 0 : zone.successRate / 100,
                minHeight: 8,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(zone.successRate),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double successRate) {
    if (successRate >= 70) return Colors.green;
    if (successRate >= 50) return Colors.orange;
    return Colors.red;
  }
}
