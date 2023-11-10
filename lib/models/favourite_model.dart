class FavouriteModel {
  final int? id;
  final int tracerId;

  FavouriteModel({
    this.id,
    required this.tracerId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracerId': tracerId
    };
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      id: map['id'],
      tracerId: map['tracerId']
    );
  }
}
