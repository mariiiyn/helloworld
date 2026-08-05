import 'package:flutter/material.dart';

void main() {
  runApp(const MeuTreinoApp());
}

class MeuTreinoApp extends StatelessWidget {
  const MeuTreinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gym App",
      theme: ThemeData.dark(),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int paginaAtual = 0;
  String diaSelecionado = "Segunda";

  Map<String, List<Map<String, dynamic>>> treinos = {
    "Segunda": [
      {"nome": "Supino Reto", "serie": "4x10", "feito": false},
      {"nome": "Crucifixo", "serie": "3x12", "feito": false},
      {"nome": "Tríceps Polia", "serie": "3x15", "feito": false},
    ],
    "Terça": [
      {"nome": "Agachamento", "serie": "4x10", "feito": false},
      {"nome": "Leg Press", "serie": "4x12", "feito": false},
      {"nome": "Panturrilha", "serie": "4x20", "feito": false},
    ],
    "Quarta": [
      {"nome": "Puxada Frontal", "serie": "4x10", "feito": false},
      {"nome": "Remada Baixa", "serie": "4x12", "feito": false},
      {"nome": "Rosca Direta", "serie": "3x12", "feito": false},
    ],
    "Quinta": [
      {"nome": "Desenvolvimento", "serie": "4x10", "feito": false},
      {"nome": "Elevação Lateral", "serie": "3x12", "feito": false},
      {"nome": "Encolhimento", "serie": "3x15", "feito": false},
    ],
    "Sexta": [
      {"nome": "Levantamento Terra", "serie": "4x8", "feito": false},
      {"nome": "Abdominal", "serie": "3x20", "feito": false},
      {"nome": "Prancha", "serie": "3x40s", "feito": false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym App"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Escolha o dia"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ["Segunda","Terça","Quarta","Quinta","Sexta"]
                        .map(
                          (dia) => ListTile(
                            title: Text(dia),
                            onTap: () {
                              setState(() {
                                diaSelecionado = dia;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            },
          ),
        ],
        ),
              body: paginaAtual == 0
          ? telaInicio()
          : paginaAtual == 1
              ? telaTreino()
              : telaPerfil(),

      floatingActionButton: paginaAtual == 1
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                TextEditingController nome = TextEditingController();
                TextEditingController serie = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Adicionar Exercício"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nome,
                            decoration: const InputDecoration(
                              labelText: "Nome",
                            ),
                          ),
                          TextField(
                            controller: serie,
                            decoration: const InputDecoration(
                              labelText: "Séries",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (nome.text.isNotEmpty &&
                                serie.text.isNotEmpty) {
                              setState(() {
                                treinos[diaSelecionado]!.add({
                                  "nome": nome.text,
                                  "serie": serie.text,
                                  "feito": false,
                                });
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("Adicionar"),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Treino",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
  Widget telaInicio() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.fitness_center,
          size: 80,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          "Bem-vindo ao Gym App!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text("Escolha um treino para começar."),
      ],
    ),
  );
}

Widget telaTreino() {
  return Column(
    children: [
      const SizedBox(height: 15),
      Text(
        "Treino de $diaSelecionado",
        style: const TextStyle(
          fontSize: 22,
          color: Color.fromARGB(255, 143, 0, 195),
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),

      Expanded(
        child: ListView.builder(
          itemCount: treinos[diaSelecionado]!.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: CheckboxListTile(
                title: Text(
                  treinos[diaSelecionado]![index]["nome"],
                ),
                subtitle: Text(
                  treinos[diaSelecionado]![index]["serie"],
                ),
                value: treinos[diaSelecionado]![index]["feito"],
                onChanged: (valor) {
                  setState(() {
                    treinos[diaSelecionado]![index]["feito"] = valor!;
                  });
                },
              ),
            );
          },
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Treino de $diaSelecionado finalizado! 💪",
                  ),
                ),
              );
            },
            child: const Text("Finalizar Treino"),
          ),
        ),
      ),
    ],
  );
}

Widget telaPerfil() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          child: Icon(
            Icons.person,
            size: 60,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Meu Perfil",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text("Nome: Mariana"),
        Text("Objetivo: Hipertrofia"),
        Text("Treinos concluídos: 0"),
      ],
    ),
  );
}
}