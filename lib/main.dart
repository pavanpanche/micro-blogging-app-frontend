import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/bloc/auth/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth/auth_event.dart';
import 'package:subtxt_blog/bloc/auth/auth_state.dart';
import 'package:subtxt_blog/screens/login_screen.dart';
import 'package:subtxt_blog/screens/main_screen.dart';
import 'package:subtxt_blog/provider/profile_provider.dart';
import 'package:subtxt_blog/provider/tweet_provider.dart';
import 'package:subtxt_blog/provider/search_provider.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/provider/service_provider.dart';

void main() {
  final serviceProvider = ServiceProvider();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) {
            final authBloc = AuthBloc(serviceProvider.authService);
            authBloc.add(AuthCheckStatus());
            return authBloc;
          },
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ProfileProvider(
              serviceProvider.profileApiService,
              serviceProvider.tweetApiService,
              serviceProvider.authService,
            ),
          ),

          ChangeNotifierProvider(
            create: (_) => TweetProvider(serviceProvider.tweetApiService),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchProvider(
              userApiService: serviceProvider.userApiService,
              tweetApiService: serviceProvider.tweetApiService,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => LikeProvider(serviceProvider.likeApiService),
          ),
        ],
        child: MyApp(serviceProvider: serviceProvider),
      ),
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ).copyWith(
              surface: Colors.grey[900],
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
              secondary: Colors.deepPurple,
              onSurface: Colors.white,
            ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[850],
          hintStyle: const TextStyle(color: Colors.white60),
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          iconColor: Colors.white,
          prefixIconColor: Colors.white70,
          suffixIconColor: Colors.white70,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.grey[900],
          textStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.deepPurpleAccent,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
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
