class AudioItemModel {
  final String title;
  final String artist;
  final int? duration;
  final String path;
  final String? image;

  const AudioItemModel({
    required this.title,
    required this.artist,
    required this.duration,
    required this.path,
    required this.image,
  });

  String get durationFormatted {
    if (duration == null) return "0s";

    final totalSeconds = duration! ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${seconds}s";
    }
  }

  /// Create object from JSON
  factory AudioItemModel.fromJson(Map<String, dynamic> json) {
    return AudioItemModel(
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      duration: json['duration'],
      path: json['path'] ?? '',
      image: json['image'],
    );
  }

  /// Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'duration': duration,
      'path': path,
      'image': image,
    };
  }
}
