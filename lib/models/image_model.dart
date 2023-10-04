import 'package:cloud_firestore/cloud_firestore.dart';

class Foto {
  final String id;
  final Timestamp timestamp;

  Foto({required this.id, required this.timestamp});

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['id'],
      timestamp: json['timestamp'],
    );
  }

  @override
  String toString() {
    return 'Image{id: $id, fecha: $timestamp}';
  }
}
