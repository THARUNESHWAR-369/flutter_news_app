import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_plus/models/news_api_services.dart';
import 'package:news_plus/models/news_model.dart';
import 'package:news_plus/screens/article_screen.dart';
import 'package:news_plus/screens/home_screen.dart';
import 'package:news_plus/screens/search_result_screen.dart';
import 'package:news_plus/widgets/image_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const routeName = '/search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ValueNotifier<String> filterOptionNotifier =
      ValueNotifier<String>("publishedAt");
  @override
  Widget build(BuildContext context) {
    List<String> tabs = [
      'Health',
      'Business',
      'Entertainment',
      'Technology',
      'Science'
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        // backgroundColor: const Color(0xfff2f2f2),
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, HomeScreen.routeName);
          },
          elevation: 0,
          splashColor: Colors.transparent,
          backgroundColor: const Color(0xfff2f2f2),
          child: const Icon(
            Icons.home,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //bottomNavigationBar: const BottomNavBar(index: 1),
        body: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _DiscoverNews(
              onFilterOptionSelected: (String filterOption) {
                filterOptionNotifier.value = filterOption;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            _CategoryNews(
              tabs: tabs,
              filterOptionNotifier: filterOptionNotifier,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
    required this.filterOptionNotifier,
  }) : super(key: key);

  final List<String> tabs;
  final ValueNotifier<String> filterOptionNotifier;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<List<Article>> categoryArticles = List.generate(5, (_) => []);
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _fetchArticles(selectedTabIndex);
    widget.filterOptionNotifier.addListener(_handleFilterOptionChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    widget.filterOptionNotifier.removeListener(_handleFilterOptionChange);

    _tabController.dispose();

    super.dispose();
  }

  void _handleFilterOptionChange() {
    // Fetch articles again when the filter option changes
    _fetchArticles(selectedTabIndex);
  }

  Future<void> _fetchArticles(int tabIndex) async {
    try {
      final List<Article> articles = await NewsApiService.fetchNews(
          q: widget.tabs[tabIndex],
          useEverythingUrl: true,
          sortBy: widget.filterOptionNotifier.value);
      categoryArticles[tabIndex] = articles;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      //print('Error fetching data: $e');
    }
  }

  _handleTabChange() {
    int newIndex = _tabController.index;
    if (newIndex != selectedTabIndex) {
      selectedTabIndex = newIndex;

      _fetchArticles(selectedTabIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("filterOptionNotifier: ${widget.filterOptionNotifier.value}");
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: _handleTabChange(),
          indicatorColor: Colors.black,
          tabs: widget.tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: TabBarView(
            children: widget.tabs.map((tab) {
              final int tabIndex = widget.tabs.indexOf(tab);
              return FutureBuilder<List<Article>>(
                  future: NewsApiService.fetchNews(
                      q: widget.tabs[tabIndex], useEverythingUrl: true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Data'),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoryArticles[selectedTabIndex].length,
                        itemBuilder: ((context, index) {
                          final String imageUrl =
                              categoryArticles[selectedTabIndex][index]
                                      .urlToImage ??
                                  '';

                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ArticleScreen.routeName,
                                arguments: {
                                  'selectedTab': widget.tabs[tabIndex],
                                  'article': categoryArticles[selectedTabIndex]
                                      [index]
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
                                  imageUrl: imageUrl,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        categoryArticles[selectedTabIndex]
                                                [index]
                                            .title!,
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
                                            '${DateTime.now().difference(categoryArticles[selectedTabIndex][index].publishedAt!).inHours} hours ago',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }
                  });
            }).toList(),
          ),
        )
      ],
    );
  }
}

typedef void FilterOptionCallback(String option);

class _DiscoverNews extends StatelessWidget {
  final FilterOptionCallback onFilterOptionSelected;

  _DiscoverNews({
    required this.onFilterOptionSelected,
  });
  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _onSearchButtonPressed() {
      final String searchQuery = searchTextController.text.trim();
      if (searchQuery.isNotEmpty) {
        print('Search Query: $searchQuery');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return SearchResultPage(searchQuery: searchQuery);
        }));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Discover",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w900),
            ),
            _buildFilterDropdown(context),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text("New from all over the world",
            style: Theme.of(context).textTheme.bodySmall!),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: searchTextController,
          onEditingComplete: _onSearchButtonPressed,
          decoration: InputDecoration(
            hintText: 'Search',
            fillColor: Colors.grey.shade200,
            filled: true,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: _onSearchButtonPressed,
              child: const Icon(Icons.send),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFilterDropdown(BuildContext context) {
    // Available sort options
    List<String> sortOptions = ['popularity', 'publishedAt'];

    return PopupMenuButton<String>(
      icon: const Icon(Icons.tune_rounded),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Sort By',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ), // Disable the subheading so it cannot be selected
          ),
          ...sortOptions.map((String option) {
            return PopupMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ];
      },
      onSelected: (String result) {
        onFilterOptionSelected(
            result); // Call the callback with the selected filter option
      },
    );
  }
}
