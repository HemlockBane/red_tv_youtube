import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/channel.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class RedTVChannelNotifier extends ChangeNotifier {
  static RedTVChannelNotifier of(BuildContext context) =>
      Provider.of<RedTVChannelNotifier>(context, listen: false);

  final _api = APIService.instance;
  final _redTVChannelId = "UCmaJwjJJkzMttK8L79g_8zA";

  /// Token to load the next batch of playlists in the channel
  /// List responses are usually paginated
  String _playlistNextPageToken = '';

  /// Total number of playlists in the Red TV channel
  int totalplaylistCount = 0;

  ///The Red TV channel
  Channel channel;


/// Playlists in the Red TV channel
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

  Future<void> getPlaylistItems(
      {Playlist playlist, bool isInitialFetch = true}) async {
    // Pass playlist id
    // Use playlist id to load play list items
    // Loop through list and find playlist with corresponding id
    // Add playlistitems to playlist
    // Notify listeners // If fetching for the first time, aand playlist is not empty, don't fetch
    // if fetching for first time and playlist is empty, fetch
    // If fetching for subsequent time fetch

    // If fetching for the first time, aand playlistitems is not empty, don't fetch
    // if fetching for first time and playlistitems is empty, fetch
    // If fetching for subsequent time fetch

    final index = playlists.indexOf(playlist);
    final items = playlists[index].filteredItems;

    if (isInitialFetch && items.isNotEmpty) return;

    try {
      final response = await _api.getPlaylistItems(
          playlistId: playlist.id, nextPageToken: playlist.itemsNextPageToken);
      final nextPageToken = response.nextPageToken;
      final playlistItems = response.items;

      // print('red_tv: items - $playlistItems');
      playlists[index].itemsNextPageToken = nextPageToken;
      playlists[index].items.addAll(playlistItems);
      print('');
      notifyListeners();
    } catch (e) {
      print('red_tv: $e');
      rethrow;
    }
  }
}
