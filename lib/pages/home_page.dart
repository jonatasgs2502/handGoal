import 'package:flutter/material.dart';
import 'package:handgoal/pages/test_page.dart';
import 'package:provider/provider.dart';
import '../models/goal_model.dart';
import '../widgets/stats_card_widget.dart';
import '../widgets/goal_grid_widget.dart';
import '../widgets/goal_field_widget.dart';
import '../widgets/reset_button_widget.dart';
import '../pages/stats_page.dart';

// 1. Definição das telas e títulos
final List<String> titles = ['HandGoal Tracker', 'Estatísticas', 'Histórico'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;

  // 2. Lista de Widgets das telas
  late final List<Widget> _telas;

  @override
  void initState() {
    super.initState();
    _telas = [
      const TrackerView(), // O conteúdo original do seu tracker
      const StatsPage(), // Representando Estatísticas
      const TestPage(), // Representando Histórico (substitua pela sua página real)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_indiceAtual]),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _indiceAtual,
        children: _telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceAtual,
        onDestinationSelected: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.sports_handball), label: 'Tracker'),
          NavigationDestination(
              icon: Icon(Icons.bar_chart), label: 'Estatísticas'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
        ],
      ),
    );
  }
}

// 3. O conteúdo original da sua tela de Tracker (movido para cá)
class TrackerView extends StatelessWidget {
  const TrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Consumer<GoalModel>(
      builder: (context, goalModel, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                GoalGridWidget(zones: goalModel.zones),
                const SizedBox(height: 4),
                const Expanded(
                  flex: 3,
                  child: GoalFieldWidget(),
                ),
                const SizedBox(height: 4),
                ResetButtonWidget(goalModel: goalModel),
              ],
            ),
          ),
        );
      },
    );
  }
}
