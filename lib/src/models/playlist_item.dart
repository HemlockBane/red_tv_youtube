import 'dart:ui';
import 'package:red_tv_youtube/src/models/thumbnail.dart';
import 'package:red_tv_youtube/src/models/video.dart';

class PlaylistItem {
  final String id;
  final String title;
  final String description;
  final String videoId;
  final Thumbnail defaultThumbnail;
  final Thumbnail standardThumbnail;
  final Thumbnail maxresThumbnail;
  // List<Video> videos;

  PlaylistItem(
      {this.id,
      this.title,
      this.description,
      this.videoId,
      this.defaultThumbnail,
      this.standardThumbnail,
      this.maxresThumbnail});

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    final thumbnails = json['snippet']['thumbnails'] as Map;

    return PlaylistItem(
      id: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      videoId: json['snippet']['resourceId']['videoId'],
      defaultThumbnail:
          thumbnails.isNotEmpty && thumbnails.containsKey('default')
              ? Thumbnail.fromJson(thumbnails['default'])
              : Thumbnail.empty(),
      standardThumbnail:
          thumbnails.isNotEmpty && thumbnails.containsKey('standard')
              ? Thumbnail.fromJson(thumbnails['standard'])
              : Thumbnail.empty(),
      maxresThumbnail: thumbnails.isNotEmpty && thumbnails.containsKey('maxres')
          ? Thumbnail.fromJson(thumbnails['maxres'])
          : Thumbnail.empty(),
    );
  }

  @override
  String toString() {
    return 'id - $id, title - $title, '
        'description -$description, videoId - $videoId, '
        'thumbnailUrl - ${defaultThumbnail.url}';
  }
}
