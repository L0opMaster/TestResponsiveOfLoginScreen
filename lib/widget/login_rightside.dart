import 'package:flutter/material.dart';
import 'package:test_responsive/service/auth_service.dart';
import 'package:test_responsive/core/storage_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService authService = AuthService();
  // ApiClient apiClient = ApiClient(baseUrl: BaseUrl().baseUrl);

  bool isVisible = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _terminalController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadLastLogin();
  }

  Future<void> _loadLastLogin() async {
    final data = await StorageService.getLastLogin();

    _emailController.text = data["email"] ?? "";
    _passwordController.text = data["password"] ?? "";
    _terminalController.text = data["terminal"] ?? "";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _terminalController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      bool success = await authService.login(
        email: _emailController.text,
        password: _passwordController.text,
        terminal: _terminalController.text,
      );

      if (!mounted) return;

      Navigator.pop(context);

      if (success) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        _showErrorSnackBar("Invalid login credentials");
      }
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);
      _showErrorSnackBar("Network error occurred");
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
                    labelText: "owner@kaknnea.local",
                    border: OutlineInputBorder(),
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
                    labelText: "Password123!",
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: IconButton(
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
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D45),
                  ),
                  onPressed: _handleLogin,
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
