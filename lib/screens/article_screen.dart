import 'package:flutter/material.dart';
import 'package:news_plus/models/news_model.dart';
import 'package:news_plus/screens/inappview_screen.dart';
import 'package:news_plus/widgets/custom_tag.dart';
import 'package:news_plus/widgets/image_container.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});
  static const routeName = '/article';
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Article article = arguments['article'];
    final String selectedTab = arguments['selectedTab'];
    return ImageContainer(
      width: double.infinity,
      imageUrl: article.urlToImage!,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            _NewsHeadLine(
              article: article,
              selectedTab: selectedTab,
            ),
            _NewsBody(
              article: article,
              selectedTab: selectedTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody(
      {super.key, required this.article, required this.selectedTab});
  final Article article;
  final String selectedTab; // Add selectedTab here

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(20.0),
      //margin: EdgeInsets.only(top: 150.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(179, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomTag(
                bgColor: Colors.black,
                children: [
                  Text(
                    selectedTab,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              CustomTag(
                bgColor: Colors.grey.shade200,
                children: [
                  const Icon(Icons.timer, color: Colors.grey),
                  Text(
                      "${DateTime.now().difference(article.publishedAt!).inHours}h",
                      style: Theme.of(context).textTheme.bodyMedium)
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            article.title!,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            article.description!,
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(height: 1.5),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InAppWebViewPage(
                            pageUrl: article.url!,
                            pageTitle: article.title!,
                          )));
            },
            child: Text(
              "Read more on....",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueAccent,
                  letterSpacing: 1.5,
                  decoration: TextDecoration.underline),
            ),
          )
        ],
      ),
    );
  }
}

class _NewsHeadLine extends StatelessWidget {
  const _NewsHeadLine(
      {super.key, required this.article, required this.selectedTab});
  final Article article;
  final String selectedTab; // Add selectedTab here

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTag(
            bgColor: Colors.grey.withAlpha(150),
            children: [
              Text(
                selectedTab,
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
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CustomTag(
              bgColor: Colors.black.withOpacity(0.4),
              children: [
                Text(
                  article.author!,
                  maxLines: 3,
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
