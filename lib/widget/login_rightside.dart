import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_responsive/core/storage_service.dart';
import 'package:test_responsive/provider/auth_provider.dart';
import 'package:test_responsive/service/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _terminalController = TextEditingController();
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    loadingLastLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _terminalController.dispose();
    super.dispose();
  }

  Future<void> loadingLastLogin() async {
    final lastLogin = await StorageService.getLastLogin();

    setState(() {
      _emailController.text = lastLogin["email"] ?? "";
      _passwordController.text = lastLogin["password"] ?? "";
      _terminalController.text = lastLogin["terminal"] ?? "";
    });
  }

  Future<void> handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // if token already exists, user clicks login and goes home directly
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, "/home");
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      bool success = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        terminal: _terminalController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context);

      if (success) {
        final token = await StorageService.getToken();

        await StorageService.saveLogin(
          token: token,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          terminal: _terminalController.text.trim(),
        );

        await authProvider.setToken(token);

        Navigator.pushReplacementNamed(context, "/home");
      } else {
        _showErrorSnackBar('Invalid Login');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showErrorSnackBar('Network error occurred');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double boxWidth = screenWidth < 701 ? 200 : 300;
    final bool textControl = screenWidth < 600;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SizedBox(
          width: boxWidth,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (textControl)
                  const Text(
                    'KAKNNEA POS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                if (textControl) const SizedBox(height: 10),
                const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Use your staff account to continue.',
                  style: TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 20),
                const Text('EMAIL', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Email required" : null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    labelText: "email",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      gapPadding: 10,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 15),
                const Text('PASSWORD', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: isVisible,
                  validator: (value) => value == null || value.isEmpty
                      ? "Password required"
                      : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    labelText: "password",
                    labelStyle: const TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gapPadding: 10,
                    ),
                    isDense: true,
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 30,
                      minWidth: 30,
                    ),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('TERMINAL ID', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _terminalController,
                  decoration: const InputDecoration(
                    labelText: "POS-1",
                    labelStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: handleLogin,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
