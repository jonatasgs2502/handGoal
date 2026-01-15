import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Test Page'),
      ),
      body: Center(
        // Usamos o Column para empilhar os widgets verticalmente
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Centraliza os itens verticalmente na coluna
          children: const [
            Text('This is a test page'),
            SizedBox(
                height:
                    20), // Adiciona um pequeno espaço entre o texto e a imagem
          ],
        ),
      ),
    );
  }
}
