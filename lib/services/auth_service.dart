import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  
  // Tambahkan alias untuk compatibility
  bool get isLoggedIn => _isAuthenticated; // <-- INI DITAMBAHKAN

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('🔐 Attempting Supabase login with: $email');
      
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      print('✅ Login response: ${response.user?.email}');
      print('✅ Session: ${response.session != null ? "Valid" : "Invalid"}');
      
      if (response.user != null && response.session != null) {
        _isAuthenticated = true;
        print('✅ Authentication successful!');
        notifyListeners();
        return true;
      }
      
      print('❌ Authentication failed - no user or session');
      return false;
    } catch (e, stackTrace) {
      print('❌ Login error: $e');
      print('❌ Stack trace: $stackTrace');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      _isAuthenticated = false;
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final session = _supabase.auth.currentSession;
      _isAuthenticated = session != null;
      print('🔍 Auth status: $_isAuthenticated');
      print('🔍 Current user: ${_supabase.auth.currentUser?.email}');
    } catch (e) {
      _isAuthenticated = false;
      print('❌ Check auth status error: $e');
    }
    notifyListeners();
  }

  void printCurrentAuth() {
    print('🔄 Current session: ${_supabase.auth.currentSession}');
    print('🔄 Current user: ${_supabase.auth.currentUser?.email}');
    print('🔄 Is authenticated: $_isAuthenticated');
  }
}