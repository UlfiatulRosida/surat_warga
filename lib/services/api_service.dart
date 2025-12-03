import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:surat_warga/services/auth_prefs.dart';

class ApiService {
  static const String baseUrl =
      'https://suratwarga.malangkab.go.id/index.php/api';

  /// Helper: generate headers with token if available
  static Future<Map<String, String>> _headersWithAuth(
      {Map<String, String>? extra}) async {
    final token = await AuthPrefs.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  /// Get current user profile (GET /api/me)
  /// Returns decoded json map or throws map with error
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final uri = Uri.parse('$baseUrl/me');
      final headers = await _headersWithAuth();
      final resp = await http.get(uri, headers: headers);
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (resp.statusCode == 200) {
        return {'success': true, 'data': body};
      }

      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil profil',
        'raw': body
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Update profile (POST /api/me/update)
  /// body example: { "nama_lengkap": "...", "no_telepon": "...", "alamat": "..." }
  static Future<Map<String, dynamic>> updateProfile({
    required String namaLengkap,
    String? noTelepon,
    String? alamat,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/me/update');
      final headers = await _headersWithAuth();
      final resp = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'nama_lengkap': namaLengkap,
          if (noTelepon != null) 'no_telepon': noTelepon,
          if (alamat != null) 'alamat': alamat,
        }),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200) {
        return {'success': true, 'data': body};
      }
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal update profil',
        'raw': body
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Get list pengaduan for current user (GET /api/pengaduan?status_privasi=Public)
  static Future<Map<String, dynamic>> getPengaduan(
      {String? statusPrivasi}) async {
    try {
      final query = statusPrivasi != null
          ? '?status_privasi=${Uri.encodeComponent(statusPrivasi)}'
          : '';
      final uri = Uri.parse('$baseUrl/pengaduan$query');
      final headers = await _headersWithAuth();
      final resp = await http.get(uri, headers: headers);
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (resp.statusCode == 200) {
        return {'success': true, 'data': body};
      }
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil pengaduan',
        'raw': body
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Create pengaduan (POST /api/pengaduan/create)
  /// body: { "judul": "...", "isi_surat": "...", "id_pd": <int>, "status_privasi": "Public" }
  static Future<Map<String, dynamic>> createPengaduan({
    required String judul,
    required String isiSurat,
    required int idPd,
    required String statusPrivasi, // "Public" atau "Private"
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/pengaduan/create');
      final headers = await _headersWithAuth();
      final resp = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'judul': judul,
          'isi_surat': isiSurat,
          'id_pd': idPd,
          'status_privasi': statusPrivasi,
        }),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return {'success': true, 'data': body};
      }
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal membuat pengaduan',
        'raw': body
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Get options PD (GET /api/options/pd) — no auth required
  static Future<Map<String, dynamic>> getOptionsPd() async {
    try {
      final uri = Uri.parse('$baseUrl/options/pd');
      final resp =
          await http.get(uri, headers: {'Content-Type': 'application/json'});
      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};

      if (resp.statusCode == 200) {
        return {'success': true, 'data': body};
      }
      return {
        'success': false,
        'message': body['message'] ?? 'Gagal mengambil options pd',
        'raw': body
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }
}
