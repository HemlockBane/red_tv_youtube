import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:red_tv_youtube/src/models/popular_now_item.dart';
import 'package:red_tv_youtube/src/services/api_service.dart';

class PopularNowNotifier extends ChangeNotifier {
  static PopularNowNotifier of(BuildContext context) =>
      Provider.of<PopularNowNotifier>(context, listen: false);

  String _nextItemsToken = '';
  List<PopularNowItem> _items = [];
  int totalItemCount = 0;

  List<PopularNowItem> get items => _items;

  Future<void> getPopularNowVideos() async {
    try {
      final api = APIService.instance;
      final itemResponse =
          await api.getPopularNowVideos(nextPageToken: _nextItemsToken);
      _nextItemsToken = itemResponse.nextPageToken;
      _items.addAll(itemResponse.items);
      totalItemCount = itemResponse.totalResults;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
