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
                    goalModel.resetAllZones();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Dados resetados com sucesso!')),
                    );
                  },
                  child: const Text('Resetar Tudo'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 12)),
        child: const Text('Resetar / Remover Gol',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
