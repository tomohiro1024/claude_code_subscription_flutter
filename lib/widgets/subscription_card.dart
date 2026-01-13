import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subscription_model.dart';
import '../providers/subscription_provider.dart';
import '../screens/cancellation_guide_screen.dart';

class SubscriptionCard extends StatefulWidget {
  final SubscriptionModel subscription;

  SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  final NumberFormat _currencyFormatter = NumberFormat('#,###');
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.subscription.status == SubscriptionStatus.active;
  }

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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.subscription.serviceLogoUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                widget.subscription.serviceName.substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          },
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
                            widget.subscription.serviceName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '¥${_currencyFormatter.format(widget.subscription.monthlyPrice)} / 月',
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
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              _isActive
                                  ? SubscriptionStatus.active
                                  : SubscriptionStatus.cancelled,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(
                              _isActive
                                  ? SubscriptionStatus.active
                                  : SubscriptionStatus.cancelled,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(
                                _isActive
                                    ? SubscriptionStatus.active
                                    : SubscriptionStatus.cancelled,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Transform.scale(
                              scaleX: 0.9,
                              scaleY: 0.8,
                              child: Switch(
                                value: _isActive,
                                onChanged: (bool value) {
                                  setState(() {
                                    _isActive = value;
                                  });
                                  final newStatus =
                                      value
                                          ? SubscriptionStatus.active
                                          : SubscriptionStatus.cancelled;
                                  context
                                      .read<SubscriptionProvider>()
                                      .updateSubscriptionStatus(
                                        widget.subscription.id,
                                        newStatus,
                                      );
                                },
                                activeColor: Colors.green,
                                inactiveThumbColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          if (widget.subscription.isActive)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _navigateToCancellationGuide(context),
                      icon: const Icon(Icons.info, size: 18),
                      label: const Text('解約方法'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 24, color: Colors.grey.shade200),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _launchCancellationUrl(context),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('解約サイトへ'),
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
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return '契約中';
      case SubscriptionStatus.cancelled:
        return '解約済み';
    }
  }

  void _navigateToCancellationGuide(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                CancellationGuideScreen(subscription: widget.subscription),
      ),
    );
  }

  void _launchCancellationUrl(BuildContext context) async {
    if (widget.subscription.cancellationUrl != null) {
      final uri = Uri.parse(widget.subscription.cancellationUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('URLを開けませんでした')));
        }
      }
    }
  }
}
