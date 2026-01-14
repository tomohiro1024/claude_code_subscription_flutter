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

  List<SubscriptionModel> get videoStreamingServices =>
      _subscriptions
          .where(
            (sub) => [
              'Netflix',
              'Amazon Prime Video',
              'Disney+',
              'Hulu',
              'U-NEXT',
              'ABEMAプレミアム',
              'YouTube Premium',
            ].contains(sub.serviceName),
          )
          .toList();

  List<SubscriptionModel> get musicStreamingServices =>
      _subscriptions
          .where(
            (sub) => [
              'Spotify Premium',
              'Apple Music',
              'Amazon Music Unlimited',
              'YouTube Music',
              'LINE MUSIC',
            ].contains(sub.serviceName),
          )
          .toList();

  List<SubscriptionModel> get sportsStreamingServices =>
      _subscriptions
          .where((sub) => ['DAZN', 'SPOTV NOW'].contains(sub.serviceName))
          .toList();

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
        serviceLogoUrl:
            'https://assets.st-note.com/production/uploads/images/84831104/picture_pc_c1ff6adc172e4b1a708881f2f508ebaf.png?width=1200',
        monthlyPrice: 1490,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.netflix.com/cancelplan',
        customerServicePhone: '0120-996-012',
      ),
      SubscriptionModel(
        id: '2',
        userId: 'sample_user',
        serviceName: 'Amazon Prime Video',
        serviceLogoUrl: 'https://m.media-amazon.com/images/I/31W9hs7w0JL.png',
        monthlyPrice: 500,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.amazon.co.jp/gp/video/mystuff/watchlist',
        customerServicePhone: '0120-999-373',
      ),
      SubscriptionModel(
        id: '3',
        userId: 'sample_user',
        serviceName: 'Disney+',
        serviceLogoUrl:
            'https://lumiere-a.akamaihd.net/v1/images/dplogo_bg800x800_11482e7e.jpeg',
        monthlyPrice: 990,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.disneyplus.com/account',
        customerServiceEmail: 'support@disneyplus.com',
      ),
      SubscriptionModel(
        id: '4',
        userId: 'sample_user',
        serviceName: 'Hulu',
        serviceLogoUrl:
            'https://store-images.s-microsoft.com/image/apps.60756.9007199266246590.a8642808-8fcd-48e6-805e-aede1f148787.c1baaaf0-7b9d-4e6e-9661-56452a1f7ddd',
        monthlyPrice: 1026,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.hulu.jp/account',
        customerServiceEmail: 'support@hulu.jp',
      ),
      SubscriptionModel(
        id: '5',
        userId: 'sample_user',
        serviceName: 'U-NEXT',
        serviceLogoUrl:
            'https://play-lh.googleusercontent.com/gV6YXOBVU1n7uwgVrbl6mZzny8dCtC5e3cw7yueAvN2vMSPaurbEOvHVuH0ToeXY928',
        monthlyPrice: 2189,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://video.unext.jp/settings/subscription',
        customerServicePhone: '0570-064-996',
      ),
      SubscriptionModel(
        id: '6',
        userId: 'sample_user',
        serviceName: 'ABEMAプレミアム',
        serviceLogoUrl:
            'https://img.my-best.com/product_images/0e54923afca53590988d3ccb5ba1d597.jpeg?ixlib=rails-4.3.1&q=45&lossless=0&w=280&h=280&fit=clip&s=18e071e331a98e5c721d152451d85d7e',
        monthlyPrice: 960,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://abema.tv/account',
        customerServiceEmail: 'support@abema.tv',
      ),
      SubscriptionModel(
        id: '12',
        userId: 'sample_user',
        serviceName: 'YouTube Premium',
        serviceLogoUrl: 'https://m.media-amazon.com/images/I/4195dyf+rFL.png',
        monthlyPrice: 1280,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.youtube.com/paid_memberships',
        customerServiceEmail: 'support@youtube.com',
      ),

      // 音楽配信サービス
      SubscriptionModel(
        id: '7',
        userId: 'sample_user',
        serviceName: 'Spotify Premium',
        serviceLogoUrl: 'https://m.media-amazon.com/images/I/31B2Nyzd8XL.png',
        monthlyPrice: 980,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.spotify.com/jp/account/subscription/',
        customerServiceEmail: 'support@spotify.com',
      ),
      SubscriptionModel(
        id: '8',
        userId: 'sample_user',
        serviceName: 'Apple Music',
        serviceLogoUrl:
            'https://store-images.s-microsoft.com/image/apps.62962.14205055896346606.c235e3d6-fbce-45bb-9051-4be6c2ecba8f.28d7c3cb-0c64-40dc-9f24-53326f80a6dd',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://music.apple.com/account/settings',
        customerServicePhone: '0120-277-535',
      ),
      SubscriptionModel(
        id: '9',
        userId: 'sample_user',
        serviceName: 'Amazon Music Unlimited',
        serviceLogoUrl: 'https://m.media-amazon.com/images/I/31cqMCWdDCL.png',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://music.amazon.co.jp/settings/subscription',
        customerServicePhone: '0120-999-373',
      ),
      SubscriptionModel(
        id: '10',
        userId: 'sample_user',
        serviceName: 'YouTube Music',
        serviceLogoUrl:
            'https://yt3.googleusercontent.com/ytc/AIdro_l-6FQr2F5viYuELhfXHiUU46MqDNZkXPwUqbdZagQMt9A=s900-c-k-c0x00ffffff-no-rj',
        monthlyPrice: 1080,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://music.youtube.com/settings',
        customerServiceEmail: 'support@youtube.com',
      ),
      SubscriptionModel(
        id: '11',
        userId: 'sample_user',
        serviceName: 'LINE MUSIC',
        serviceLogoUrl:
            'https://obs.line-scdn.net/0h_TLGLoaoAHtxPihBy6h_LFl8GxUfWllvFAYOA1w9X0NbBxUoRAgdGAQ-CUsICEEvGApHHgFtVk8MWRUoTVBMFFQ5WUoZDxQlRQ0bTlQ/sp_retina',
        monthlyPrice: 980,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://music.line.me/settings',
        customerServiceEmail: 'support@linemusic.co.jp',
      ),

      // スポーツ配信サービス
      SubscriptionModel(
        id: '13',
        userId: 'sample_user',
        serviceName: 'DAZN',
        serviceLogoUrl:
            'https://yt3.googleusercontent.com/bc4e_5T4STQ-ZfxXp8tcX8xBcWkiafZJsb7v_4zu8Y1bT5dlRpjd5lvg2VVJWd66-xqGjubeHQ=s900-c-k-c0x00ffffff-no-rj',
        monthlyPrice: 4200,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.dazn.com/ja-JP/account',
        customerServiceEmail: 'help@dazn.com',
      ),
      SubscriptionModel(
        id: '14',
        userId: 'sample_user',
        serviceName: 'SPOTV NOW',
        serviceLogoUrl: 'https://m.media-amazon.com/images/I/31qabiShmjL.png',
        monthlyPrice: 1300,
        currency: 'JPY',
        startDate: DateTime.now(),
        status: SubscriptionStatus.notSubscribed,
        cancellationUrl: 'https://www.spotvnow.jp/account',
        customerServiceEmail: 'support@spotvnow.jp',
      ),
    ];
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    _setLoading(true);
    _setError('');

    try {
      // In a real app, this would call the API to cancel the subscription
      await Future.delayed(const Duration(seconds: 1));

      final index = _subscriptions.indexWhere(
        (sub) => sub.id == subscriptionId,
      );
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

  void updateSubscriptionStatus(
    String subscriptionId,
    SubscriptionStatus newStatus,
  ) {
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
        nextBillingDate:
            newStatus == SubscriptionStatus.active
                ? _subscriptions[index].nextBillingDate ??
                    DateTime.now().add(const Duration(days: 30))
                : null,
        cancelledAt:
            newStatus == SubscriptionStatus.cancelled ? DateTime.now() : null,
        status: newStatus,
        cancellationUrl: _subscriptions[index].cancellationUrl,
        customerServicePhone: _subscriptions[index].customerServicePhone,
        customerServiceEmail: _subscriptions[index].customerServiceEmail,
      );
      notifyListeners();
    }
  }
}
