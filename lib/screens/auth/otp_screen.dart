import 'package:flutter/material.dart';
import 'package:sipetik/routes.dart';
import 'package:sipetik/services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthService _authService = AuthService();
  final _otpController = TextEditingController();
  bool _isLoading = false;

  void _verifyOtp() async {
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan kode OTP!')));
      return;
    }

    setState(() => _isLoading = true);
    
    final response = await _authService.verifyOtp(widget.email, _otpController.text.trim());
    
    setState(() => _isLoading = false);

    if (response != null && response.session != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verifikasi Berhasil!')));
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kode OTP salah atau kedaluwarsa!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.mark_email_read, size: 80, color: Colors.purple),
            const SizedBox(height: 24),
            const Text("Verifikasi Email", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              "Masukkan 8 digit kode yang telah kami kirimkan ke email\n${widget.email}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _otpController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text, // Diubah ke text jaga-jaga kalau Supabase kirim kombinasi huruf+angka
              maxLength: 8, // Diubah jadi 8 digit
              style: const TextStyle(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.bold), // letterSpacing dikurangi biar muat 8 karakter
              decoration: InputDecoration(
                counterText: "",
                hintText: "00000000", // Diubah jadi 8 digit
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _isLoading ? null : _verifyOtp,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("VERIFIKASI", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}