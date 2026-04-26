import 'package:flutter/material.dart';
import 'package:sipetik/screens/splash/splash_screen.dart';
import 'package:sipetik/screens/auth/login_screen.dart';
import 'package:sipetik/screens/auth/register_screen.dart';
import 'package:sipetik/screens/auth/otp_screen.dart'; // File baru
import 'package:sipetik/screens/home/home_screen.dart';
import 'package:sipetik/screens/booking/booking_details_screen.dart';
import 'package:sipetik/screens/payment/payment_screen.dart';
import 'package:sipetik/screens/payment/success_screen.dart';
import 'package:sipetik/screens/home/history_screen.dart';
import 'package:sipetik/screens/admin/admin_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String payment = '/payment';
  static const String success = '/success';
  static const String history = '/history';
  static const String admin = '/admin';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case otp:
        final email = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => OtpScreen(email: email));
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case booking:
        final ticket = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => BookingDetailsScreen(ticket: ticket));
      case payment:
        final bookingData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => PaymentScreen(bookingData: bookingData));
      case success:
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case admin:
        return MaterialPageRoute(builder: (_) => const AdminScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}