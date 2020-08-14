import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:red_tv_youtube/src/models/channel.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/models/popular_now_item.dart';
import 'package:red_tv_youtube/src/models/video.dart';
import 'package:red_tv_youtube/src/utilities/keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  final String _basePath = '/youtube/v3';
  final String _playlistItemsPath = '/playlistItems';
  final String _playlistsPath = '/playlists';
  final String _subscriptionsPath = '/subscriptions';
  final String _searchPath = '/search';
  static final redTVId = "UCmaJwjJJkzMttK8L79g_8zA";
  String authToken = '';
  String _nextPageToken = ''; //TODO: @ChidiChuks is using this variable

  bool subscriptionStatus = false;

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  Future<Channel> getChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromJson(data);

      // // Fetch first batch of videos from uploads playlist
      // channel.videos = await fetchVideosFromPlaylist(
      //   playlistId: channel.uploadPlaylistId,
      // );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<PlaylistsResponse> getPlaylists({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'channelId': channelId,
      'key': apiKey,
      'maxResults': '25'
    };
    Uri uri = Uri.https(
      _baseUrl,
      '$_basePath$_playlistsPath',
      parameters,
    );

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    try {
      var response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final nextPageToken = data['nextPageToken'];
        final totalResults = data['pageInfo']['totalResults'];
        final items = data['items'] as List;

        List<Playlist> playlists = [];

        for (var item in items) {
          final playlist = Playlist.fromJson(item);
          playlists.add(playlist);
        }

        final playlistsResponse = PlaylistsResponse(
          nextPageToken: nextPageToken,
          totalResults: totalResults,
          items: playlists,
        );

        return playlistsResponse;
      } else {
        throw json.decode(response.body)['error']['message'];
      }
    } catch (e) {}
  }

  Future<Playlist> getPlaylist({String playlistId}) async {
    Playlist playlist;

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'id': playlistId,
      'key': apiKey
    };

    Uri uri = Uri.https(_baseUrl, '$_basePath$_playlistsPath', parameters);
    print('api: $uri');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('api: playlist - $data');
        final items = data['items'] as List;

        final item = items[0];
        playlist = Playlist.fromJson(item);
        return playlist;
      } else {
        throw jsonDecode(response.body)['error']['message'];
      }
    } catch (e, s) {
      print(e);
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach(
        (json) => videos.add(
          Video.fromMap(json['snippet']),
        ),
      );
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<bool> checkIfUserIsSubscribed({String authToken}) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $authToken'
    };

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'mine': 'true',
      'forChannelId': redTVId,
      'key': apiKey
    };

    try {
      Uri uri =
          Uri.https(_baseUrl, '$_basePath$_subscriptionsPath', parameters);
      print('api: $uri');

      final response = await http.get(uri, headers: headers);

      // print(jsonDecode(response.body) as Map);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('api: subscription status - $data');
        final items = data['items'] as List;
        return subscriptionStatus = items.isNotEmpty;
      }
    } catch (e, s) {
      print(e);
      print(s);
      // subscriptionStatus = false;
      // rethrow;
    }
    return subscriptionStatus;
  }

  Future<bool> subscribe({String authToken}) async {
    // print(authToken);

    var subscriptionBody = {
      "snippet": {
        "resourceId": {"channelId": redTVId, "kind": "youtube#channel"}
      }
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $authToken'
    };

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'key': apiKey
    };

    try {
      Uri uri =
          Uri.https(_baseUrl, '$_basePath$_subscriptionsPath', parameters);
      print('api: $uri');

      final response = await http.post(uri,
          headers: headers, body: jsonEncode(subscriptionBody));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print('api: subscribe user - $data');
        subscriptionStatus = true;
      }

      //get playlist data

      // get playlistitems
    } catch (e, s) {
      print(e);
      subscriptionStatus = false;
    }

    return subscriptionStatus;
  }

  Future<PlaylistItemsResponse> getPlaylistItems(
      {@required String playlistId, @required String nextPageToken}) async {
    String _itemsNextPageToken = '';

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': playlistId,
      'pageToken': nextPageToken,
      'maxResults': '20',
      'key': apiKey
    };

    Uri uri = Uri.https(_baseUrl, '$_basePath$_playlistItemsPath', parameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _itemsNextPageToken = data['nextPageToken'] ?? '';
        // print('api: next page token - $_nextPageToken');

        // print(
        //     'api: total results per page - ${data['pageInfo']['resultsPerPage']}');
        final items = data['items'] as List;

        List<PlaylistItem> plistItems = [];
        for (var item in items) {
          final playlistItem = PlaylistItem.fromJson(item);
          plistItems.add(playlistItem);
        }

        return PlaylistItemsResponse(
            nextPageToken: _itemsNextPageToken, items: plistItems);
      } else {
        throw jsonDecode(response.body)['error']['message'];
      }
    } catch (e, s) {
      print(s);
    }
  }

  Future<PopularNowItemsResponse> getPopularNowVideos(
      {@required String nextPageToken}) async {
    String _itemsNextPageToken = '';
    Map<String, String> parameters = {
      'part': 'snippet',
      'channelId': redTVId,
      'pageToken': nextPageToken,
      'maxResults': '50',
      'order': 'viewCount',
      'key': apiKey
    };

    Uri uri = Uri.https(_baseUrl, '$_basePath$_searchPath', parameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _itemsNextPageToken = data['nextPageToken'] ?? '';
        final totalResults = data['pageInfo']['totalResults'];
        // print('api: next page token - $_itemsNextPageToken');

        // print('api: results per page - ${data['pageInfo']['resultsPerPage']}');
        // print('api: total results - ${data['pageInfo']['totalResults']}');
        final items = data['items'] as List;
        // print('api: popular video ${items[0]}');

        List<PopularNowItem> searchItems = [];
        for (var item in items) {
          final searchItem = PopularNowItem.fromJson(item);
          searchItems.add(searchItem);
        }
        // print('api: search items - $searchItems');

        return PopularNowItemsResponse(
            totalResults: totalResults,
            nextPageToken: _itemsNextPageToken,
            items: searchItems);
      } else {
        throw jsonDecode(response.body)['error']['message'];
      }
    } catch (e, s) {
      print(s);
    }
  }
}

class PlaylistsResponse {
  String nextPageToken;
  int totalResults;
  List<Playlist> items;

  PlaylistsResponse({this.nextPageToken, this.totalResults, this.items});
}

class PopularNowItemsResponse {
  String nextPageToken;
  int totalResults;
  List<PopularNowItem> items;

  PopularNowItemsResponse({this.nextPageToken, this.totalResults, this.items});
}

class PlaylistItemsResponse {
  String nextPageToken;
  List<PlaylistItem> items;

  PlaylistItemsResponse({this.nextPageToken, this.items});
}
