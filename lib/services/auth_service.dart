import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class AuthService {
  static String? token;
  static String? rol;

  static Future<Map<String, dynamic>> login(
    String correo,
    String password,
  ) async {
    final url = Uri.parse(
      'https://ecotruck-dkfvh6e5brhqc6h5.brazilsouth-01.azurewebsites.net/api/auth/login',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': 'TU_API_KEY_AQUÍ', // Reemplaza con tu API key real
        },
        body: jsonEncode({
          'correo': correo.trim(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token = data['token'];
        rol = data['rol'];
        logger.i('Login exitoso. Rol: $rol');
        return {'success': true, 'data': data};
      } else {
        final error = jsonDecode(response.body);
        logger.w('Error de login: ${error['message']}');
        return {
          'success': false,
          'message': error['message'] ?? 'Error al iniciar sesión',
        };
      }
    } catch (e) {
      logger.e('Excepción en login', error: e);
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  /// 🔍 Decodifica el token JWT y retorna los datos del usuario
  static Map<String, dynamic>? decodeToken() {
    if (token == null) return null;

    try {
      final parts = token!.split('.');
      if (parts.length != 3) {
        logger.w('Token mal formado');
        return null;
      }

      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final decoded = jsonDecode(payload);
      logger.i('Token decodificado: $decoded');
      return decoded;
    } catch (e) {
      logger.e('Error al decodificar token', error: e);
      return null;
    }
  }
}
