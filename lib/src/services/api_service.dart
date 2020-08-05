import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:red_tv_youtube/src/models/channel_model.dart';
import 'package:red_tv_youtube/src/models/playlist.dart';
import 'package:red_tv_youtube/src/models/playlist_item.dart';
import 'package:red_tv_youtube/src/models/video_model.dart';
import 'package:red_tv_youtube/src/utilities/keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  // final apiKey = 'AIzaSyAZ2LG8W9qM_JgCJF99VJaqvMPWHvVflw8';
  final apiKey = 'AIzaSyC9AU2-GCw8b4_VbCEQ6Qy5mgzs03HEghs';

  final String _baseUrl = 'www.googleapis.com';
  final String _basePath = '/youtube/v3';
  final String _playlistItemsPath = '/playlistItems';
  final String _playlistsPath = '/playlists';
  final String _subscriptionsPath = '/subscriptions';
  static final redTVId = "UCmaJwjJJkzMttK8L79g_8zA";
  String authToken = '';
  String _nextPageToken = '';

  bool subscriptionStatus = false;

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json'
  };

  Future<Channel> fetchChannel({String channelId}) async {
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
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
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

      print(jsonDecode(response.body) as Map);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('api: subscription status - $data');
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
    print(authToken);

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
        print('api: subscribe user - $data');
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
        print('api: playlist - $data');
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

  Future<PlaylistItemResponse> getPlaylistItems(
      {String playlistId, String nextPageToken}) async {
    String _itemsNextPageToken = '';

    Map<String, String> parameters = {
      'part': 'snippet, contentDetails',
      'playlistId': playlistId,
      'pageToken': nextPageToken,
      'maxResults': '15',
      'key': apiKey
    };

    Uri uri = Uri.https(_baseUrl, '$_basePath$_playlistItemsPath', parameters);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _itemsNextPageToken = data['nextPageToken'] ?? '';
        // print('api: next page token - $_nextPageToken');

        print(
            'api: total results per page - ${data['pageInfo']['resultsPerPage']}');
        final items = data['items'] as List;

        List<PlaylistItem> plistItems = [];
        for (var item in items) {
          final playlistItem = PlaylistItem.fromJson(item);
          plistItems.add(playlistItem);
        }

        return PlaylistItemResponse(
            nextPageToken: _itemsNextPageToken, items: plistItems);
      } else {
        throw jsonDecode(response.body)['error']['message'];
      }
    } catch (e, s) {
      print(s);
    }
  }
}

class PlaylistItemResponse {
  String nextPageToken;
  List<PlaylistItem> items;

  PlaylistItemResponse({this.nextPageToken, this.items});
}
