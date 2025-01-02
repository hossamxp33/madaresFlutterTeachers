import 'package:hive/hive.dart';

part 'customNotification.g.dart'; // Build-generated file

@HiveType(typeId: 0) // Assign a unique type ID for this class
class CustomNotification extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type;

  @HiveField(3)
  String message;

  @HiveField(4)
  int? sendTo;

  @HiveField(5)
  String? image;

  @HiveField(6)
  DateTime date;

  @HiveField(7)
  String? createdAt;

  @HiveField(8)
  String? updatedAt;

  @HiveField(9)
  String? deletedAt;

  @HiveField(10)
  String? typeId;

  CustomNotification({
    required this.id,
    required this.title,
    required this.type,
    required this.message,
    this.sendTo,
    this.image,
    required this.date,
    this.createdAt,
    this.updatedAt,
    this.typeId,
    this.deletedAt,
  });

  // JSON Factory
  factory CustomNotification.fromJson(Map<String, dynamic> json) {
    return CustomNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      type: json['type'] ?? "custom",
      message: json['message'] ?? "",
      sendTo: json['send_to'],
      image: json['image'],
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      typeId: json['type_id'],
    );
  }

  // JSON Converter
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'message': message,
      'send_to': sendTo,
      'image': image,
      'date': date.toIso8601String(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'type_id': typeId,
    };
  }
}
