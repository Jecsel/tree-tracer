import 'dart:typed_data';

class RootModel {
  final int? id;
  final int tracerId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  final String name;
  final String description;

  RootModel({
    this.id,
    required this.tracerId,
    this.imageBlob,
    this.imagePath,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracerId': tracerId,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'name': name,
      'description': description,
    };
  }

  static RootModel fromMap(Map<String, dynamic> map) {
    return RootModel(
      id: map['id'],
      tracerId: map['tracerId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name'],
      description: map['description'],
    );
  }
}