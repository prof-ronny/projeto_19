import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const DiarioApp());
}

class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiarioPage(),
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
  List<String> _registros = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _registros = prefs.getStringList('registros') ?? [];
    });
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('registros', _registros);
  }

  void _salvarObservacao() {
    if (_controller.text.isEmpty) return;

    final agora = DateTime.now();
    final registro =
        '${agora.day}/${agora.month}/${agora.year} '
        '${agora.hour}:${agora.minute.toString().padLeft(2, '0')}'
        ' - ${_controller.text}';

    setState(() {
      _registros.insert(0, registro);
      _controller.clear();
    });

    _salvarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diário Offline PWA')),
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
              child: const Text('Salvar'),
            ),
            const Divider(),
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
