// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../services/api_service.dart';

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
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login Pasien'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nikController,
                    decoration: InputDecoration(labelText: 'NIK'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIK tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                final response = await apiService.login(
                                    _nikController.text, _passwordController.text, 'pasien');
                                if (response['success']) {
                                  authProvider.login('pasien');
                                  Navigator.pushReplacementNamed(context, '/dashboard-pasien');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response['message'])),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Terjadi kesalahan: $e')),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                          child: Text('Login'),
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