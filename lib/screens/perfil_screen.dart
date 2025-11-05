import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 👇 Necesario para capturar cámara en Web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../services/auth_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Uint8List? _imagenBytes;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? datosUsuario;

  @override
  void initState() {
    super.initState();
    datosUsuario = AuthService.decodeToken();
  }

  Future<void> _mostrarOpcionesSeleccionImagen() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text("Seleccionar de Galería"),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text("Tomar Foto"),
              onTap: () {
                Navigator.pop(context);
                _seleccionarImagen(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    if (kIsWeb && source == ImageSource.camera) {
      final html.InputElement input = html.InputElement(type: 'file')
        ..accept = 'image/*'
        ..capture = 'camera';

      input.onChange.listen((event) {
        final file = input.files?.first;
        if (file != null) {
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) {
            setState(() {
              _imagenBytes = reader.result as Uint8List;
            });
          });
        }
      });

      input.click();
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      setState(() => _imagenBytes = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre = datosUsuario?['nombre'] ?? 'Sin nombre';
    final correo = datosUsuario?['correo'] ?? 'Sin correo';
    final rol = AuthService.rol ?? 'Sin rol';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipOval(
                    child: _imagenBytes != null
                        ? Image.memory(_imagenBytes!, fit: BoxFit.cover)
                        : SvgPicture.asset(
                            'assets/Logo_EcoTruck.svg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                IconButton(
                  onPressed: _mostrarOpcionesSeleccionImagen,
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _infoCard(Icons.person, nombre, "Nombre"),
            const SizedBox(height: 12),
            _infoCard(Icons.email, correo, "Correo electrónico"),
            const SizedBox(height: 12),
            _infoCard(Icons.badge, rol, "Rol"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil actualizado (pendiente guardar).'),
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text("Guardar Cambios"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(IconData icono, String titulo, String subtitulo) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icono, color: Colors.green),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
      ),
    );
  }
}
