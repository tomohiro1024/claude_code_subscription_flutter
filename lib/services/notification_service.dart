import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> scheduleSubscriptionReminders(List<SubscriptionModel> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final reminderDays = prefs.getInt('reminder_days') ?? 3;

    if (!notificationsEnabled) return;

    for (final subscription in subscriptions) {
      if (subscription.isActive && subscription.nextBillingDate != null) {
        final reminderDate = subscription.nextBillingDate!.subtract(
          Duration(days: reminderDays),
        );

        if (reminderDate.isAfter(DateTime.now())) {
          // In a real app, you would use a proper notification plugin
          // like flutter_local_notifications
          await _scheduleNotification(
            id: subscription.id.hashCode,
            title: '${subscription.serviceName}の請求日が近づいています',
            body: '${subscription.nextBillingDate!.day}日に¥${subscription.monthlyPrice.toInt()}が請求されます',
            scheduledDate: reminderDate,
          );
        }
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // This is a placeholder implementation
    // In a real app, you would use flutter_local_notifications
    debugPrint('Notification scheduled: $title at $scheduledDate');
  }

  Future<void> cancelAllNotifications() async {
    // Cancel all scheduled notifications
    debugPrint('All notifications cancelled');
  }

  Future<void> sendEmailReminder(String email, List<SubscriptionModel> upcomingBillings) async {
    // In a real app, this would integrate with an email service
    debugPrint('Email reminder sent to $email for ${upcomingBillings.length} subscriptions');
  }

  List<SubscriptionModel> getUpcomingBillings(
    List<SubscriptionModel> subscriptions, 
    int daysAhead
  ) {
    final now = DateTime.now();
    final cutoffDate = now.add(Duration(days: daysAhead));

    return subscriptions.where((subscription) {
      if (!subscription.isActive || subscription.nextBillingDate == null) {
        return false;
      }

      final billingDate = subscription.nextBillingDate!;
      return billingDate.isAfter(now) && billingDate.isBefore(cutoffDate);
    }).toList();
  }

  Future<void> checkAndSendReminders(List<SubscriptionModel> subscriptions) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    final emailNotifications = prefs.getBool('email_notifications') ?? true;
    final reminderDays = prefs.getInt('reminder_days') ?? 3;

    if (!notificationsEnabled) return;

    final upcomingBillings = getUpcomingBillings(subscriptions, reminderDays);

    if (upcomingBillings.isEmpty) return;

    // Schedule local notifications
    await scheduleSubscriptionReminders(upcomingBillings);

    // Send email reminders if enabled
    if (emailNotifications) {
      final userEmail = prefs.getString('user_email');
      if (userEmail != null) {
        await sendEmailReminder(userEmail, upcomingBillings);
      }
    }
  }

  String formatCurrency(double amount, String currency) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'JPY':
      default:
        return '¥${amount.toInt()}';
    }
  }

  Map<String, dynamic> getNotificationStats(List<SubscriptionModel> subscriptions) {
    final activeSubscriptions = subscriptions.where((s) => s.isActive).toList();
    final upcomingIn3Days = getUpcomingBillings(subscriptions, 3);
    final upcomingIn7Days = getUpcomingBillings(subscriptions, 7);
    
    return {
      'totalActive': activeSubscriptions.length,
      'upcomingIn3Days': upcomingIn3Days.length,
      'upcomingIn7Days': upcomingIn7Days.length,
      'nextBilling': _getNextBillingDate(activeSubscriptions),
      'monthlyTotal': activeSubscriptions.fold<double>(
        0, (sum, s) => sum + s.monthlyPrice,
      ),
    };
  }

  DateTime? _getNextBillingDate(List<SubscriptionModel> subscriptions) {
    final upcomingDates = subscriptions
        .where((s) => s.nextBillingDate != null)
        .map((s) => s.nextBillingDate!)
        .where((date) => date.isAfter(DateTime.now()))
        .toList();

    if (upcomingDates.isEmpty) return null;
    
    upcomingDates.sort();
    return upcomingDates.first;
  }
}