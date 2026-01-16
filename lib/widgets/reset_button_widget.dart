import 'package:flutter/material.dart';

import '../models/goal_model.dart';

/// Botão que abre um diálogo para resetar todas as estatísticas.
///
/// Recebe o `GoalModel` para invocar `resetAllZones()` quando o
/// usuário confirmar. Mostra uma `SnackBar` de confirmação.
class ResetButtonWidget extends StatelessWidget {
  final GoalModel goalModel;

  const ResetButtonWidget({super.key, required this.goalModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Opções de Dados'),
              content:
                  const Text('O que você deseja fazer com as estatísticas?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    goalModel.removeLastGoal();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Último gol removido!')),
                    );
                  },
                  child: const Text('Remover Último Gol'),
                ),
                TextButton(
                  onPressed: () {
                    if (goalModel.totalAttempts == 0) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Nenhuma estatística para salvar!')),
                      );
                      return;
                    }
                    // Mostra diálogo para adicionar notas (opcional)
                    Navigator.pop(context);
                    _showSaveDialog(context);
                  },
                  child: const Text('Salvar e Resetar'),
                ),
                TextButton(
                  onPressed: () {
                    goalModel.resetAllZones();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Dados resetados sem salvar!')),
                    );
                  },
                  child: const Text('Resetar sem Salvar'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 12)),
        child: const Text('Salvar / Resetar / Remover Gol',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salvar Sessão'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ${goalModel.totalGoals}/${goalModel.totalAttempts} (${goalModel.totalSuccessRate.toStringAsFixed(1)}%)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                hintText: 'Ex: Treino matinal, bom desempenho...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final notes = notesController.text.trim().isEmpty
                  ? null
                  : notesController.text.trim();
              goalModel.saveAndReset(notes: notes);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Sessão salva e dados resetados!')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
