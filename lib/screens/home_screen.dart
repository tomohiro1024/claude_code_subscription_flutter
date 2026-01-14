import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/subscription_provider.dart';
import '../widgets/subscription_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final NumberFormat _currencyFormatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubscriptions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSubscriptions() {
    // Load subscriptions without user authentication
    context.read<SubscriptionProvider>().loadSubscriptions('default_user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'サブスク管理',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[600],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[600],
          tabs: const [
            Tab(icon: Icon(Icons.movie), text: '動画配信'),
            Tab(icon: Icon(Icons.music_note), text: '音楽配信'),
            Tab(icon: Icon(Icons.sports_soccer), text: 'スポーツ配信'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVideoStreamingList(),
          _buildMusicStreamingList(),
          _buildSportsStreamingList(),
        ],
      ),
    );
  }

  Widget _buildVideoStreamingList() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (subscriptionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final videoServices = subscriptionProvider.videoStreamingServices;

        return _buildList(videoServices, '動画配信サービスがありません');
      },
    );
  }

  Widget _buildMusicStreamingList() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (subscriptionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final musicServices = subscriptionProvider.musicStreamingServices;

        return _buildList(musicServices, '音楽配信サービスがありません');
      },
    );
  }

  Widget _buildSportsStreamingList() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        if (subscriptionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final sportsServices = subscriptionProvider.sportsStreamingServices;

        return _buildList(sportsServices, 'スポーツ配信サービスがありません');
      },
    );
  }

  Widget _buildList(List subscriptions, String emptyMessage) {
    if (subscriptions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.subscriptions_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SubscriptionCard(subscription: subscriptions[index]),
        );
      },
    );
  }
}
