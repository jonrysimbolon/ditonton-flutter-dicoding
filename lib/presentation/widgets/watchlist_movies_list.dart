import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/empty_watchlist.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesList extends StatelessWidget {
  const WatchlistMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (_, data, _) {
          if (data.watchlistState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.watchlistState == RequestState.loaded) {
            if (data.watchlistMovies.isEmpty) {
              return const EmptyWatchlist(
                key: Key('empty_watchlist_movies'),
                icon: Icons.movie_outlined,
                title: 'Watchlist film kosong',
                message: 'Belum ada film di watchlist. Tambahkan film favoritmu dari halaman detail.',
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return Center(
              key: const Key('error_message_movie'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
