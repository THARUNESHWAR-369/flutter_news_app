import 'package:flutter/material.dart';
import 'package:news_plus/models/news_api_services.dart';
import 'package:news_plus/screens/article_screen.dart';
import 'package:news_plus/screens/search_screen.dart';
import 'package:news_plus/widgets/custom_tag.dart';
import 'package:news_plus/widgets/image_container.dart';
import 'package:news_plus/models/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Article>> _newsFuture = _fetchNews();

  static Future<List<Article>> _fetchNews() async {
    // Fetch your news data here using NewsApiService or any other method.
    // For example:
    return NewsApiService.fetchNews(useEverythingUrl: false);
  }

  Future<void> _refresh() async {
    // Fetch new data
    final List<Article> updatedData = await _fetchNews();

    setState(() {
      // Update the future with new data
      _newsFuture = Future.value(updatedData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, SearchScreen.routeName);
        },
        elevation: 0,
        splashColor: Colors.transparent,
        backgroundColor: const Color(0xfff2f2f2),
        child: const Icon(
          Icons.search,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //  bottomNavigationBar: const BottomNavBar(index: 0),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<List<Article>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Article> topHeadlines = snapshot.data!;
                  return Column(
                    children: [
                      _NewsOfTheDay(article: topHeadlines[0]),
                      _BreakingNews(articles: topHeadlines.sublist(1)),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakingNews extends StatelessWidget {
  const _BreakingNews({
    required this.articles,
  });
  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Breaking News",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                /* Text(
                  "More",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),*/
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                  itemCount: articles.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final title = articles[index].title;
                    final imageUrl = articles[index].urlToImage ?? "";

                    return Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ArticleScreen.routeName,
                              arguments: {
                                'selectedTab': articles[index].sourceName,
                                'article': articles[index]
                              },
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageContainer(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  imageUrl: imageUrl),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                title ?? '',
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${DateTime.now().difference(articles[index].publishedAt!).inHours} hours ago',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'by ${articles[index].author ?? 'Unknown'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1.5),
                              ),
                            ],
                          ),
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class _NewsOfTheDay extends StatelessWidget {
  const _NewsOfTheDay({required this.article});
  final Article article;
  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      width: double.infinity,
      imageUrl: article.urlToImage!,
      //padding: const EdgeInsets.all(20.0),
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              bgColor: Colors.grey.withAlpha(150),
              children: [
                Text(
                  "News of the Day",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              article.title!,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.2),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ArticleScreen.routeName,
                  arguments: {
                    'selectedTab': article.sourceName,
                    'article': article
                  },
                );
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(
                    "Learn More",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
