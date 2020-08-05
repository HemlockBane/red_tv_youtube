import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class PopularNowNotifier extends ChangeNotifier {
  static PopularNowNotifier of(BuildContext context) =>
      Provider.of<PopularNowNotifier>(context, listen: false);

  Future getPopularNowVideos() async {
     try {
      final api = APIService.instance;
      playlist = await api.getMostPopularVideos(playlistId: playlistId);
      final itemResponse = await api.getPlaylistItems(
          playlistId: playlistId, nextPageToken: _nextItemsToken);
      _nextItemsToken = itemResponse.nextPageToken;
      playlist.items = itemResponse.items;
      notifyListeners();
      return playlist;
    } catch (e) {
      rethrow;
    }
  }
}
