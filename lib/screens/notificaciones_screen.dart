import 'package:flutter/material.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  final List<Map<String, dynamic>> notificaciones = const [
    {
      'titulo': 'Recolección orgánica programada',
      'descripcion': 'Mañana a las 7:00 AM pasa el camión por tu zona.',
      'icono': Icons.eco,
      'color': Colors.green,
    },
    {
      'titulo': 'Cambio de ruta',
      'descripcion':
          'La ruta de reciclaje se modificó por obras viales. Consulta el nuevo mapa.',
      'icono': Icons.alt_route,
      'color': Colors.orange,
    },
    {
      'titulo': 'Mantenimiento de contenedores',
      'descripcion':
          'El contenedor de la Calle 45 estará en mantenimiento hasta el viernes.',
      'icono': Icons.build,
      'color': Colors.blueGrey,
    },
    {
      'titulo': 'Suspensión temporal',
      'descripcion': 'No habrá servicio el domingo por jornada ambiental.',
      'icono': Icons.block,
      'color': Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notificaciones.length,
        itemBuilder: (context, index) {
          final item = notificaciones[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['color'],
                child: Icon(item['icono'], color: Colors.white),
              ),
              title: Text(
                item['titulo'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['descripcion']),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Aquí podrías abrir detalles o mapa
              },
            ),
          );
        },
      ),
    );
  }
}
