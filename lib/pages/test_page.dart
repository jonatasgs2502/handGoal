import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/goal_model.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        final sessions = goalModel.savedSessions;

        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma sessão salva',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Salve suas sessões de treino para\nvisualizar o histórico aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session =
                sessions[sessions.length - 1 - index]; // Mais recente primeiro
            return _buildSessionCard(context, session, goalModel);
          },
        );
      },
    );
  }

  Widget _buildSessionCard(
      BuildContext context, TrainingSession session, GoalModel goalModel) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    final duration = session.endTime.difference(session.startTime);

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getColorForRate(session.successRate),
          child: Text(
            '${session.successRate.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          session.title != null && session.title!.isNotEmpty
              ? '${session.title} (${dateFormat.format(session.startTime)})'
              : dateFormat.format(session.startTime),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime)} (${duration.inMinutes}min) • ${session.totalGoals}/${session.totalAttempts} gols',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumo geral
                _buildSummarySection(session),
                const SizedBox(height: 16),
                // Estatísticas por zona
                const Text(
                  'Desempenho por Zona',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                ...session.zoneStats.values
                    .map((zoneStats) => _buildZoneStatsRow(zoneStats)),
                const SizedBox(height: 16),
                // Notas
                if (session.notes != null && session.notes!.isNotEmpty) ...[
                  const Text(
                    'Notas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.notes!,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Botão de excluir
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _confirmDelete(context, session, goalModel),
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir Sessão'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(TrainingSession session) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Gols', '${session.totalGoals}', Colors.green),
          _buildStatItem('Tentativas', '${session.totalAttempts}', Colors.blue),
          _buildStatItem('Taxa', '${session.successRate.toStringAsFixed(1)}%',
              Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildZoneStatsRow(ZoneStats stats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              stats.zoneName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              '${stats.goals}/${stats.attempts}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getColorForRate(stats.successRate).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${stats.successRate.toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getColorForRate(stats.successRate),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForRate(double rate) {
    if (rate >= 70) return Colors.green;
    if (rate >= 50) return Colors.orange;
    return Colors.red;
  }

  void _confirmDelete(
      BuildContext context, TrainingSession session, GoalModel goalModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Sessão'),
        content: const Text('Tem certeza que deseja excluir esta sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              goalModel.deleteSession(session.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão excluída!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
