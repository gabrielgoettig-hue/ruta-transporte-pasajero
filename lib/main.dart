
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
  double tarifa = 5000;

  void modificarTarifa() {
    final controlador = TextEditingController(
      text: tarifa.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modificar tarifa fija'),
        content: TextField(
          controller: controlador,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Precio del viaje',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoPrecio =
                  double.tryParse(controlador.text);
              if (nuevoPrecio != null && nuevoPrecio > 0) {
                setState(() => tarifa = nuevoPrecio);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
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
                Tab(icon: Icon(Icons.admin_panel_settings), text: 'Administrador'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PasajeroPage(tarifa: tarifa),
              ConductorPage(tarifa: tarifa),
              AdministradorPage(
                tarifa: tarifa,
                onModificar: modificarTarifa,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasajeroPage extends StatelessWidget {
  final double tarifa;

  const PasajeroPage({super.key, required this.tarifa});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_taxi, size: 65),
          const SizedBox(height: 20),
          const Text('Tarifa fija del viaje',
              style: TextStyle(fontSize: 20)),
          Text(
            '\$ ${tarifa.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Consultá el precio antes de viajar.'),
        ],
      ),
    );
  }
}

class ConductorPage extends StatefulWidget {
  final double tarifa;

  const ConductorPage({super.key, required this.tarifa});

  @override
  State<ConductorPage> createState() => _ConductorPageState();
}

class _ConductorPageState extends State<ConductorPage> {
  final montoController = TextEditingController();
  DateTime fechaViaje = DateTime.now();

  double get comision {
    if (fechaViaje.weekday == DateTime.sunday) {
      return 0;
    }
    return 0.10;
  }

  @override
  void dispose() {
    montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monto = double.tryParse(montoController.text) ?? 0;
    final descuento = monto * comision;
    final recibe = monto - descuento;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Icon(Icons.account_balance_wallet, size: 55),
          const SizedBox(height: 15),
          const Text(
            'Mi billetera - Comisión por viaje',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
            controller: montoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Importe del viaje',
              prefixText: '\$ ',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Text(
            'Comisión: ${(comision * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 20),
          ),
          Text('Importe de comisión: \$ ${descuento.toStringAsFixed(0)}'),
          const Divider(height: 30),
          Text(
            'Recibe el conductor: \$ ${recibe.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Domingos: 0% de comisión. '
            'De lunes a sábado: 10%.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AdministradorPage extends StatelessWidget {
  final double tarifa;
  final VoidCallback onModificar;

  const AdministradorPage({
    super.key,
    required this.tarifa,
    required this.onModificar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 65),
            const SizedBox(height: 20),
            const Text(
              'Panel de administración',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 15),
            Text(
              'Tarifa actual: \$ ${tarifa.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onModificar,
              icon: const Icon(Icons.edit),
              label: const Text('Modificar tarifa fija'),
            ),
            const SizedBox(height: 20),
            const Text('Comisión general: 10% de lunes a sábado'),
            const Text('Domingos: 0% de comisión'),
          ],
        ),
      ),
    );
  }
}
