class NewsModel {
  final String id;
  final String title;
  final String summary;
  final String fullContent;
  final String imageUrl;
  final String author;
  final DateTime publishedAt;
  final List<String> likedBy;
  final int likes;
  final int shares;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.likedBy,
    required this.likes,
    required this.shares,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? json['description'] ?? '',
      fullContent: json['fullContent'] ?? json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      author: json['author'] ?? json['source'] ?? 'General',
      likedBy: List<String>.from(json['likedBy'] ?? []),
      likes: _toInt(json['likes']),
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      shares: _toInt(json['shares']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'summary': summary,
      'fullContent': fullContent,
      'imageUrl': imageUrl,
      'author': author,
      'likedBy': likedBy,
      'likes': likes,
      'publishedAt': publishedAt.toIso8601String(),
      'shares': shares,
    };
  }
}
