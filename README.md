# Red TV Player

Red TV Player is a video-streaming app that allows you watch all your favourites shows from RED TV

## Features


### Screenshots
Home:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/welcome.jpg "Home")

All Playlists:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/all_playlists.jpg "All Playlists")

Playlist Details:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/playlist_desc.jpg "Playlist Details")

All Exclusives:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/all_exclusives.jpg "All Exclusives")

Watch All Videos:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/watch_all.jpg "Watch All Videos")

Watch Single Video:
![alt text](https://github.com/HemlockBane/red_tv_youtube/raw/dev/screenshots/watch_one.jpg "Watch Single Video")






## Getting Started

### Prerequisites
- Ensure that you have flutter installed and setup correctly
- You'll need an API key to access Youtube Data API. Follow steps 1 - 3 [here](https://developers.google.com/youtube/v3/getting-started)
- Add your API key to code
- You'll also need OAuth 2.0 authorization to be able to access the user's Youtube subscriptions. This app uses the [Google Sign In plugin](https://pub.dev/packages/google_sign_in) to generate an OAuth 2.0 access token. While setting up the plugin, you'll need to add your SHA1 key to the Firebase project you used to set up the app


### Dependencies
- provider
- youtube_player_flutter
- google_sign_in

### Installing the app
- Clone the repo
- Fetch dependencies: Run `flutter packages get` in the terminal
- Install app: Run `flutter run`  in the terminal
