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
      id: 'spotify_premium',
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
      id: 'amazon_prime_video',
      name: 'Amazon Prime Video',
      logoUrl: 'https://logo.clearbit.com/amazon.com',
      category: '動画配信',
      website: 'https://www.amazon.co.jp',
      cancellationUrl: 'https://www.amazon.co.jp/gp/video/settings',
      customerServicePhone: '0120-999-373',
      cancellationSteps: [
        'Amazonアカウントにサインインする',
        '「アカウント&リスト」から「Primeの管理」を選択する',
        '「会員情報を変更する」をクリックする',
        '「プライム会員資格を終了する」を選択する',
        '確認画面で終了を確定する',
      ],
      difficulty: 2.0,
      description: 'Amazonの動画配信サービス',
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
    ServiceProviderModel(
      id: 'u-next',
      name: 'U-NEXT',
      logoUrl: 'https://logo.clearbit.com/unext.jp',
      category: '動画配信',
      website: 'https://video.unext.jp',
      cancellationUrl: 'https://video.unext.jp/settings/subscription',
      customerServicePhone: '0570-064-996',
      cancellationSteps: [
        'U-NEXTにログインする',
        '「設定・サポート」を選択する',
        '「契約内容の確認・変更」をクリックする',
        '「解約はこちら」を選択する',
        'アンケートに回答して解約を完了する',
      ],
      difficulty: 3.0,
      description: '映画・ドラマ・アニメの動画配信サービス',
    ),
    ServiceProviderModel(
      id: 'abemaプレミアム',
      name: 'ABEMAプレミアム',
      logoUrl: 'https://logo.clearbit.com/abema.tv',
      category: '動画配信',
      website: 'https://abema.tv',
      cancellationUrl: 'https://abema.tv/account',
      customerServiceEmail: 'support@abema.tv',
      cancellationSteps: [
        'ABEMAにログインする',
        '「マイページ」を選択する',
        '「視聴プラン」をクリックする',
        '「解約する」を選択する',
        '解約理由を選択して完了する',
      ],
      difficulty: 2.0,
      description: 'テレビ&ビデオエンターテインメント',
    ),
    ServiceProviderModel(
      id: 'apple_music',
      name: 'Apple Music',
      logoUrl: 'https://logo.clearbit.com/apple.com',
      category: '音楽配信',
      website: 'https://music.apple.com',
      cancellationUrl: 'https://music.apple.com/account/settings',
      customerServicePhone: '0120-277-535',
      cancellationSteps: [
        '設定アプリを開く',
        '自分の名前をタップする',
        '「サブスクリプション」を選択する',
        'Apple Musicを選択する',
        '「サブスクリプションをキャンセル」をタップする',
      ],
      difficulty: 2.0,
      description: 'Appleの音楽ストリーミングサービス',
    ),
    ServiceProviderModel(
      id: 'amazon_music_unlimited',
      name: 'Amazon Music Unlimited',
      logoUrl: 'https://logo.clearbit.com/amazon.com',
      category: '音楽配信',
      website: 'https://music.amazon.co.jp',
      cancellationUrl: 'https://music.amazon.co.jp/settings/subscription',
      customerServicePhone: '0120-999-373',
      cancellationSteps: [
        'Amazon Music設定ページにアクセスする',
        '「Amazon Music Unlimitedの設定」を選択する',
        '「登録をキャンセルする」をクリックする',
        'キャンセル理由を選択する',
        '確認して解約を完了する',
      ],
      difficulty: 2.0,
      description: 'Amazonの音楽ストリーミングサービス',
    ),
    ServiceProviderModel(
      id: 'youtube_music',
      name: 'YouTube Music',
      logoUrl: 'https://logo.clearbit.com/youtube.com',
      category: '音楽配信',
      website: 'https://music.youtube.com',
      cancellationUrl: 'https://music.youtube.com/settings',
      customerServiceEmail: 'support@youtube.com',
      cancellationSteps: [
        'YouTube Musicにログインする',
        'プロフィールアイコンをクリックする',
        '「有料メンバーシップ」を選択する',
        '「メンバーシップを解約」をクリックする',
        '解約を確定する',
      ],
      difficulty: 1.0,
      description: 'YouTubeの音楽ストリーミングサービス',
    ),
    ServiceProviderModel(
      id: 'line_music',
      name: 'LINE MUSIC',
      logoUrl: 'https://logo.clearbit.com/line.me',
      category: '音楽配信',
      website: 'https://music.line.me',
      cancellationUrl: 'https://music.line.me/settings',
      customerServiceEmail: 'support@linemusic.co.jp',
      cancellationSteps: [
        'LINE MUSICアプリを開く',
        '「マイページ」を選択する',
        '「チケット・購入履歴」をタップする',
        '「解約する」を選択する',
        '解約を確定する',
      ],
      difficulty: 2.0,
      description: 'LINEの音楽ストリーミングサービス',
    ),
    ServiceProviderModel(
      id: 'dazn',
      name: 'DAZN',
      logoUrl: 'https://logo.clearbit.com/dazn.com',
      category: 'スポーツ配信',
      website: 'https://www.dazn.com/ja-JP',
      cancellationUrl: 'https://www.dazn.com/ja-JP/account',
      customerServiceEmail: 'help@dazn.com',
      cancellationSteps: [
        'DAZNにログインする',
        '「マイアカウント」を選択する',
        '「退会する」をクリックする',
        '退会理由を選択する',
        '「退会手続きを完了する」をクリックする',
      ],
      difficulty: 2.0,
      description: 'スポーツ専門の動画配信サービス',
    ),
    ServiceProviderModel(
      id: 'spotv_now',
      name: 'SPOTV NOW',
      logoUrl: 'https://logo.clearbit.com/spotvnow.jp',
      category: 'スポーツ配信',
      website: 'https://www.spotvnow.jp',
      cancellationUrl: 'https://www.spotvnow.jp/account',
      customerServiceEmail: 'support@spotvnow.jp',
      cancellationSteps: [
        'SPOTV NOWにログインする',
        '「マイページ」を選択する',
        '「契約情報」をクリックする',
        '「解約する」を選択する',
        '解約を確定する',
      ],
      difficulty: 2.0,
      description: 'スポーツライブ配信サービス',
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