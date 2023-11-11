import 'dart:typed_data';

class ImageModel {
  final int? id;
  final int tracerId; // Reference ID
  final Uint8List? imageBlob;
  String? imagePath;
  String? name;

  ImageModel({
    this.id,
    required this.tracerId,
    this.imageBlob,
    this.imagePath,
    this.name
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracerId': tracerId,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'name': name
    };
  }

  static ImageModel fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      tracerId: map['tracerId'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      name: map['name']
    );
  }
}