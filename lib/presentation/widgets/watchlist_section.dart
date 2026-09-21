import 'package:ditonton/presentation/widgets/watchlist_movies_list.dart';
import 'package:ditonton/presentation/widgets/watchlist_tvs_list.dart';
import 'package:flutter/material.dart';

class WatchlistSection extends StatelessWidget {
  const WatchlistSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [WatchlistMoviesList(), WatchlistTVsList()],
            ),
          ),
        ],
      ),
    );
  }
}
