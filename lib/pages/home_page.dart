import 'package:flutter/material.dart';
import 'agenda_page.dart';
import 'clientes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;

  double faturamentoHoje = 0.0;

  final GlobalKey<AgendaPageState> agendaKey =
      GlobalKey<AgendaPageState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: Column(
        children: [

          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              20,
              50,
              20,
              25,
            ),

            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB),
                  Color(0xFF2575FC),
                ],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  "Super Salão",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Faturamento hoje",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "R\$ ${faturamentoHoje.toStringAsFixed(2)}",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: paginaAtual == 0
                ? AgendaPage(key: agendaKey)
                : const ClientesPage(),
          ),
        ],
      ),

      // BOTÃO +
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A11CB),

        elevation: 6,

        onPressed: () {

          if (paginaAtual == 0) {

            agendaKey.currentState
                ?.abrirFormulario();
          }
        },

        child: const Icon(Icons.add),
      ),

      // MENU INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,

        selectedItemColor:
            const Color(0xFF6A11CB),

        unselectedItemColor: Colors.grey,

        onTap: (index) {

          setState(() {

            paginaAtual = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Agenda",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Clientes",
          ),
        ],
      ),
    );
  }
}