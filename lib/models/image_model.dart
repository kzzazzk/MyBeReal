import 'package:cloud_firestore/cloud_firestore.dart';

class Image {
  final String id;
  final Timestamp timestamp;

  Image({required this.id, required this.timestamp});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      timestamp: json['timestamp'],
    );
  }

  @override
  String toString() {
    return 'Image{id: $id, fecha: $timestamp}';
  }
}
