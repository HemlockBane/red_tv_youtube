import 'package:red_tv_youtube/src/models/thumbnail.dart';

class SearchItem {
  String videoId;
  String title;
  String description;
  String channelId;
  Thumbnail defaultThumbnail;
  Thumbnail mediumThumbnail;

  SearchItem({
    this.videoId,
    this.title,
    this.description,
    this.channelId,
    this.defaultThumbnail,
    this.mediumThumbnail,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    final thumbnails = json['snippet']['thumbnails'] as Map;

    return SearchItem(
      videoId: json['id']['videoId'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
      channelId: json['snippet']['channelId'],
      defaultThumbnail:
          thumbnails.isNotEmpty && thumbnails.containsKey('default')
              ? Thumbnail.fromJson(thumbnails['default'])
              : Thumbnail.empty(),
      mediumThumbnail: thumbnails.isNotEmpty && thumbnails.containsKey('medium')
              ? Thumbnail.fromJson(thumbnails['medium'])
              : Thumbnail.empty(),
    );
  }
}
