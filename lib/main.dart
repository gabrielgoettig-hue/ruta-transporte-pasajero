
void main() {
  runApp(const RutaTransporteApp());
}

class RutaTransporteApp extends StatelessWidget {
  const RutaTransporteApp({super.key});

  @override
  Widget 
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
