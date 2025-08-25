class AudioItemModel {
  final String title;
  final String artist;
  final String path;
  final String thumbnail;

  const AudioItemModel({
    required this.title,
    required this.artist,
    required this.path,
    required this.thumbnail,
  });

  /// Create object from JSON
  factory AudioItemModel.fromJson(Map<String, dynamic> json) {
    return AudioItemModel(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      path: json['path'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'path': path,
      'thumbnail': thumbnail,
    };
  }

  /// Copy object with modified fields
  AudioItemModel copyWith({
    String? title,
    String? artist,
    String? path,
    String? thumbnail,
  }) {
    return AudioItemModel(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      path: path ?? this.path,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  @override
  String toString() {
    return 'AudioItemModel(title: $title, artist: $artist, path: $path, thumbnail: $thumbnail)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioItemModel &&
        other.title == title &&
        other.artist == artist &&
        other.path == path &&
        other.thumbnail == thumbnail;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        artist.hashCode ^
        path.hashCode ^
        thumbnail.hashCode;
  }
}
