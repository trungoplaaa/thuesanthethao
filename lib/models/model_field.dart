class Field {
  final int id;
  final String name;
  final String address;
  final String latitude;
  final String longitude;
  final String contactPhone;
  final String images;
  final String sportType;
  final bool status;
  final String timeaction;
  final List<dynamic> sportsFields;
  final List<dynamic> services;
  final List<dynamic> events;
  final List<dynamic> reviews;
  final List<dynamic> imagesRelation;

  Field({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactPhone,
    required this.images,
    required this.sportType,
    required this.status,
    required this.timeaction,
    required this.sportsFields,
    required this.services,
    required this.events,
    required this.reviews,
    required this.imagesRelation,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      contactPhone: json['contact_phone'] as String,
      images: json['images'] as String,
      sportType: json['sport_type'] as String,
      status: json['status'] as bool,
      timeaction: json['timeaction'] as String,
      sportsFields: json['sportsFields'] as List<dynamic>,
      services: json['services'] as List<dynamic>,
      events: json['events'] as List<dynamic>,
      reviews: json['reviews'] as List<dynamic>,
      imagesRelation: json['imagesRelation'] as List<dynamic>,
    );
  }
}