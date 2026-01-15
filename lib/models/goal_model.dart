import 'package:flutter/material.dart';

/// Representa um evento único de chute (Histórico)
class ShotEvent {
  final String courtZone; // Ex: 'Ponta Direita', 'Centro (6-9m)'
  final int goalZoneId; // 1 a 9 (Onde acertou no gol)
  final bool isGoal;
  final DateTime timestamp;

  ShotEvent({
    required this.courtZone,
    required this.goalZoneId,
    required this.isGoal,
    required this.timestamp,
  });
}

/// Representa uma zona do GOL (onde a bola entra)
class GoalZone {
  final String name;
  final int id;
  int goals;
  int attempts;

  GoalZone({
    required this.name,
    required this.id,
    this.goals = 0,
    this.attempts = 0,
  });

  double get successRate => attempts == 0 ? 0.0 : (goals / attempts) * 100;

  void reset() {
    goals = 0;
    attempts = 0;
  }
}

class GoalModel extends ChangeNotifier {
  late List<GoalZone> zones;

  // Histórico completo de eventos para estatísticas avançadas
  List<ShotEvent> eventLog = [];

  // Estado da seleção atual na quadra (De onde o jogador chutou)
  String? selectedCourtZone;

  // Lista de zonas para referência
  final List<String> courtZones = [
    'Ponta Direita',
    'Meia Direita (6-9m)',
    'Meia Direita (9m+)',
    'Centro (6-9m)',
    'Centro (9m+)',
    'Meia Esquerda (6-9m)',
    'Meia Esquerda (9m+)',
    'Ponta Esquerda'
  ];

  // Getters globais
  int get totalGoals => eventLog.where((e) => e.isGoal).length;
  int get totalAttempts => eventLog.length;
  double get totalSuccessRate =>
      totalAttempts == 0 ? 0.0 : (totalGoals / totalAttempts) * 100;

  GoalModel() {
    zones = [
      // Linha superior
      GoalZone(name: 'Alto Esq.', id: 1),
      GoalZone(name: 'Alto Centro', id: 2),
      GoalZone(name: 'Alto Dir.', id: 3),
      // Linha do meio
      GoalZone(name: 'Meio Esq.', id: 4),
      GoalZone(name: 'Centro', id: 5),
      GoalZone(name: 'Meio Dir.', id: 6),
      // Linha inferior
      GoalZone(name: 'Baixo Esq.', id: 7),
      GoalZone(name: 'Baixo Centro', id: 8),
      GoalZone(name: 'Baixo Dir.', id: 9),
    ];
  }

  // Seleciona a zona da quadra (chamado ao clicar na quadra)
  void selectCourtZone(String zoneName) {
    if (selectedCourtZone == zoneName) return;
    selectedCourtZone = zoneName;
    notifyListeners();
  }

  // Valida se pode chutar (tem que ter selecionado a origem na quadra)
  bool get canShoot => selectedCourtZone != null;

  // --- ESTATÍSTICAS DA QUADRA ---

  /// Retorna as estatísticas (Gols, Tentativas) de uma zona específica da quadra.
  /// Usado pelo GoalFieldWidget para desenhar os números sobre o campo.
  Map<String, int> getCourtStats(String zoneName) {
    final events = eventLog.where((e) => e.courtZone == zoneName);
    final goals = events.where((e) => e.isGoal).length;
    final attempts = events.length;

    return {'goals': goals, 'attempts': attempts};
  }

  // --- REGISTRO DE EVENTOS ---

  // Registrar Gol
  void recordGoal(int zoneId) {
    if (!canShoot) return;

    final zone = zones.firstWhere((z) => z.id == zoneId);
    zone.goals++;
    zone.attempts++;

    _logEvent(zoneId, true);
    notifyListeners();
  }

  // Registrar Erro (Defesa ou Fora)
  void recordMiss(int zoneId) {
    if (!canShoot) return;

    final zone = zones.firstWhere((z) => z.id == zoneId);
    zone.attempts++;

    _logEvent(zoneId, false);
    notifyListeners();
  }

  void _logEvent(int zoneId, bool isGoal) {
    eventLog.add(ShotEvent(
      courtZone: selectedCourtZone!,
      goalZoneId: zoneId,
      isGoal: isGoal,
      timestamp: DateTime.now(),
    ));
  }

  // --- HELPERS DE ESTATÍSTICAS GERAIS ---

  GoalZone? getBestZone() {
    if (zones.every((z) => z.attempts == 0)) return null;
    return zones
        .where((z) => z.attempts > 0)
        .reduce((a, b) => a.successRate > b.successRate ? a : b);
  }

  GoalZone? getWorstZone() {
    if (zones.every((z) => z.attempts == 0)) return null;
    return zones
        .where((z) => z.attempts > 0)
        .reduce((a, b) => a.successRate < b.successRate ? a : b);
  }

  void resetAllZones() {
    for (var zone in zones) {
      zone.reset();
    }
    eventLog.clear();
    selectedCourtZone = null;
    notifyListeners();
  }

  /// Reseta estatísticas de uma zona específica (gols e tentativas)
  void resetZone(int id) {
    final zone = zones.firstWhere((z) => z.id == id);
    zone.reset();
    // Remove eventos históricos relacionados àquela zona
    eventLog.removeWhere((e) => e.goalZoneId == id);
    notifyListeners();
  }

  // Supondo que você tenha uma lista para armazenar os gols:
  List<dynamic> goals = []; // Substitua pelo tipo correto se necessário

  void removeLastGoal() {
    if (goals.isNotEmpty) {
      goals.removeLast();
      notifyListeners();
    }
  }
}
