class Thumbnail {
  String url;
  int width;
  int height;

  Thumbnail({this.url = '', this.width = 0, this.height = 0});

  bool get isValid => this.url.isNotEmpty && this.url != ' ';

  Thumbnail.empty() : this();

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}
