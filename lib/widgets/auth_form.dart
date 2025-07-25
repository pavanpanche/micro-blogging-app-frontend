import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final void Function({
    String? username,
    required String email,
    required String password,
  })
  onSubmit;

  const AuthForm({super.key, required this.isLogin, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isSubmitting = false;

  void _trySubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);

    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // simulate small delay
    widget.onSubmit(
      username: widget.isLogin ? null : _username,
      email: _email,
      password: _password,
    );

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isLogin)
                TextFormField(
                  key: const ValueKey('username'),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter username'
                      : null,
                  onSaved: (value) => _username = value!,
                ),
              if (!widget.isLogin) const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('email'),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !value.contains('@')
                    ? 'Enter valid email'
                    : null,
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const ValueKey('password'),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be 6+ characters'
                    : null,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _trySubmit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.isLogin ? 'Login' : 'Register',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
