import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/auth/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth/auth_event.dart';

import 'package:subtxt_blog/provider/service_provider.dart';
import 'package:subtxt_blog/screens/feed_screen.dart';
import 'package:subtxt_blog/screens/profile_screen.dart';
import 'package:subtxt_blog/screens/search_screen.dart';
import 'package:subtxt_blog/screens/trending_screen.dart';

class MainScreen extends StatefulWidget {
  final ServiceProvider serviceProvider;

  const MainScreen({super.key, required this.serviceProvider});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    const FeedScreen(),
    SearchScreen(
      tweetApiService: widget.serviceProvider.tweetApiService,
      userApiService: widget.serviceProvider.userApiService,
      profileApiService: widget.serviceProvider.profileApiService,
    ),
    TrendingScreen(tweetApiService: widget.serviceProvider.tweetApiService),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulsar'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => _onItemTapped(1),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              } else if (value == 'settings') {
                // TODO: Navigate to settings screen
              }
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
