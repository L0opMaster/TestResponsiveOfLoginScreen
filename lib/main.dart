import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/provider/auth_provider.dart';
import 'package:test_responsive/provider/category_provider.dart';
import 'package:test_responsive/provider/customer_provider.dart';
import 'package:test_responsive/provider/cart_provider.dart';
import 'package:test_responsive/provider/packaging_provider.dart';
import 'package:test_responsive/provider/product_provider.dart';
import 'package:test_responsive/provider/theme_provider.dart';
import 'package:test_responsive/screen/home.dart';
import 'package:test_responsive/screen/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PackagingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
      },
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blue.shade800,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      dividerColor: Colors.black12,
      iconTheme: const IconThemeData(color: Colors.black87),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue.shade300,
        secondary: Colors.blue.shade200,
        surface: const Color(0xFF1E1E1E),
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 2,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      dividerColor: Colors.white24,
      iconTheme: const IconThemeData(color: Colors.white70),
    );
  }
}
