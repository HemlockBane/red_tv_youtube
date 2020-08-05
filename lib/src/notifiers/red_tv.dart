import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/channel.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class RedTVChannelNotifier extends ChangeNotifier {
  static RedTVChannelNotifier of(BuildContext context) =>
      Provider.of<RedTVChannelNotifier>(context, listen: false);

  final _api = APIService.instance;
  final _redTVChannelId = "UCmaJwjJJkzMttK8L79g_8zA";
  String _playlistNextPageToken = '';
  int totalplaylistCount = 0;
  Channel channel;

  List<Playlist> playlists = [];

  Future<void> getChannelDetails() async {
    try {
      channel = await _api.getChannel(channelId: _redTVChannelId);
      final response = await getPlaylists();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Playlist>> getPlaylists({bool isLoadMore = false}) async {
    try {
      final response = await _api.getPlaylists(channelId: _redTVChannelId);
      totalplaylistCount = response.totalResults;
      _playlistNextPageToken = response.nextPageToken;
      playlists.addAll(response.items);

      if (!isLoadMore) {
        notifyListeners();
      }

      return response.items;
    } catch (e) {
      rethrow;
    }
  }

  getPlaylistItems({String playlistId}) async{
    // Pass playlist id
    // Use playlist id to load play list items
    // Loop through list and find playlist with corresponding id
    // Add playlistitems to playlist
    // Notify listeners
    
  }
}
