import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/subscription_model.dart';
import '../models/service_provider_model.dart';

class CancellationGuideScreen extends StatelessWidget {
  final SubscriptionModel subscription;

  const CancellationGuideScreen({Key? key, required this.subscription})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ServiceProviders.getServiceById(
      subscription.serviceName
          .toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('+', '_plus'),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${subscription.serviceName} 解約ガイド',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, serviceProvider),
            _buildDifficultyIndicator(serviceProvider),
            _buildStepsSection(serviceProvider),
            _buildContactSection(context, serviceProvider),
            _buildActionSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ServiceProviderModel? serviceProvider,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                subscription.serviceName.substring(0, 1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subscription.serviceName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          if (serviceProvider != null) ...[
            Text(
              serviceProvider.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDifficultyIndicator(ServiceProviderModel? serviceProvider) {
    if (serviceProvider == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.speed,
            color: _getDifficultyColor(serviceProvider.difficulty),
          ),
          const SizedBox(width: 12),
          Text(
            '解約の難易度: ${serviceProvider.difficultyText}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          ...List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 16,
              color:
                  index < serviceProvider.difficulty
                      ? _getDifficultyColor(serviceProvider.difficulty)
                      : Colors.grey[300],
            );
          }),
        ],
      ),
    );
  }

  Color _getDifficultyColor(double difficulty) {
    if (difficulty <= 2) return Colors.green;
    if (difficulty <= 3) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStepsSection(ServiceProviderModel? serviceProvider) {
    final steps =
        serviceProvider?.cancellationSteps ??
        [
          'サービスのウェブサイトにアクセス',
          'アカウント設定を開く',
          'サブスクリプション管理を選択',
          'キャンセルオプションを見つける',
          'キャンセル手続きを完了する',
        ];

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.list_alt, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              const Text(
                '解約手順',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildStepItem(index + 1, step);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepNumber, String stepText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                stepText,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context,
    ServiceProviderModel? serviceProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.support_agent, color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Text(
                'サポート連絡先',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (subscription.customerServicePhone != null) ...[
            _buildContactItem(
              icon: Icons.phone,
              title: '電話サポート',
              subtitle: subscription.customerServicePhone!,
              onTap: () => _launchPhone(subscription.customerServicePhone!),
            ),
            const SizedBox(height: 12),
          ],
          if (subscription.customerServiceEmail != null) ...[
            _buildContactItem(
              icon: Icons.email,
              title: 'メールサポート',
              subtitle: subscription.customerServiceEmail!,
              onTap: () => _launchEmail(subscription.customerServiceEmail!),
            ),
          ],
          if (subscription.customerServicePhone == null &&
              subscription.customerServiceEmail == null) ...[
            const Text(
              'カスタマーサポート情報は利用できません。\n公式ウェブサイトでサポート情報をご確認ください。',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _launchCancellationUrl(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('公式サイトで解約手続き'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _showHelpDialog(context),
              icon: const Icon(Icons.help_outline),
              label: const Text('解約できない場合'),
            ),
          ),
        ],
      ),
    );
  }

  void _launchCancellationUrl(BuildContext context) async {
    if (subscription.cancellationUrl != null) {
      final uri = Uri.parse(subscription.cancellationUrl!);
      print('Launching URL: $uri');
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

  void _launchPhone(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('解約でお困りの場合'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('以下の方法をお試しください：'),
              SizedBox(height: 16),
              Text('1. カスタマーサポートに直接連絡'),
              Text('2. チャットサポートを利用'),
              Text('3. 解約ページを別のブラウザで試す'),
              Text('4. アプリではなくWebサイトで試す'),
              Text('5. クレジットカード会社に相談'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
