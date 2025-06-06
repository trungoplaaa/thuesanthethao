class EventModel {
  final int id;
  final int infFieldId;
  final String? imageUrl;
  final String name;
  final String? description;
  final String? time;

  EventModel({
    required this.id,
    required this.infFieldId,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.time,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      infFieldId: json['inf_field_id'],
      imageUrl: json['image_url'],
      name: json['name_event'],
      description: json['description'],
      time: json['time_event'],
    );
  }
}
