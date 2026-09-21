import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/widgets/about_content.dart';
import 'package:ditonton/presentation/pages/home_section.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_content.dart';
import 'package:ditonton/presentation/widgets/watchlist_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  const HomeMoviePage({super.key});

  @override
  State<HomeMoviePage> createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> with RouteAware {
  HomeSection _section = HomeSection.movies;
  bool _tvFetched = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _refreshWatchlists();
  }

  void _refreshWatchlists() {
    Provider.of<WatchlistMovieNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies();
    Provider.of<WatchlistTVNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvs();
  }

  void _selectSection(HomeSection section) {
    setState(() {
      _section = section;
    });
    if (section == HomeSection.tvSeries && !_tvFetched) {
      _tvFetched = true;
      Provider.of<TVListNotifier>(context, listen: false)
        ..fetchAiringTodayTvs()
        ..fetchOnTheAirTvs()
        ..fetchPopularTvs()
        ..fetchTopRatedTvs();
    } else if (section == HomeSection.watchlist) {
      _refreshWatchlists();
    }
  }

  String get _title {
    switch (_section) {
      case HomeSection.movies:
        return 'Ditonton';
      case HomeSection.tvSeries:
        return 'TV Series';
      case HomeSection.watchlist:
        return 'Watchlist';
      case HomeSection.about:
        return 'About';
    }
  }

  void _openSearch() {
    Navigator.pushNamed(
      context,
      _section == HomeSection.tvSeries
          ? SearchTVPage.routeName
          : SearchPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: const AssetImage('assets/circle-g.png'),
                backgroundColor: Colors.grey.shade900,
              ),
              accountName: const Text('Ditonton'),
              accountEmail: const Text('ditonton@dicoding.com'),
              decoration: BoxDecoration(color: Colors.grey.shade900),
            ),
            ListTile(
              selected: _section == HomeSection.movies,
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
                _selectSection(HomeSection.movies);
              },
            ),
            ListTile(
              selected: _section == HomeSection.tvSeries,
              leading: const Icon(Icons.tv),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
                _selectSection(HomeSection.tvSeries);
              },
            ),
            ListTile(
              selected: _section == HomeSection.watchlist,
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pop(context);
                _selectSection(HomeSection.watchlist);
              },
            ),
            ListTile(
              selected: _section == HomeSection.about,
              onTap: () {
                Navigator.pop(context);
                _selectSection(HomeSection.about);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(_title),
        actions: [
          if (_section == HomeSection.movies ||
              _section == HomeSection.tvSeries)
            IconButton(onPressed: _openSearch, icon: const Icon(Icons.search)),
        ],
      ),
      body: _buildSection(),
    );
  }

  Widget _buildSection() {
    switch (_section) {
      case HomeSection.movies:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Now Playing', style: heading6),
                Consumer<MovieListNotifier>(
                  builder: (_, data, _) {
                    final state = data.nowPlayingState;
                    if (state == RequestState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state == RequestState.loaded) {
                      return MovieList(data.nowPlayingMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Popular',
                  onTap: () {
                    Navigator.pushNamed(context, PopularMoviesPage.routeName);
                  },
                ),
                Consumer<MovieListNotifier>(
                  builder: (_, data, _) {
                    final state = data.popularMoviesState;
                    if (state == RequestState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state == RequestState.loaded) {
                      return MovieList(data.popularMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () {
                    Navigator.pushNamed(context, TopRatedMoviesPage.routeName);
                  },
                ),
                Consumer<MovieListNotifier>(
                  builder: (_, data, _) {
                    final state = data.topRatedMoviesState;
                    if (state == RequestState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state == RequestState.loaded) {
                      return MovieList(data.topRatedMovies);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      case HomeSection.tvSeries:
        return const TVSeriesContent();
      case HomeSection.watchlist:
        return const WatchlistSection();
      case HomeSection.about:
        return const AboutContent();
    }
  }

  Row _buildSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
