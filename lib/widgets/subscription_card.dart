import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subscription_model.dart';
import '../providers/subscription_provider.dart';
import '../screens/cancellation_guide_screen.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final NumberFormat _currencyFormatter = NumberFormat('#,###');

  SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Service Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          subscription.serviceName.substring(0, 1),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Service Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.serviceName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '¥${_currencyFormatter.format(subscription.monthlyPrice)} / 月',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(subscription.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(subscription.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(subscription.status),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Billing Info
                if (subscription.isActive && subscription.nextBillingDate != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '次回請求: ${DateFormat('MM月dd日').format(subscription.nextBillingDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${subscription.daysUntilBilling}日後',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                
                if (subscription.isCancelled && subscription.cancelledAt != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cancel, size: 16, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '解約日: ${DateFormat('MM月dd日').format(subscription.cancelledAt!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // Action Buttons
          if (subscription.isActive)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _navigateToCancellationGuide(context),
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      label: const Text('解約する'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _launchCancellationUrl(context),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('サイトで管理'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return Colors.green;
      case SubscriptionStatus.cancelled:
        return Colors.red;
      case SubscriptionStatus.expired:
        return Colors.orange;
      case SubscriptionStatus.paused:
        return Colors.blue;
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'アクティブ';
      case SubscriptionStatus.cancelled:
        return '解約済み';
      case SubscriptionStatus.expired:
        return '期限切れ';
      case SubscriptionStatus.paused:
        return '一時停止';
    }
  }

  void _showCancellationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${subscription.serviceName}を解約'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${subscription.serviceName}のサブスクリプションを解約しますか？'),
              const SizedBox(height: 16),
              const Text('解約方法:'),
              const SizedBox(height: 8),
              if (subscription.cancellationUrl != null) ...[
                Row(
                  children: [
                    Icon(Icons.web, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('オンラインで解約')),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (subscription.customerServicePhone != null) ...[
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(subscription.customerServicePhone!)),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (subscription.customerServiceEmail != null) ...[
                Row(
                  children: [
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(child: Text(subscription.customerServiceEmail!)),
                  ],
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () => _cancelSubscription(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('解約する'),
            ),
          ],
        );
      },
    );
  }

  void _cancelSubscription(BuildContext context) async {
    Navigator.pop(context);
    
    final subscriptionProvider = context.read<SubscriptionProvider>();
    await subscriptionProvider.cancelSubscription(subscription.id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${subscription.serviceName}が解約されました'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToCancellationGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CancellationGuideScreen(subscription: subscription),
      ),
    );
  }

  void _launchCancellationUrl(BuildContext context) async {
    if (subscription.cancellationUrl != null) {
      final uri = Uri.parse(subscription.cancellationUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URLを開けませんでした')),
          );
        }
      }
    }
  }
}