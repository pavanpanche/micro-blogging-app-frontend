import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth_event.dart';
import 'package:subtxt_blog/bloc/auth_state.dart';
import 'package:subtxt_blog/provider/service_provider.dart';
import 'package:subtxt_blog/screens/main_screen.dart';
import 'package:subtxt_blog/screens/register_screen.dart';
import 'package:subtxt_blog/widgets/auth_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _submitLogin({required String email, required String password}) {
    context.read<AuthBloc>().add(
      AuthLoginRequested(email: email, password: password),
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

          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => MainScreen(serviceProvider: ServiceProvider()),
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                AuthForm(
                  isLogin: true,
                  onSubmit:
                      ({required email, required password, String? username}) {
                        _submitLogin(email: email, password: password);
                      },
                ),
                const SizedBox(height: 12),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
