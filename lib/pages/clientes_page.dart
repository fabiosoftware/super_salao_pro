import 'package:flutter/material.dart';
import '../database_helper.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  List<Map<String, dynamic>> lista = [];
  final TextEditingController controller = TextEditingController();
  bool carregando = false;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    setState(() => carregando = true);

    final dados = await DatabaseHelper.instance.getAll('clientes');

    setState(() {
      lista = dados;
      carregando = false;
    });
  }

  Future<void> salvar() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite o nome do cliente")),
      );
      return;
    }

    await DatabaseHelper.instance.insert('clientes', {
      'nome': controller.text.trim(),
    });

    controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cliente salvo com sucesso")),
    );

    await carregar();
  }

  Future<void> excluir(int id) async {
    await DatabaseHelper.instance.delete('clientes', id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cliente removido")),
    );

    await carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER PADRÃO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Text(
              "Clientes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: "Nome do cliente",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: salvar,
                  child: const Text("Salvar"),
                )
              ],
            ),
          ),

          // LISTA
          Expanded(
            child: carregando
                ? const Center(child: CircularProgressIndicator())
                : lista.isEmpty
                ? const Center(child: Text("Nenhum cliente cadastrado"))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final item = lista[i];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      item['nome'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () => excluir(item['id']),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}