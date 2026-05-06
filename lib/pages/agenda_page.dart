import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  AgendaPageState createState() =>
      AgendaPageState();
}

class AgendaPageState
    extends State<AgendaPage> {

  List<Map<String, dynamic>>
      atendimentos = [];

  final TextEditingController
      clienteController =
      TextEditingController();

  final TextEditingController
      horarioController =
      TextEditingController();

  String? servicoSelecionado;

  double valorServico = 0.0;

  final Map<String, double> servicos = {

    "Corte de Cabelo": 35.0,
    "Barba": 20.0,
    "Progressiva": 180.0,
    "Escova": 45.0,
    "Sobrancelha": 25.0,
  };

  @override
  void initState() {

    super.initState();

    carregarAtendimentos();
  }

  Future<void> salvarAtendimentos()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    prefs.setString(
      'atendimentos',
      jsonEncode(atendimentos),
    );
  }

  Future<void> carregarAtendimentos()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final dados =
        prefs.getString('atendimentos');

    if (dados != null) {

      setState(() {

        atendimentos =
            List<Map<String, dynamic>>
                .from(
          jsonDecode(dados),
        );
      });
    }
  }

  Future<void> adicionarAtendimento()
      async {

    if (clienteController.text.isEmpty ||
        servicoSelecionado == null ||
        horarioController.text.isEmpty) {

      return;
    }

    setState(() {

      atendimentos.add({

        "cliente":
            clienteController.text,

        "servico":
            servicoSelecionado,

        "valor":
            valorServico,

        "horario":
            horarioController.text,
      });
    });

    await salvarAtendimentos();

    clienteController.clear();

    horarioController.clear();

    servicoSelecionado = null;

    valorServico = 0.0;

    Navigator.pop(context);
  }

  Future<void> selecionarHorario()
      async {

    TimeOfDay? horario =
        await showTimePicker(

      context: context,

      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {

      setState(() {

        horarioController.text =
            "${horario.hour.toString().padLeft(2, '0')}:${horario.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void mostrarDetalhes(
      Map<String, dynamic> atendimento) {

    showModalBottomSheet(

      context: context,

      builder: (context) {

        return Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const Text(
                "Detalhes do Atendimento",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Cliente: ${atendimento["cliente"]}",
                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Serviço: ${atendimento["servico"]}",
                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Horário: ${atendimento["horario"]}",
                style:
                    const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Valor: R\$ ${atendimento["valor"]}",
                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(0xFF6A11CB),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(

                width:
                    double.infinity,

                child: ElevatedButton(

                  onPressed: () {

                    Navigator.pop(
                        context);
                  },

                  child:
                      const Text(
                    "Fechar",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void abrirFormulario() {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      builder: (context) {

        return Padding(

          padding: EdgeInsets.only(

            left: 20,
            right: 20,
            top: 20,

            bottom:
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    20,
          ),

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                const Text(
                  "Novo Atendimento",

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 20),

                TextField(

                  controller:
                      clienteController,

                  decoration:
                      const InputDecoration(

                    labelText:
                        "Cliente",

                    border:
                        OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                    height: 15),

                DropdownButtonFormField<
                    String>(

                  value:
                      servicoSelecionado,

                  decoration:
                      const InputDecoration(

                    labelText:
                        "Serviço",

                    border:
                        OutlineInputBorder(),
                  ),

                  items: servicos.keys
                      .map((servico) {

                    return DropdownMenuItem(

                      value: servico,

                      child:
                          Text(servico),
                    );

                  }).toList(),

                  onChanged: (value) {

                    setState(() {

                      servicoSelecionado =
                          value;

                      valorServico =
                          servicos[value]!;
                    });
                  },
                ),

                const SizedBox(
                    height: 15),

                TextField(

                  readOnly: true,

                  decoration:
                      InputDecoration(

                    labelText:
                        "Valor: R\$ ${valorServico.toStringAsFixed(2)}",

                    border:
                        const OutlineInputBorder(),
                  ),
                ),

                const SizedBox(
                    height: 15),

                TextField(

                  controller:
                      horarioController,

                  readOnly: true,

                  onTap:
                      selecionarHorario,

                  decoration:
                      const InputDecoration(

                    labelText:
                        "Horário",

                    border:
                        OutlineInputBorder(),

                    suffixIcon: Icon(
                      Icons.access_time,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                SizedBox(

                  width:
                      double.infinity,

                  child: ElevatedButton(

                    onPressed:
                        adicionarAtendimento,

                    child:
                        const Text(
                      "Salvar",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (atendimentos.isEmpty) {

      return const Center(

        child: Text(

          "Nenhum atendimento cadastrado",

          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(

      itemCount:
          atendimentos.length,

      itemBuilder:
          (context, index) {

        final atendimento =
            atendimentos[index];

        return GestureDetector(

          onTap: () {

            mostrarDetalhes(
                atendimento);
          },

          child: Card(

            margin:
                const EdgeInsets
                    .symmetric(

              horizontal: 15,
              vertical: 8,
            ),

            child: ListTile(

              leading:
                  const CircleAvatar(

                backgroundColor:
                    Color(0xFF6A11CB),

                child: Icon(
                  Icons.cut,
                  color:
                      Colors.white,
                ),
              ),

              title: Text(
                atendimento[
                    "cliente"],
              ),

              subtitle: Text(

                "${atendimento["servico"]} • ${atendimento["horario"]}",
              ),

              trailing: Text(

                "R\$ ${atendimento["valor"]}",

                style:
                    const TextStyle(

                  fontWeight:
                      FontWeight.bold,

                  color: Color(
                      0xFF6A11CB),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}