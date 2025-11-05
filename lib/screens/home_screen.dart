import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'perfil_screen.dart';
import 'calendario_screen.dart';
import 'notificaciones_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

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
    final datosUsuario = AuthService.decodeToken();
    final nombre = datosUsuario?['nombre'] ?? 'Usuario EcoTruck';
    final correo = datosUsuario?['correo'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: SvgPicture.asset(
                      'assets/Logo_EcoTruck.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nombre,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    correo,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendario'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarioScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificaciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificacionesScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
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
                          color: Colors.blue,
                          size: 40,
                        ),
                        builder: (context, child) => Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Builder(
              builder: (context) => FloatingActionButton(
                heroTag: 'menuTop',
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () => Scaffold.of(context).openDrawer(),
                child: const Icon(Icons.menu, color: Colors.green),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                child: Column(
                  children: const [
                    Text(
                      "1 | 12",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text("Zona: Norte", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 180,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'avisos',
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  child: const Icon(Icons.warning, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'recentrar',
                  backgroundColor: Colors.white,
                  onPressed: iniciarSeguimiento,
                  child: seguimientoActivo
                      ? const Icon(Icons.sync, color: Colors.green)
                      : const Icon(Icons.my_location, color: Colors.green),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: 'zonas',
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  child: const Icon(Icons.map, color: Colors.green),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: iniciarSeguimiento,
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
