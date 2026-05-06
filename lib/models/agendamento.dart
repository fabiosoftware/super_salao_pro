import 'package:flutter/material.dart';
import '../database_helper.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  final cliente = TextEditingController();
  final servico = TextEditingController();
  final valor = TextEditingController();
  final hora = TextEditingController();

  bool carregando = false;
  bool pressionado = false;

  String data = DateTime.now().toString().substring(0, 10);

  Future<void> salvar() async {
    setState(() => carregando = true);

    await DatabaseHelper.instance.insert('agendamentos', {
      'cliente': cliente.text,
      'servico': servico.text,
      'valor': double.tryParse(valor.text) ?? 0,
      'hora': hora.text,
      'data': data,
    });

    setState(() => carregando = false);

    // 🔥 FEEDBACK VISUAL
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Agendamento salvo com sucesso"),
        backgroundColor: Colors.black,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Novo Agendamento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: cliente, decoration: const InputDecoration(labelText: "Cliente")),
            const SizedBox(height: 12),
            TextField(controller: servico, decoration: const InputDecoration(labelText: "Serviço")),
            const SizedBox(height: 12),
            TextField(controller: valor, decoration: const InputDecoration(labelText: "Valor")),
            const SizedBox(height: 12),
            TextField(controller: hora, decoration: const InputDecoration(labelText: "Hora")),
            const SizedBox(height: 30),

            carregando
                ? const CircularProgressIndicator()
                : GestureDetector(
              onTapDown: (_) => setState(() => pressionado = true),
              onTapUp: (_) {
                setState(() => pressionado = false);
                salvar();
              },
              onTapCancel: () => setState(() => pressionado = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.identity()
                  ..scale(pressionado ? 0.95 : 1.0),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Salvar Agendamento",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
