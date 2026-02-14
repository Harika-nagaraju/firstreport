import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PostItem {
  final String id;
  final String title;
  final String description;
  final String? url;
  final String? imagePath; // for now just store path/name if needed
  final String? category;
  final DateTime createdAt;

  PostItem({
    required this.id,
    required this.title,
    required this.description,
    this.url,
    this.imagePath,
    this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'imagePath': imagePath,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PostItem.fromJson(Map<String, dynamic> json) => PostItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        url: json['url'] as String?,
        imagePath: json['imagePath'] as String?,
        category: json['category'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class PostStorage {
  static const _key = 'user_posts';

  static Future<List<PostItem>> loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => PostItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> savePosts(List<PostItem> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(posts.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> addPost(PostItem post) async {
    final posts = await loadPosts();
    posts.insert(0, post); // newest first
    await savePosts(posts);
  }

  static Future<void> deletePost(String id) async {
    final posts = await loadPosts();
    posts.removeWhere((p) => p.id == id);
    await savePosts(posts);
  }

  static Future<void> updatePost(PostItem updated) async {
    final posts = await loadPosts();
    final index = posts.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      posts[index] = updated;
      await savePosts(posts);
    }
  }
}
