import 'package:flutter/material.dart';
import 'package:subtxt_blog/services/auth_service.dart';
import 'package:subtxt_blog/screens/login_screen.dart'; // <-- update if your login screen has a different path/name

class ProfileScreen extends StatefulWidget {
  final String? username; // optional

  const ProfileScreen({super.key, this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    if (widget.username != null) {
      setState(() => _username = widget.username);
    } else {
      final name = await AuthService().getUsername();
      setState(() => _username = name ?? 'Guest');
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();

    // Navigate to login screen and clear backstack
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_username != null ? '@$_username' : 'Loading...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: _username == null
            ? const CircularProgressIndicator()
            : Text('Profile screen for @$_username'),
      ),
    );
  }
}
