
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

  final TextEditingController importeController =
      TextEditingController(text: '10000');

  DateTime fechaPrueba = DateTime.now();
  String resultadoComision = '';

  // Regla general: domingo 0%, lunes a sábado 10%.
  double calcularComision(double importe, DateTime fechaViaje) {
    if (fechaViaje.weekday == DateTime.sunday) {
      return 0;
    }
    return importe * 0.10;
  }

  String formatoFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  void probarComision() {
    final importe = double.tryParse(
      importeController.text.replaceAll(',', '.'),
    );

    if (importe == null || importe <= 0) {
      setState(() {
        resultadoComision = 'Ingresá un importe válido.';
      });
      return;
    }

    final comision = calcularComision(importe, fechaPrueba);
    final porcentaje =
        fechaPrueba.weekday == DateTime.sunday ? '0%' : '10%';

    setState(() {
      resultadoComision =
          'Fecha del viaje: ${formatoFecha(fechaPrueba)}\n'
          'Comisión aplicada: $porcentaje\n'
          'Importe del viaje: \$${importe.toStringAsFixed(0)}\n'
          'Comisión de Ruta Transporte: '
          '\$${comision.toStringAsFixed(0)}\n'
          'Resto para el conductor: '
          '\$${(importe - comision).toStringAsFixed(0)}';
    });
  }

  Future<void> elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaPrueba,
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
      helpText: 'Elegir fecha del viaje',
    );

    if (fecha != null) {
      setState(() {
        fechaPrueba = fecha;
        resultadoComision = '';
      });
    }
  }

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
  void dispose() {
    importeController.dispose();
    super.dispose();
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
          const SizedBox(height: 20),
          const Text(
            'Comisión general: 10% de lunes a sábado',
            textAlign: TextAlign.center,
          ),
          const Text('Domingos: 0% de comisión'),
          const SizedBox(height: 10),
          const Text(
            'La comisión se calculará al finalizar cada viaje.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget administrador() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.admin_panel_settings,
              size: 85, color: Colors.blue),
          const Text(
            'ADMINISTRACIÓN',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
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
          const Divider(height: 40),
          const Text(
            'SISTEMA DE COMISIONES',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Lunes a sábado: 10%',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Domingo: 0% - Día sin comisión',
                    style: TextStyle(
                        fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'PROBAR CÁLCULO DE COMISIÓN',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: importeController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Importe del viaje',
              prefixText: '\$ ',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: elegirFecha,
            icon: const Icon(Icons.calendar_month),
            label: Text(
              'Fecha del viaje: ${formatoFecha(fechaPrueba)}',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: probarComision,
            icon: const Icon(Icons.calculate),
            label: const Text('Calcular comisión'),
          ),
          if (resultadoComision.isNotEmpty) ...[
            const SizedBox(height: 20),
            Card(
              color: Colors.blue.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    resultadoComision,
                    style: const TextStyle(
                        fontSize: 16, height: 1.6),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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
