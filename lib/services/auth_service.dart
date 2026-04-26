import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Fungsi Register (Sign Up) ke Supabase
  Future<AuthResponse?> register(String email, String password, String name) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name}, // Menyimpan nama di metadata user
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Fungsi Verifikasi OTP
  Future<AuthResponse?> verifyOtp(String email, String otp) async {
    try {
      final response = await supabase.auth.verifyOTP(
        type: OtpType.signup,
        token: otp,
        email: email,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Fungsi Login (Sign In) ke Supabase
  Future<AuthResponse?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      return null;
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}