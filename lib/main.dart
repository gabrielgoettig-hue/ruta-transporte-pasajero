
import 'package:flutter/material.dart';

void main() {
  runApp(const RutaTransporteApp());
}

class RutaTransporteApp extends StatelessWidget {
  const RutaTransporteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruta Transporte',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const InicioApp(),
    );
  }
}

class InicioApp extends StatefulWidget {
  const InicioApp({super.key});

  @override
  State<InicioApp> createState() => _InicioAppState();
}

class _InicioAppState extends State<InicioApp> {
  int pantalla = 0;
  double tarifa = 1500;
  bool disponible = false;

  void cambiarTarifa() {
    final controlador = TextEditingController(
      text: tarifa.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoPrecio =
                  double.tryParse(controlador.text);
              if (nuevoPrecio != null && nuevoPrecio > 0) {
                setState(() => tarifa = nuevoPrecio);
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUTA TRANSPORTE'),
        centerTitle: true,
      ),
      body: pantalla == 0
          ? pasajero()
          : pantalla == 1
              ? conductor()
              : administrador(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: pantalla,
        onDestinationSelected: (index) {
          setState(() => pantalla = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Pasajero',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Conductor',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Administrador',
          ),
        ],
      ),
    );
  }

  Widget pasajero() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_taxi,
                size: 90, color: Colors.blue),
            const Text(
              'SOLICITAR VIAJE',
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Tarifa fija: \$${tarifa.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on),
              label: const Text('Solicitar vehículo'),
            ),
            const SizedBox(height: 12),
            const Text('Próximamente: ubicación y seguimiento'),
          ],
        ),
      ),
    );
  }

  Widget conductor() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car,
              size: 85, color: Colors.blue),
          const Text(
            'PANEL DEL CONDUCTOR',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Switch(
            value: disponible,
            onChanged: (valor) {
              setState(() => disponible = valor);
            },
          ),
          Text(disponible
              ? 'Disponible para viajes'
              : 'No disponible'),
          const SizedBox(height: 15),
          const Text('Aquí aparecerán las solicitudes'),
        ],
      ),
    );
  }

  Widget administrador() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings,
                size: 85, color: Colors.blue),
            const Text(
              'ADMINISTRACIÓN',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Text(
              'Tarifa actual: \$${tarifa.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: cambiarTarifa,
              icon: const Icon(Icons.edit),
              label: const Text('Modificar tarifa'),
            ),
          ],
        ),
      ),
    );
  }
}
