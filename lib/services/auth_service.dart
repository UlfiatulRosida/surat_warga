import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:surat_warga/services/auth_prefs.dart';

class AuthService {
  static const String baseUrl =
      'https://suratwarga.malangkab.go.id/index.php/api';

  /// LOGIN
  /// API expects: { "identity": "<username_or_email>", "password": "<password>" }
  /// Returns: {'success': bool, 'message': String, 'token': String?}
  static Future<Map<String, dynamic>> login(
      String identity, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/login');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'identity': identity, 'password': password}),
      );

      final code = resp.statusCode;
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (code == 200 &&
          body is Map &&
          (body['token'] != null || body['success'] == true)) {
        final token = body['token'] ??
            (body['data'] != null && body['data']['token'] != null
                ? body['data']['token']
                : null);
        if (token != null) {
          await AuthPrefs.saveToken(token);
        }
        return {
          'success': body['success'] ?? true,
          'message': body['message'] ?? 'Login berhasil',
          'token': token,
          'raw': body,
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal melakukan login',
        'raw': body,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// REGISTER
  /// API expects fields similar to the Postman collection:
  /// {
  ///   "nama_lengkap": "...",
  ///   "username": "...",
  ///   "email": "...",
  ///   "password": "...",
  ///   "no_telepon": "...",
  ///   "alamat": "..."
  /// }
  /// Returns API response as Map
  static Future<Map<String, dynamic>> register({
    required String namaLengkap,
    required String username,
    required String email,
    required String password,
    required String noTelepon,
    required String alamat,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/register');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama_lengkap': namaLengkap,
          'username': username,
          'email': email,
          'password': password,
          'no_telepon': noTelepon,
          'alamat': alamat,
        }),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return {
          'success': body['success'] ?? true,
          'message': body['message'] ?? 'Registrasi berhasil',
          'raw': body,
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal registrasi',
        'raw': body,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  /// LOGOUT LOCAL
  /// Hanya menghapus token lokal (jika backend punya endpoint logout, kita bisa panggil juga)
  static Future<void> logoutLocal() async {
    await AuthPrefs.clearToken();
  }

  /// Optional: logout di server jika endpoint tersedia (/api/logout)
  static Future<Map<String, dynamic>> logoutServer() async {
    try {
      final token = await AuthPrefs.getToken();
      if (token == null) {
        await AuthPrefs.clearToken();
        return {'success': true, 'message': 'No token (already logged out)'};
      }

      final uri = Uri.parse('$baseUrl/logout');
      final resp = await http.post(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      // Hapus token lokal walau server error (biar user tetap logout di app)
      await AuthPrefs.clearToken();

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        return {
          'success': true,
          'message': body['message'] ?? 'Logout berhasil'
        };
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal logout di server',
        'raw': body
      };
    } catch (e) {
      await AuthPrefs.clearToken();
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
