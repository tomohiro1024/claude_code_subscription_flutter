import 'package:flutter/foundation.dart';
import '../models/subscription_model.dart';

class SubscriptionProvider with ChangeNotifier {
  List<SubscriptionModel> _subscriptions = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<SubscriptionModel> get subscriptions => _subscriptions;
  List<SubscriptionModel> get activeSubscriptions => 
      _subscriptions.where((sub) => sub.isActive).toList();
  List<SubscriptionModel> get cancelledSubscriptions => 
      _subscriptions.where((sub) => sub.isCancelled).toList();
  
  List<SubscriptionModel> get videoStreamingServices => _subscriptions.where((sub) => 
      ['Netflix', 'Amazon Prime Video', 'Disney+', 'Hulu', 'U-NEXT', 'ABEMAプレミアム'].contains(sub.serviceName)).toList();
  
  List<SubscriptionModel> get musicStreamingServices => _subscriptions.where((sub) => 
      ['Spotify Premium', 'Apple Music', 'Amazon Music Unlimited', 'YouTube Music', 'LINE MUSIC'].contains(sub.serviceName)).toList();
  
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  
  int get activeSubscriptionCount => activeSubscriptions.length;

  Future<void> loadSubscriptions(String userId) async {
    _setLoading(true);
    _setError('');
    
    try {
      // In a real app, this would fetch from Firestore
      // For demo purposes, we'll load sample data
      await Future.delayed(const Duration(seconds: 1));
      _loadSampleData();
      _setLoading(false);
    } catch (e) {
      _setError('サブスクリプション情報の読み込みに失敗しました');
      _setLoading(false);
    }
  }

  void _loadSampleData() {
    _subscriptions = [
      // 動画配信サービス
      SubscriptionModel(
        id: '1',
        userId: 'sample_user',
        serviceName: 'Netflix',
        serviceLogoUrl: 'https://img.icons8.com/color/48/netflix.png',
        monthlyPrice: 1490,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        nextBillingDate: DateTime.now().add(const Duration(days: 5)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.netflix.com/cancelplan',
        customerServicePhone: '0120-996-012',
      ),
      SubscriptionModel(
        id: '2',
        userId: 'sample_user',
        serviceName: 'Amazon Prime Video',
        serviceLogoUrl: 'https://img.icons8.com/color/48/amazon-prime-video.png',
        monthlyPrice: 500,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 120)),
        nextBillingDate: DateTime.now().add(const Duration(days: 10)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.amazon.co.jp/gp/video/mystuff/watchlist',
        customerServicePhone: '0120-999-373',
      ),
      SubscriptionModel(
        id: '3',
        userId: 'sample_user',
        serviceName: 'Disney+',
        serviceLogoUrl: 'https://lumiere-a.akamaihd.net/v1/images/dplogo_bg800x800_11482e7e.jpeg',
        monthlyPrice: 990,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        nextBillingDate: DateTime.now().add(const Duration(days: 15)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.disneyplus.com/account',
        customerServiceEmail: 'support@disneyplus.com',
      ),
      SubscriptionModel(
        id: '4',
        userId: 'sample_user',
        serviceName: 'Hulu',
        serviceLogoUrl: 'https://img.icons8.com/color/48/hulu.png',
        monthlyPrice: 1026,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 45)),
        nextBillingDate: DateTime.now().add(const Duration(days: 20)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.hulu.jp/account',
        customerServiceEmail: 'support@hulu.jp',
      ),
      SubscriptionModel(
        id: '5',
        userId: 'sample_user',
        serviceName: 'U-NEXT',
        serviceLogoUrl: 'https://img.icons8.com/color/48/u-next.png',
        monthlyPrice: 2189,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        nextBillingDate: DateTime.now().add(const Duration(days: 25)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://video.unext.jp/settings/subscription',
        customerServicePhone: '0570-064-996',
      ),
      SubscriptionModel(
        id: '6',
        userId: 'sample_user',
        serviceName: 'ABEMAプレミアム',
        serviceLogoUrl: 'https://img.icons8.com/color/48/abema.png',
        monthlyPrice: 960,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        nextBillingDate: DateTime.now().add(const Duration(days: 30)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://abema.tv/account',
        customerServiceEmail: 'support@abema.tv',
      ),
      
      // 音楽配信サービス
      SubscriptionModel(
        id: '7',
        userId: 'sample_user',
        serviceName: 'Spotify Premium',
        serviceLogoUrl: 'https://img.icons8.com/color/48/spotify.png',
        monthlyPrice: 980,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        nextBillingDate: DateTime.now().add(const Duration(days: 12)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.spotify.com/jp/account/subscription/',
        customerServiceEmail: 'support@spotify.com',
      ),
      SubscriptionModel(
        id: '8',
        userId: 'sample_user',
        serviceName: 'Apple Music',
        serviceLogoUrl: 'https://img.icons8.com/color/48/apple-music.png',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 150)),
        nextBillingDate: DateTime.now().add(const Duration(days: 8)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://music.apple.com/account/settings',
        customerServicePhone: '0120-277-535',
      ),
      SubscriptionModel(
        id: '9',
        userId: 'sample_user',
        serviceName: 'Amazon Music Unlimited',
        serviceLogoUrl: 'https://img.icons8.com/color/48/amazon-music.png',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        nextBillingDate: DateTime.now().add(const Duration(days: 18)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://music.amazon.co.jp/settings/subscription',
        customerServicePhone: '0120-999-373',
      ),
      SubscriptionModel(
        id: '10',
        userId: 'sample_user',
        serviceName: 'YouTube Music',
        serviceLogoUrl: 'https://img.icons8.com/color/48/youtube-music.png',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        nextBillingDate: DateTime.now().add(const Duration(days: 22)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://music.youtube.com/settings',
        customerServiceEmail: 'support@youtube.com',
      ),
      SubscriptionModel(
        id: '11',
        userId: 'sample_user',
        serviceName: 'LINE MUSIC',
        serviceLogoUrl: 'https://img.icons8.com/color/48/line-me.png',
        monthlyPrice: 980,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 40)),
        cancelledAt: DateTime.now().subtract(const Duration(days: 5)),
        status: SubscriptionStatus.cancelled,
        cancellationUrl: 'https://music.line.me/settings',
        customerServiceEmail: 'support@linemusic.co.jp',
      ),
    ];
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    _setLoading(true);
    _setError('');
    
    try {
      // In a real app, this would call the API to cancel the subscription
      await Future.delayed(const Duration(seconds: 1));
      
      final index = _subscriptions.indexWhere((sub) => sub.id == subscriptionId);
      if (index != -1) {
        _subscriptions[index] = SubscriptionModel(
          id: _subscriptions[index].id,
          userId: _subscriptions[index].userId,
          serviceName: _subscriptions[index].serviceName,
          serviceLogoUrl: _subscriptions[index].serviceLogoUrl,
          monthlyPrice: _subscriptions[index].monthlyPrice,
          currency: _subscriptions[index].currency,
          startDate: _subscriptions[index].startDate,
          nextBillingDate: null,
          cancelledAt: DateTime.now(),
          status: SubscriptionStatus.cancelled,
          cancellationUrl: _subscriptions[index].cancellationUrl,
          customerServicePhone: _subscriptions[index].customerServicePhone,
          customerServiceEmail: _subscriptions[index].customerServiceEmail,
        );
      }
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('サブスクリプションの解約に失敗しました');
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void updateSubscriptionStatus(String subscriptionId, SubscriptionStatus newStatus) {
    final index = _subscriptions.indexWhere((sub) => sub.id == subscriptionId);
    if (index != -1) {
      _subscriptions[index] = SubscriptionModel(
        id: _subscriptions[index].id,
        userId: _subscriptions[index].userId,
        serviceName: _subscriptions[index].serviceName,
        serviceLogoUrl: _subscriptions[index].serviceLogoUrl,
        monthlyPrice: _subscriptions[index].monthlyPrice,
        currency: _subscriptions[index].currency,
        startDate: _subscriptions[index].startDate,
        nextBillingDate: newStatus == SubscriptionStatus.active 
            ? _subscriptions[index].nextBillingDate ?? DateTime.now().add(const Duration(days: 30))
            : null,
        cancelledAt: newStatus == SubscriptionStatus.cancelled 
            ? DateTime.now() 
            : null,
        status: newStatus,
        cancellationUrl: _subscriptions[index].cancellationUrl,
        customerServicePhone: _subscriptions[index].customerServicePhone,
        customerServiceEmail: _subscriptions[index].customerServiceEmail,
      );
      notifyListeners();
    }
  }
}