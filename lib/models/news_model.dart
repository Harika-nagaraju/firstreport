class NewsModel {
  final String id;
  final String title;
  final String? category;
  final String? content;
  final String? country;
  final String? description;
  final String? image;
  final List<String> likedBy;
  final int likes;
  final DateTime publishedAt;
  final int shares;
  final String? sourceUrl;

  NewsModel({
    required this.id,
    required this.title,
    this.category,
    this.content,
    this.country,
    this.description,
    this.image,
    required this.likedBy,
    required this.likes,
    required this.publishedAt,
    required this.shares,
    this.sourceUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      category: json['category'],
      content: json['content'],
      country: json['country'],
      description: json['description'],
      image: json['image'],
      likedBy: List<String>.from(json['likedBy'] ?? []),
      likes: _toInt(json['likes']),
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      shares: _toInt(json['shares']),
      sourceUrl: json['sourceUrl'],
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
      'category': category,
      'content': content,
      'country': country,
      'description': description,
      'image': image,
      'likedBy': likedBy,
      'likes': likes,
      'publishedAt': publishedAt.toIso8601String(),
      'shares': shares,
      'sourceUrl': sourceUrl,
    };
  }
}
