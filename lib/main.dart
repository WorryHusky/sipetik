import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetik/routes.dart';

void main() async {
  // Wajib ditambahkan agar inisialisasi plugin berjalan sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Koneksi ke Supabase
  await Supabase.initialize(
    url: 'https://tbkqdnazrzaydvwuomko.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRia3FkbmF6cnpheWR2d3VvbWtvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxMjY2OTYsImV4cCI6MjA5MjcwMjY5Nn0.cvsC48Nf_WhDL33jM48tn09rWF-qeYPz4LyvDxm4pXo',        
  );

  runApp(const PetikApp());
}

class PetikApp extends StatelessWidget {
  const PetikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PETIK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}