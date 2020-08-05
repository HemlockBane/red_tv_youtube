import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/models/thumbnail.dart';

class Playlist {
  String id;
  String title;
  String description;
  int itemCount;
  Thumbnail standardThumbnail;
  Thumbnail defaultThumbnail;
  Thumbnail maxresThumbnail;

  List<PlaylistItem> items;
  String itemsNextPageToken;

  List<PlaylistItem> get playlistItems => items
      .where((playlistItem) => playlistItem.title != 'Private video')
      .toList();

  Playlist({
    this.id,
    this.title,
    this.description,
    this.defaultThumbnail,
    this.standardThumbnail,
    this.maxresThumbnail,
    this.itemCount,
    this.items,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final thumbnails = json['snippet']['thumbnails'] as Map;

    return Playlist(
      id: json['id'],
      title: json['snippet']['title'],
      description: json['snippet']['description'],
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
      itemCount: json['contentDetails']['itemCount'],
    );
  }

  @override
  String toString() {
    return 'id - $id, title - $title, '
        'description -$description, itemCount - $itemCount, '
        'defaultThumbnail - ${defaultThumbnail.url},'
        'standardThumbnail - ${standardThumbnail.url}, maxresThumbnail - ${defaultThumbnail.url}';
  }
}
