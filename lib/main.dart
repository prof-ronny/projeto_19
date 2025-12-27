import 'package:flutter/material.dart';

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário Offline PWA',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DiarioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DiarioPage extends StatefulWidget {
  const DiarioPage({super.key});

  @override
  State<DiarioPage> createState() => _DiarioPageState();
}

class _DiarioPageState extends State<DiarioPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _registros = [];

  void _salvarObservacao() {
    if (_controller.text.isEmpty) return;

    final agora = DateTime.now();
    setState(() {
      _registros.insert(
        0,
        '${agora.day}/${agora.month}/${agora.year} '
        '${agora.hour}:${agora.minute.toString().padLeft(2, '0')}'
        ' - ${_controller.text}',
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diário de Observações')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nova observação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _salvarObservacao,
              child: const Text('Salvar observação'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Registros',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _registros.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(_registros[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
