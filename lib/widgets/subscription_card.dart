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
  late SubscriptionStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.subscription.status;
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
                          Row(
                            children: [
                              Text(
                                '¥${_currencyFormatter.format(widget.subscription.monthlyPrice)} / 月額',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (widget.subscription.serviceName
                                  .toLowerCase()
                                  .contains('netflix'))
                                GestureDetector(
                                  onTap: () => _showNetflixPlansDialog(context),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 18,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (widget.subscription.yearPrice != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              '¥${_currencyFormatter.format(widget.subscription.yearPrice!)} / 年額',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Status Badge with Dropdown
                    PopupMenuButton<SubscriptionStatus>(
                      onSelected: (SubscriptionStatus newStatus) {
                        setState(() {
                          _currentStatus = newStatus;
                        });
                        context
                            .read<SubscriptionProvider>()
                            .updateSubscriptionStatus(
                              widget.subscription.id,
                              newStatus,
                            );
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            PopupMenuItem(
                              value: SubscriptionStatus.active,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('契約中'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: SubscriptionStatus.cancelled,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('解約済み'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: SubscriptionStatus.notSubscribed,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('未契約'),
                                ],
                              ),
                            ),
                          ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            _currentStatus,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getStatusText(_currentStatus),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(_currentStatus),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 16,
                              color: _getStatusColor(_currentStatus),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          if (_currentStatus == SubscriptionStatus.active)
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
      case SubscriptionStatus.notSubscribed:
        return Colors.grey;
    }
  }

  String _getStatusText(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return '契約中';
      case SubscriptionStatus.cancelled:
        return '解約済み';
      case SubscriptionStatus.notSubscribed:
        return '未契約';
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

  void _showNetflixPlansDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Netflixプラン一覧',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanRow('広告つきスタンダード', '¥890'),
              const SizedBox(height: 12),
              _buildPlanRow('スタンダード', '¥1,590'),
              const SizedBox(height: 12),
              _buildPlanRow('プレミアム', '¥2,290'),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlanRow(String planName, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(planName, style: const TextStyle(fontSize: 14)),
        Text(
          price,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
