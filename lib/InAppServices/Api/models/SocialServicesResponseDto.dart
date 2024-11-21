class SocialServiceResponse {
  final int id;
  final String title;
  final String imageUrl;
  final String location;
  final String schedule;
  final DateTime expirationDate;
  final String socialServicesType;

  SocialServiceResponse({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.schedule,
    required this.expirationDate,
    required this.socialServicesType,
  });

  factory SocialServiceResponse.fromJson(Map<String, dynamic> json) {
    return SocialServiceResponse(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      schedule: json['schedule'],
      expirationDate: DateTime.parse(json['expirationDate']),
      socialServicesType: json['socialServicesType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'location': location,
      'schedule': schedule,
      'expirationDate': expirationDate.toIso8601String(),
      'socialServicesType': socialServicesType,
    };
  }
}
