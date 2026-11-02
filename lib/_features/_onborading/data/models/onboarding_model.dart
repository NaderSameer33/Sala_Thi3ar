class OnboardingModel {
  final String lottiePath;
  final String title;
  final String subtitle;
  final String badge;

  const OnboardingModel({
    required this.lottiePath,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  static const List<OnboardingModel> items = [
    OnboardingModel(
      lottiePath: 'assets/lottie/onborading1.json',
      badge: 'طازجة 100%',
      title: 'خضروات وفواكه طازجة يومياً',
      subtitle:
          'نختار لك يومياً أجود أنواع الخضار والفواكه الطازجة من المزارع مباشرة لتصلك مغلفة بأعلى معايير الجودة والنظافة',
    ),
    OnboardingModel(
      lottiePath: 'assets/lottie/onborading2.json',
      badge: 'تسوق ذكي وسلس',
      title: 'تسوق كل احتياجاتك بلمسة واحدة',
      subtitle:
          'تصفح تشكيلة واسعة من الأقسام المتنوعة، أضف ما تحتاجه لسلتك وتحكم بطلبك ووسيلة دفعك بكل سهولة وأمان',
    ),
    OnboardingModel(
      lottiePath: 'assets/lottie/onborading3.json',
      badge: 'توصيل فائق السرعة',
      title: 'توصيل سريع حتى باب منزلك',
      subtitle:
          'طلبك في أيدٍ أمينة مع فريق توصيل محترف يضمن وصول طلباتك طازجة ومبردة في الموعد المحدد بكل دقة',
    ),
  ];
}
