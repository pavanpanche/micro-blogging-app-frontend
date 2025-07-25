import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth_event.dart';
import 'package:subtxt_blog/bloc/auth_state.dart';
import 'package:subtxt_blog/screens/login_screen.dart';
import '../widgets/auth_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  void _submitRegister({
    required String username,
    required String email,
    required String password,
  }) {
    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        username: username,
        email: email,
        password: password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() => _isLoading = state is AuthLoading);

          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is AuthUnauthenticated) {
            // Registration success → navigate to LoginScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                AuthForm(
                  isLogin: false,
                  onSubmit:
                      ({required email, required password, String? username}) {
                        if (username != null) {
                          _submitRegister(
                            username: username,
                            email: email,
                            password: password,
                          );
                        }
                      },
                ),
                const SizedBox(height: 12),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text("Already have an account? Login"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
