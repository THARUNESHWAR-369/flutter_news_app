import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:news_plus/config.dart';
import 'package:news_plus/models/news_model.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class NewsApiService {
  static const String apiKey = NEW_API_KEY; // Replace with your API key

  static final String fromDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  static Future<List<Article>> fetchNews(
      {String? country = 'IN',
      String? category,
      String? fromDate,
      String? q,
      String? sortBy = 'publishedAt',
      bool useEverythingUrl = false}) async {
    fromDate ??= DateFormat('yyyy-MM-dd').format(DateTime.now());
    String baseUrl = useEverythingUrl
        ? 'https://newsapi.org/v2/everything' // The first URL
        : 'https://newsapi.org/v2/top-headlines'; // The default URL

    String url = '$baseUrl?apiKey=$apiKey';

    if (country != null && !useEverythingUrl) {
      url += '&country=$country';
    }

    if (category != null && !useEverythingUrl) {
      url += '&category=$category';
    }
    if (!useEverythingUrl) {
      url += '&from=$fromDate';
    }

    if (q != null) {
      url += '&q=$q';
    }

    if (sortBy != null) {
      url += '&sortBy=$sortBy';
    }
    try {
      print("url: $url");
      final response = await http.get(Uri.parse(url));
      final jsonData = jsonDecode(response.body);
      const defaultImageUrl =
          "https://pioneer-technical.com/wp-content/uploads/2016/12/news-placeholder.png";

      if (jsonData['status'] == 'ok') {
        final articlesData = jsonData['articles'] as List<dynamic>;
        List<Article> articles = [];

        for (var articleData in articlesData) {
          DateTime? publishedAt;
          if (articleData['publishedAt'] != null) {
            publishedAt = DateTime.parse(articleData['publishedAt']);
          }

          articles.add(Article(
            title: articleData['title'] ?? "Unknown",
            description: articleData['description'] ?? "No description",
            url: articleData['url'] ?? "",
            urlToImage: articleData['urlToImage'] ?? defaultImageUrl,
            author: articleData['author'] ??
                articleData['source']['name'] ??
                "No Name",
            publishedAt: publishedAt,
            content: articleData['content'] ?? "",
            sourceName: articleData['source']['name'] ?? "No Name",
          ));
        }

        return articles;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
