import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LatLng mapCenter = LatLng(10.3910, -75.4794); // Cartagena

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menú EcoTruck',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(leading: Icon(Icons.person), title: Text('Perfil')),
            ListTile(leading: Icon(Icons.logout), title: Text('Cerrar sesión')),
          ],
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(center: mapCenter, zoom: 13),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecotruck',
              ),
            ],
          ),

          // 🟢 Botón hamburguesa superior izquierdo
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'menuTop',
              mini: true,
              backgroundColor: const Color(0xFFF5F6F7),
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu, color: Colors.green),
            ),
          ),

          // 🧭 Indicador principal (top-center)
          Positioned(
            top: 25,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: Container(
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              alignment: Alignment.center,
              child: const Text('1 | 12', style: TextStyle(fontSize: 22)),
            ),
          ),

          // 🔢 Subcontador (debajo del indicador)
          Positioned(
            top: 85,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.shade100),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
              ),
              alignment: Alignment.center,
              child: const Text('0 | 0', style: TextStyle(fontSize: 16)),
            ),
          ),

          // 🎯 Botones flotantes en cascada (right-bottom)
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'avisos',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: () {
                    // Acción para avisos
                  },
                  child: const Icon(Icons.warning, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'recentrar',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: () {
                    // Acción para recentrar
                  },
                  child: const Icon(Icons.my_location, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'zonas',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: () {
                    // Acción para mostrar/ocultar zonas
                  },
                  child: const Icon(Icons.map, color: Colors.green),
                ),
              ],
            ),
          ),

          // 🟢 Botón principal inferior (Conectar)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    // Acción de conexión
                  },
                  child: const Text('Conectar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
