import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/auth_bloc.dart';
import 'package:subtxt_blog/bloc/auth_event.dart';
import 'package:subtxt_blog/bloc/auth_state.dart';
import 'package:subtxt_blog/bloc/feed_bloc.dart';
import 'package:subtxt_blog/bloc/feed_event.dart';
import 'package:subtxt_blog/bloc/follow_bloc.dart';
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
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    final currentUsername = authState is AuthSuccess
        ? authState.user.username
        : '';

    _screens = [
      FeedScreen(
        likeApiService: widget.serviceProvider.likeApiService,
        feedApiService: widget.serviceProvider.feedApiService,
      ),
      SearchScreen(
        feedApiService: widget.serviceProvider.feedApiService,
        userApiService: widget.serviceProvider.userApiService,
        followApiService: widget.serviceProvider.followApiService,
      ),
      BlocProvider(
        create: (_) =>
            FeedBloc(feedApiService: widget.serviceProvider.feedApiService)
              ..add(FetchRecentTweets(reset: true)),
        child: TrendingScreen(
          feedApiService: widget.serviceProvider.feedApiService,
        ),
      ),
      BlocProvider(
        create: (_) =>
            FollowBloc(followService: widget.serviceProvider.followApiService),
        child: ProfileScreen(
          username: currentUsername,
          userApiService: widget.serviceProvider.userApiService,
          followApiService: widget.serviceProvider.followApiService,
          feedApiService: widget.serviceProvider.feedApiService, // ✅ ADDED
        ),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

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
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(AuthLogoutRequested());
              } else if (value == 'settings') {}
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
