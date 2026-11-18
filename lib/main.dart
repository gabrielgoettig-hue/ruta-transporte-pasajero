
import 'package:flutter/material.dart';

void main() {
  runApp(const RutaTransporteApp());
}

class RutaTransporteApp extends StatefulWidget {
  const RutaTransporteApp({super.key});

  @override
  State<RutaTransporteApp> createState() =>
      _RutaTransporteAppState();
}

class _RutaTransporteAppState extends State<RutaTransporteApp> {
  double tarifaMinima = 3500;
  double precioKilometro = 700;

  double calcularPrecio(double km) {
    if (km <= 3) return tarifaMinima;

    final adicionales = (km - 3).ceil();
    return tarifaMinima + adicionales * precioKilometro;
  }

  Future<void> modificarTarifas() async {
    final minimaController = TextEditingController(
      text: tarifaMinima.toStringAsFixed(0),
    );

    final kilometroController = TextEditingController(
      text: precioKilometro.toStringAsFixed(0),
    );

    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modificar tarifas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: minimaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tarifa mínima hasta 3 km',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: kilometroController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilómetro adicional',
                prefixText: '\$ ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final minima =
                  double.tryParse(minimaController.text);
              final kilometro =
                  double.tryParse(kilometroController.text);

              if (minima != null &&
                  kilometro != null &&
                  minima > 0 &&
                  kilometro > 0) {
                setState(() {
                  tarifaMinima = minima;
                  precioKilometro = kilometro;
                });
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ingresá importes válidos.'),
                  ),
                );
              }
            },
            child: const Text('Guardar tarifas'),
          ),
        ],
      ),
    );

    minimaController.dispose();
    kilometroController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruta Transporte Pasajeros',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ruta Transporte'),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'Pasajero'),
                Tab(icon: Icon(Icons.directions_car), text: 'Conductor'),
                Tab(
                  icon: Icon(Icons.admin_panel_settings),
                  text: 'Administrador',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PasajeroPage(
                calcularPrecio: calcularPrecio,
              ),
              ConductorPage(
                calcularPrecio: calcularPrecio,
              ),
              AdministradorPage(
                tarifaMinima: tarifaMinima,
                precioKilometro: precioKilometro,
                onModificar: modificarTarifas,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasajeroPage extends StatefulWidget {
  final double Function(double) calcularPrecio;

  const PasajeroPage({
    super.key,
    required this.calcularPrecio,
  });

  @override
  State<PasajeroPage> createState() => _PasajeroPageState();
}

class _PasajeroPageState extends State<PasajeroPage> {
  final distanciaController = TextEditingController();

  @override
  void dispose() {
    distanciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final km = double.tryParse(distanciaController.text) ?? 0;
    final precio = km > 0 ? widget.calcularPrecio(km) : 0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Icon(Icons.local_taxi, size: 65),
          const SizedBox(height: 15),
          const Text(
            'Solicitar un viaje',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: distanciaController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Distancia estimada en kilómetros',
              prefixIcon: Icon(Icons.route),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 25),
          const Text(
            'Precio estimado del viaje',
            textAlign: TextAlign.center,
          ),
          Text(
            km > 0 ? '\$ ${precio.toStringAsFixed(0)}' : '\$ 0',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Hasta 3 km se aplica la tarifa mínima. '
            'Cada kilómetro adicional iniciado se cobra completo.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: null,
            child: const Text('Solicitar viaje próximamente'),
          ),
        ],
      ),
    );
  }
}

class ConductorPage extends StatefulWidget {
  final double Function(double) calcularPrecio;

  const ConductorPage({
    super.key,
    required this.calcularPrecio,
  });

  @override
  State<ConductorPage> createState() => _ConductorPageState();
}

class _ConductorPageState extends State<ConductorPage> {
  final distanciaController = TextEditingController();
  DateTime fechaViaje = DateTime.now();

  @override
  void dispose() {
    distanciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final km = double.tryParse(distanciaController.text) ?? 0;
    final monto = km > 0 ? widget.calcularPrecio(km) : 0.0;

    final comision = fechaViaje.weekday == DateTime.sunday
        ? 0.0
        : 0.10;

    final descuento = monto * comision;
    final recibe = monto - descuento;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Icon(Icons.account_balance_wallet, size: 55),
          const Text(
            'Mi billetera - Cálculo de viaje',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Fecha del viaje'),
            subtitle: Text(
              '${fechaViaje.day}/${fechaViaje.month}/${fechaViaje.year}',
            ),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final elegida = await showDatePicker(
                context: context,
                initialDate: fechaViaje,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );

              if (elegida != null) {
                setState(() => fechaViaje = elegida);
              }
            },
          ),
          TextField(
            controller: distanciaController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Distancia del viaje en km',
              prefixIcon: Icon(Icons.route),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text('Precio del viaje: \$ ${monto.toStringAsFixed(0)}'),
          Text('Comisión: ${(comision * 100).toStringAsFixed(0)}%'),
          Text('Importe de comisión: \$ ${descuento.toStringAsFixed(0)}'),
          const Divider(height: 35),
          Text(
            'Recibe el conductor: \$ ${recibe.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Lunes a sábado: 10% de comisión.\n'
            'Domingos: 0% de comisión.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AdministradorPage extends StatelessWidget {
  final double tarifaMinima;
  final double precioKilometro;
  final Future<void> Function() onModificar;

  const AdministradorPage({
    super.key,
    required this.tarifaMinima,
    required this.precioKilometro,
    required this.onModificar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 65,
            ),
            const SizedBox(height: 20),
            const Text(
              'Panel de administración',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              'Tarifa mínima: \$ ${tarifaMinima.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'Kilómetro adicional: \$ ${precioKilometro.toStringAsFixed(0)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () async {
  await onModificar();
},
              icon: const Icon(Icons.edit),
              label: const Text('Modificar tarifas'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hasta 3 km se cobra la tarifa mínima.\n'
              'Cada kilómetro adicional iniciado se cobra completo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
