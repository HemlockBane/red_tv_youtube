import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class ExclusivesPlaylistNotifier extends ChangeNotifier {
  static ExclusivesPlaylistNotifier of(BuildContext context) =>
      Provider.of<ExclusivesPlaylistNotifier>(context, listen: false);

  final playlistId = 'PLLljTmmXGbu3CBBGGWcp4snEWKvf5kJrH';
  String _nextItemsToken = '';

  Playlist playlist;

  Future<Playlist> getPlaylist() async {
    try {
      final api = APIService.instance;
      playlist = await api.getPlaylist(playlistId: playlistId);
      final itemResponse = await api.getPlaylistItems(playlistId: playlistId);
      _nextItemsToken = itemResponse.nextPageToken;
      playlist.items = itemResponse.items;
      notifyListeners();
      return playlist;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPlaylistItems() async {
    // Set playlist items and notify listeners
    try {
      final api = APIService.instance;
      final itemResponse = await api.getPlaylistItems(
          playlistId: playlistId, nextPageToken: _nextItemsToken);
      _nextItemsToken = itemResponse.nextPageToken;
      playlist.items.addAll(itemResponse.items);
      notifyListeners();
      // TODO: Fix load more playlist content on scroll end reached
    } catch (e) {}
  }
}
