import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng? ubicacionActual;
  bool seguimientoActivo = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> iniciarSeguimiento() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.deniedForever || !servicioActivo) return;

    setState(() => seguimientoActivo = true);

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position posicion) {
      final nuevaUbicacion = LatLng(posicion.latitude, posicion.longitude);
      setState(() => ubicacionActual = nuevaUbicacion);
      _mapController.move(nuevaUbicacion, 16);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            mapController: _mapController,
            options: MapOptions(
              center: const LatLng(10.3910, -75.4794),
              zoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecotruck',
              ),
              if (ubicacionActual != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: ubicacionActual!,
                      width: 60,
                      height: 60,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        child: const Icon(
                          Icons.my_location,
                          color: Color.fromARGB(181, 156, 145, 43),
                          size: 40,
                        ),
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: child,
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Botón hamburguesa
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

          // Botones flotantes
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'avisos',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: () {},
                  child: const Icon(Icons.warning, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'recentrar',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: iniciarSeguimiento,
                  child: seguimientoActivo
                      ? const Icon(Icons.sync, color: Colors.green)
                      : const Icon(Icons.my_location, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'zonas',
                  backgroundColor: const Color(0xFFF5F6F7),
                  onPressed: () {},
                  child: const Icon(Icons.map, color: Colors.green),
                ),
              ],
            ),
          ),

          // Botón inferior
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
                  onPressed: iniciarSeguimiento, // ✅ Aquí se activa también
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
