import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/search_item.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class PopularNowNotifier extends ChangeNotifier {
  static PopularNowNotifier of(BuildContext context) =>
      Provider.of<PopularNowNotifier>(context, listen: false);

  String _nextItemsToken = '';
  List<SearchItem> _items = [];
  int totalResults = 0;

  List<SearchItem> get items => _items;

  Future<void> getPopularNowVideos() async {
    try {
      final api = APIService.instance;
      final itemResponse =
          await api.getPopularNowVideos(nextPageToken: _nextItemsToken);
      _nextItemsToken = itemResponse.nextPageToken;
      _items.addAll(itemResponse.items);
      totalResults = itemResponse.totalResults;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
