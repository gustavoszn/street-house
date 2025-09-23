import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuarioLogado');
    return userData != null ? json.decode(userData) : null;
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('usuarioLogado');
  }

  static Future<bool> isAdmin() async {
    final user = await getUser();
    if (user == null) return false;
    final nivelAcesso = user['nivelAcesso'] ?? user['nivel_acesso'];
    return nivelAcesso == 'ADMIN';
  }

  static Future<String?> getUserName() async {
    final user = await getUser();
    if (user == null) return null;
    return user['nome_artistico'] ?? 
           user['nome_organizador'] ?? 
           user['nome'] ?? 
           'Usuário';
  }
}