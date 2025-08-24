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
      SubscriptionModel(
        id: '1',
        userId: 'sample_user',
        serviceName: 'Netflix',
        serviceLogoUrl: 'https://logo.clearbit.com/netflix.com',
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
        serviceName: 'Spotify Premium',
        serviceLogoUrl: 'https://logo.clearbit.com/spotify.com',
        monthlyPrice: 980,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 180)),
        nextBillingDate: DateTime.now().add(const Duration(days: 12)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.spotify.com/jp/account/subscription/',
        customerServiceEmail: 'support@spotify.com',
      ),
      SubscriptionModel(
        id: '3',
        userId: 'sample_user',
        serviceName: 'Adobe Creative Cloud',
        serviceLogoUrl: 'https://logo.clearbit.com/adobe.com',
        monthlyPrice: 2480,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        nextBillingDate: DateTime.now().add(const Duration(days: 25)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://account.adobe.com/',
        customerServicePhone: '03-5350-9204',
      ),
      SubscriptionModel(
        id: '4',
        userId: 'sample_user',
        serviceName: 'Amazon Prime',
        serviceLogoUrl: 'https://logo.clearbit.com/amazon.com',
        monthlyPrice: 500,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 200)),
        nextBillingDate: DateTime.now().add(const Duration(days: 20)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.amazon.co.jp/gp/help/customer/display.html',
        customerServicePhone: '0120-999-373',
      ),
      SubscriptionModel(
        id: '5',
        userId: 'sample_user',
        serviceName: 'YouTube Premium',
        serviceLogoUrl: 'https://logo.clearbit.com/youtube.com',
        monthlyPrice: 1180,
        currency: 'JPY',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        cancelledAt: DateTime.now().subtract(const Duration(days: 10)),
        status: SubscriptionStatus.active,
        cancellationUrl: 'https://www.youtube.com/paid_memberships',
        customerServiceEmail: 'support@youtube.com',
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