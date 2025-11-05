import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/calendario_screen.dart';
import 'screens/notificaciones_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini EcoTruck',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginScreen(),

      routes: {
        '/home': (_) => const HomeScreen(),
        '/perfil': (_) => const PerfilScreen(),
        '/calendario': (_) => const CalendarioScreen(),
        '/notificaciones': (_) => const NotificacionesScreen(),
      },
    );
  }
}
