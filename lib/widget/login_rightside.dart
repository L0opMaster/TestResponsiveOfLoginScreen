import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isVisible = true;

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
                  validator: (value) =>
                      value == null || value.isEmpty ? "Email required" : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),

                    labelText: "owner@kaknnea.local",
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
                  obscureText: isVisible,
                  validator: (value) => value == null || value.isEmpty
                      ? "Password required"
                      : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    labelText: "Password123!",
                    labelStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gapPadding: 10,
                    ),
                    isDense: true,

                    // 👇 reduce icon container size
                    suffixIconConstraints: const BoxConstraints(
                      minHeight: 30,
                      minWidth: 30,
                    ),

                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(), //remove default 48x48
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D45),
                  ),
                  onPressed: () {},
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
