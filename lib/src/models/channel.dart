import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/video.dart';

class Channel {
  String id;
  String title;
  String description;
  String profilePictureUrl;
  String subscriberCount;
  String videoCount;
  String uploadPlaylistId;
  List<Video> videos;

  Channel({
    this.id,
    this.title,
    this.description,
    this.profilePictureUrl,
    this.subscriberCount,
    this.videoCount,
    this.uploadPlaylistId,
    this.videos,
  });

  factory Channel.fromJson(Map<String, dynamic> map) {
    return Channel(
      id: map['id'],
      title: map['snippet']['title'],
      description: map['snippet']['description'],
      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
      subscriberCount: map['statistics']['subscriberCount'],
      videoCount: map['statistics']['videoCount'],
      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
    );
  }
}
