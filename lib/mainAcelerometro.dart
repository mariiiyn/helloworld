import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SensorPage(),
  ));
}

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double _x = 0;
  double _y = 0;
  double _z = 0;

  double _intensidade = 0;
  bool _isMoving = false;

  StreamSubscription<AccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = accelerometerEventStream().listen((event) {
      final movimento =
          (event.x.abs() + event.y.abs() + event.z.abs()) / 3;

      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        // Converte para uma intensidade visual de 0 a 100
        _intensidade = ((movimento - 9.0).abs() * 15).clamp(0, 100);

        _isMoving = _intensidade > 18;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text(
          'Detector de Movimento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Indicador principal
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isMoving
                    ? Colors.red.withOpacity(0.15)
                    : Colors.green.withOpacity(0.15),
                border: Border.all(
                  color: _isMoving ? Colors.red : Colors.green,
                  width: 5,
                ),
              ),

              child: Icon(
                _isMoving ? Icons.vibration : Icons.phone_android,
                size: 80,
                color: _isMoving ? Colors.red : Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            // Status
            Text(
              _isMoving
                  ? 'DISPOSITIVO EM MOVIMENTO'
                  : 'DISPOSITIVO PARADO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isMoving ? Colors.red : Colors.green,
              ),
            ),

            const SizedBox(height: 30),

            // Intensidade
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      'Intensidade do movimento',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    LinearProgressIndicator(
                      value: _intensidade / 100,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.grey[300],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${_intensidade.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Valores dos sensores
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const Text(
                      'Acelerômetro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    _sensorValue('Eixo X', _x),
                    _sensorValue('Eixo Y', _y),
                    _sensorValue('Eixo Z', _z),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorValue(String eixo, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            eixo,
            style: const TextStyle(fontSize: 16),
          ),

          Text(
            '${valor.toStringAsFixed(2)} m/s²',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}