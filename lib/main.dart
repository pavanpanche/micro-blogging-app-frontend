import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth_event.dart';
import 'package:subtxt_blog/bloc/auth_state.dart';
import 'package:subtxt_blog/provider/service_provider.dart';
import 'package:subtxt_blog/screens/login_screen.dart';
import 'package:subtxt_blog/screens/main_screen.dart';

void main() {
  final serviceProvider =
      ServiceProvider(); // Make sure this class is defined and imported

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final authBloc = AuthBloc(serviceProvider.authService);
            authBloc.add(AuthCheckStatus());
            return authBloc;
          },
        ),
      ],
      child: MyApp(serviceProvider: serviceProvider),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ServiceProvider serviceProvider;

  const MyApp({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SubTxt Blog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return MainScreen(serviceProvider: serviceProvider);
          } else if (state is AuthUnauthenticated || state is AuthInitial) {
            return const LoginScreen();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
