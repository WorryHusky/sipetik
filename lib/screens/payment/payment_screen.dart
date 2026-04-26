import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetik/routes.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  const PaymentScreen({super.key, required this.bookingData});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  void _processPayment() async {
    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      final ticketId = widget.bookingData['ticket_id'];
      final passengerCount = widget.bookingData['passenger_count'];
      
      await supabase.from('bookings').insert({
        'user_id': userId,
        'ticket_id': ticketId,
        'passenger_count': passengerCount,
        'passenger_names': widget.bookingData['passenger_names'],
        'total_price': widget.bookingData['total_price'],
      });

      final ticket = await supabase.from('tickets').select('seats_available').eq('id', ticketId).single();
      int currentSeats = ticket['seats_available'] ?? 30;
      
      int newSeats = currentSeats - (passengerCount as int);
      await supabase.from('tickets').update({'seats_available': newSeats}).eq('id', ticketId);

      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.success);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Pembayaran QRIS"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Total Tagihan", style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text("Rp ${widget.bookingData['total_price']}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple.shade100, width: 2),
                boxShadow: [BoxShadow(color: Colors.purple.shade50, blurRadius: 15, spreadRadius: 5)],
              ),
              child: Column(
                children: [
                  // Fix: Menggunakan API QR Server dengan format PNG
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=PETIK-Travel-Payment',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text("QRIS PETIK TRAVEL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text("Scan menggunakan m-Banking\natau e-Wallet pilihanmu", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _isLoading ? null : _processPayment,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text("SAYA SUDAH BAYAR", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}