import 'package:flutter/material.dart';
import 'package:news_plus/models/news_api_services.dart';
import 'package:news_plus/models/news_model.dart';
import 'package:news_plus/screens/article_screen.dart';
import 'package:news_plus/widgets/image_container.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage({super.key, required this.searchQuery});
  final String searchQuery;
  static const String routeName = "/search-result-page";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            searchQuery,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.3),
          ),
        ),
        body: FutureBuilder(
          future:
              NewsApiService.fetchNews(q: searchQuery, useEverythingUrl: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No News found :)",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800, color: Colors.redAccent),
                ),
              );
            } else {
              final List<Article> searchData = snapshot.data!;

              return ListView.builder(
                itemCount: searchData.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ArticleScreen.routeName,
                        arguments: {
                          'selectedTab': searchData[index].sourceName,
                          'article': searchData[index]
                        },
                      );
                    },
                    child: Row(
                      children: [
                        ImageContainer(
                          key: UniqueKey(), // Add UniqueKey here
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.all(10.0),
                          borderRadius: 5,
                          imageUrl: searchData[index].urlToImage!,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                searchData[index].title!,
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${DateTime.now().difference(searchData[index].publishedAt!).inHours} hours ago',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
