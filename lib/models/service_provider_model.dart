class ServiceProviderModel {
  final String id;
  final String name;
  final String logoUrl;
  final String category;
  final String website;
  final String cancellationUrl;
  final String? customerServicePhone;
  final String? customerServiceEmail;
  final List<String> cancellationSteps;
  final double difficulty; // 1-5 scale (1 = very easy, 5 = very hard)
  final String description;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
    required this.website,
    required this.cancellationUrl,
    this.customerServicePhone,
    this.customerServiceEmail,
    required this.cancellationSteps,
    required this.difficulty,
    required this.description,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      category: json['category'],
      website: json['website'],
      cancellationUrl: json['cancellationUrl'],
      customerServicePhone: json['customerServicePhone'],
      customerServiceEmail: json['customerServiceEmail'],
      cancellationSteps: List<String>.from(json['cancellationSteps']),
      difficulty: json['difficulty'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'category': category,
      'website': website,
      'cancellationUrl': cancellationUrl,
      'customerServicePhone': customerServicePhone,
      'customerServiceEmail': customerServiceEmail,
      'cancellationSteps': cancellationSteps,
      'difficulty': difficulty,
      'description': description,
    };
  }

  String get difficultyText {
    switch (difficulty.round()) {
      case 1:
        return '非常に簡単';
      case 2:
        return '簡単';
      case 3:
        return '普通';
      case 4:
        return '難しい';
      case 5:
        return '非常に難しい';
      default:
        return '不明';
    }
  }
}

class ServiceProviders {
  static final List<ServiceProviderModel> popularServices = [
    ServiceProviderModel(
      id: 'netflix',
      name: 'Netflix',
      logoUrl: 'https://logo.clearbit.com/netflix.com',
      category: '動画配信',
      website: 'https://www.netflix.com',
      cancellationUrl: 'https://www.netflix.com/cancelplan',
      customerServicePhone: '0120-996-012',
      cancellationSteps: [
        'Netflix にサインインする',
        'アカウント設定に移動する',
        '「メンバーシップの詳細」を選択する',
        '「メンバーシップのキャンセル」をクリックする',
        'キャンセルの確認を行う',
      ],
      difficulty: 2.0,
      description: '世界最大級の動画配信サービス',
    ),
    ServiceProviderModel(
      id: 'spotify',
      name: 'Spotify Premium',
      logoUrl: 'https://logo.clearbit.com/spotify.com',
      category: '音楽配信',
      website: 'https://www.spotify.com',
      cancellationUrl: 'https://www.spotify.com/jp/account/subscription/',
      customerServiceEmail: 'support@spotify.com',
      cancellationSteps: [
        'Spotify アカウントページにログインする',
        '「プランを変更する」を選択する',
        '「Spotify Free」を選択する',
        'プラン変更を確認する',
      ],
      difficulty: 1.0,
      description: '音楽ストリーミングサービス',
    ),
    ServiceProviderModel(
      id: 'adobe_cc',
      name: 'Adobe Creative Cloud',
      logoUrl: 'https://logo.clearbit.com/adobe.com',
      category: 'クリエイティブツール',
      website: 'https://www.adobe.com',
      cancellationUrl: 'https://account.adobe.com/',
      customerServicePhone: '03-5350-9204',
      cancellationSteps: [
        'Adobe アカウントにサインインする',
        '「プランと製品」に移動する',
        'キャンセルしたいプランの「プランを管理」をクリックする',
        '「プランをキャンセル」を選択する',
        'キャンセル理由を選択して確認する',
      ],
      difficulty: 3.0,
      description: 'デザイン・動画編集ソフトウェアスイート',
    ),
    ServiceProviderModel(
      id: 'amazon_prime',
      name: 'Amazon Prime',
      logoUrl: 'https://logo.clearbit.com/amazon.com',
      category: 'ショッピング・配送',
      website: 'https://www.amazon.co.jp',
      cancellationUrl: 'https://www.amazon.co.jp/gp/help/customer/display.html',
      customerServicePhone: '0120-999-373',
      cancellationSteps: [
        'Amazonアカウントにサインインする',
        '「アカウント&リスト」から「Primeの管理」を選択する',
        '「会員情報を変更する」をクリックする',
        '「プライム会員資格を終了する」を選択する',
        '確認画面で終了を確定する',
      ],
      difficulty: 2.0,
      description: 'オンラインショッピング・配送サービス',
    ),
    ServiceProviderModel(
      id: 'youtube_premium',
      name: 'YouTube Premium',
      logoUrl: 'https://logo.clearbit.com/youtube.com',
      category: '動画配信',
      website: 'https://www.youtube.com',
      cancellationUrl: 'https://www.youtube.com/paid_memberships',
      customerServiceEmail: 'support@youtube.com',
      cancellationSteps: [
        'YouTube にサインインする',
        'プロフィール画像をクリックする',
        '「有料メンバーシップ」を選択する',
        'YouTube Premium の「管理」をクリックする',
        '「解約」を選択して確認する',
      ],
      difficulty: 1.0,
      description: '広告なしのYouTube体験',
    ),
    ServiceProviderModel(
      id: 'disney_plus',
      name: 'Disney+',
      logoUrl: 'https://logo.clearbit.com/disneyplus.com',
      category: '動画配信',
      website: 'https://www.disneyplus.com',
      cancellationUrl: 'https://www.disneyplus.com/ja-jp/account',
      cancellationSteps: [
        'Disney+ アカウントにログインする',
        '「サブスクリプション」を選択する',
        '「サブスクリプションをキャンセル」をクリックする',
        'キャンセル理由を選択する',
        'キャンセルを確定する',
      ],
      difficulty: 2.0,
      description: 'ディズニーコンテンツの動画配信サービス',
    ),
    ServiceProviderModel(
      id: 'hulu',
      name: 'Hulu',
      logoUrl: 'https://logo.clearbit.com/hulu.com',
      category: '動画配信',
      website: 'https://www.hulu.jp',
      cancellationUrl: 'https://www.hulu.jp/account',
      cancellationSteps: [
        'Hulu アカウントページにアクセスする',
        '「契約・お支払い情報」を選択する',
        '「解約する」をクリックする',
        'アンケートに回答する',
        '解約を完了する',
      ],
      difficulty: 2.0,
      description: '海外ドラマ・映画配信サービス',
    ),
  ];

  static ServiceProviderModel? getServiceById(String id) {
    try {
      return popularServices.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ServiceProviderModel> getServicesByCategory(String category) {
    return popularServices.where((service) => service.category == category).toList();
  }

  static List<String> getAllCategories() {
    return popularServices.map((service) => service.category).toSet().toList();
  }
}