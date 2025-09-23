import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Resolves correct base URL for emulator/device
  static String get baseUrl {
    // Web usa diretamente localhost
    if (kIsWeb) {
      return 'http://localhost:8081';
    }
    // Android emulator não alcança 127.0.0.1 da máquina; usa 10.0.2.2
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8081';
    }
    // iOS simulator and desktop can use localhost directly
    return 'http://localhost:8081';
  }
  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuarioLogado', json.encode(user));
  }
  
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuarioLogado');
    return userData != null ? json.decode(userData) : null;
  }
  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuarioLogado');
  }
  
  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
  
  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    final headers = await getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }

  static Future<void> delete(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro na requisição: ${response.statusCode}');
    }
  }
  
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    // Teste simples primeiro
    try {
      print('Testando conexão com: $baseUrl');
      final testResponse = await http.get(Uri.parse('https://httpbin.org/get')).timeout(Duration(seconds: 5));
      print('Teste httpbin funcionou: ${testResponse.statusCode}');
    } catch (e) {
      print('Teste httpbin falhou: $e');
    }
    
    try {
      print('Tentando login em: $baseUrl/usuarios/login');
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'senha': senha}),
      ).timeout(Duration(seconds: 15));
      
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['token'] != null) {
          await saveToken(data['token']);
          await saveUser(data['usuario']);
        } else {
          await saveUser(data);
        }
        
        return data;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? errorData['message'] ?? 'Erro no login');
      }
    } catch (e) {
      print('Erro detalhado no login: $e');
      throw Exception('Falha na conexão: ${e.toString()}');
    }
  }
}