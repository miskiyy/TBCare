// lib/pages/login_user_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_services.dart';

class LoginUserPage extends StatefulWidget {
  @override
  _LoginUserPageState createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Pasien'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nikController,
                    decoration: const InputDecoration(labelText: 'NIK'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIK tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                // TODO: Implementasi login pasien menggunakan Firebase
                                await authProvider.login(
                                  _nikController.text,
                                  _passwordController.text,
                                  'pasien',
                                );
                                Navigator.pushReplacementNamed(context, '/dashboard-pasien');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Terjadi kesalahan: $e')),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                          child: const Text('Login'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}