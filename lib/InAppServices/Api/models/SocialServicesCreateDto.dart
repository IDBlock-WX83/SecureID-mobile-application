class SocialServiceCreate {
  final String title;
  final String imageUrl;
  final String location;
  final String schedule;
  final DateTime expirationDate;
  final String socialServicesType;

  SocialServiceCreate({
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.schedule,
    required this.expirationDate,
    required this.socialServicesType,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'location': location,
      'schedule': schedule,
      'expirationDate': expirationDate.toIso8601String(),
      'socialServicesType': socialServicesType,
    };
  }
}
