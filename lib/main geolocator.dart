import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Distância até minha casa",
      home: const LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {

  double distancia = 0;

  double latitudeCasa = -21.487332149271033;
  double longitudeCasa = -47.004993164718364;

  Future<void> calcularDistancia() async {

    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao =
        await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();

    double resultado = Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latitudeCasa,
      longitudeCasa,
    );

    setState(() {
      distancia = resultado;
    });

    print("Distância: $distancia metros");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Distância até minha casa"),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.home,
                size: 80,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                "Distância entre a escola e minha casa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                distancia == 0
                    ? "Clique no botão para calcular a distância."
                    : "${(distancia / 1000).toStringAsFixed(2)} km",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: calcularDistancia,
                child: const Text("Calcular distância"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               