enum SubscriptionStatus {
  active,
  cancelled,
  notSubscribed,
}

class SubscriptionModel {
  final String id;
  final String userId;
  final String serviceName;
  final String serviceLogoUrl;
  final double monthlyPrice;
  final String currency;
  final DateTime startDate;
  final DateTime? nextBillingDate;
  final DateTime? cancelledAt;
  final SubscriptionStatus status;
  final String? cancellationUrl;
  final String? customerServicePhone;
  final String? customerServiceEmail;

  SubscriptionModel({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.serviceLogoUrl,
    required this.monthlyPrice,
    required this.currency,
    required this.startDate,
    this.nextBillingDate,
    this.cancelledAt,
    required this.status,
    this.cancellationUrl,
    this.customerServicePhone,
    this.customerServiceEmail,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      userId: json['userId'],
      serviceName: json['serviceName'],
      serviceLogoUrl: json['serviceLogoUrl'],
      monthlyPrice: json['monthlyPrice'].toDouble(),
      currency: json['currency'],
      startDate: DateTime.parse(json['startDate']),
      nextBillingDate: json['nextBillingDate'] != null 
          ? DateTime.parse(json['nextBillingDate']) 
          : null,
      cancelledAt: json['cancelledAt'] != null 
          ? DateTime.parse(json['cancelledAt']) 
          : null,
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status']
      ),
      cancellationUrl: json['cancellationUrl'],
      customerServicePhone: json['customerServicePhone'],
      customerServiceEmail: json['customerServiceEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceName': serviceName,
      'serviceLogoUrl': serviceLogoUrl,
      'monthlyPrice': monthlyPrice,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'status': status.toString().split('.').last,
      'cancellationUrl': cancellationUrl,
      'customerServicePhone': customerServicePhone,
      'customerServiceEmail': customerServiceEmail,
    };
  }

  bool get isActive => status == SubscriptionStatus.active;
  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get isNotSubscribed => status == SubscriptionStatus.notSubscribed;
  
  int get daysUntilBilling {
    if (nextBillingDate == null) return 0;
    return nextBillingDate!.difference(DateTime.now()).inDays;
  }
}