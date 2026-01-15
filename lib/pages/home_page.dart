import 'package:flutter/material.dart';
import 'package:handgoal/pages/test_page.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/goal_grid_widget.dart';
import '../widgets/goal_field_widget.dart'; // <--- Importe o novo widget aqui
import '../widgets/reset_button_widget.dart';
// import 'stats_page.dart'; // removido: import não utilizado

// ... imports ...

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<GoalModel>(
        builder: (context, goalModel, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Margem externa menor
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // CARD DE STATS (Tamanho fixo baseado na tela)
                  StatsCardWidget(goalModel: goalModel, height: screenH * 0.12),

                  const SizedBox(height: 4),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 4),
                    child: Text('Zonas do Gol',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),

                  // GRID DO GOL (Ocupa a maior parte do meio)
                  // O widget GoalGridWidget já tem Expanded, mas vamos garantir o flex lá dentro ou aqui
                  GoalGridWidget(zones: goalModel.zones),
                  // Nota: Editei o GoalGridWidget acima para ter 'flex: 5'

                  const SizedBox(height: 4),

                  // QUADRA (Abaixo do gol)
                  const Expanded(
                    flex: 3, // A quadra ocupa menos espaço que o gol
                    child:
                        GoalFieldWidget(), // Certifique-se de remover o Expanded de DENTRO do GoalFieldWidget se colocar aqui, ou ajustar lá.
                  ),

                  const SizedBox(height: 4),

                  // BOTÃO RESET
                  ResetButtonWidget(goalModel: goalModel),
                ],
              ),
            ),
          );
        },
      ),
    );
    // ----- Helpers privados -----
  }

  // ----- Helpers privados -----
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('HandGoal Tracker'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TestPage()),
            );
          },
        ),
      ],
    );
  }
}
