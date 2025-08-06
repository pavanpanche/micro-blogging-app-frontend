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

    await Future.delayed(const Duration(milliseconds: 500)); // simulate delay

    widget.onSubmit(
      username: widget.isLogin ? null : _username,
      email: _email,
      password: _password,
    );

    setState(() => _isSubmitting = false);
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: color),
      prefixIcon: Icon(icon, color: color),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final maxWidth = isWide ? 450.0 : double.infinity;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
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
                        style: TextStyle(color: color),
                        decoration: _buildInputDecoration(
                          label: 'Username',
                          icon: Icons.person_outline,
                          color: color,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter username'
                            : null,
                        onSaved: (value) => _username = value!.trim(),
                      ),
                    if (!widget.isLogin) const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('email'),
                      style: TextStyle(color: color),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        color: color,
                      ),
                      validator: (value) =>
                          value == null || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                      onSaved: (value) => _email = value!.trim(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('password'),
                      style: TextStyle(color: color),
                      obscureText: true,
                      decoration: _buildInputDecoration(
                        label: 'Password',
                        icon: Icons.lock_outline,
                        color: color,
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Password must be 6+ characters'
                          : null,
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 24),
                    if (widget.isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: forgot password logic
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _trySubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? CircularProgressIndicator(
                                color: theme.colorScheme.onPrimary,
                              )
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
        },
      ),
    );
  }
}
