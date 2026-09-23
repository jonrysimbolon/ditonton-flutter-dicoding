import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/presentation/widgets/empty_watchlist.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesList extends StatelessWidget {
  const WatchlistMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state.watchlistState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.watchlistState == RequestState.loaded) {
            if (state.watchlistMovies.isEmpty) {
              return const EmptyWatchlist(
                key: Key('empty_watchlist_movies'),
                icon: Icons.movie_outlined,
                title: 'Watchlist film kosong',
                message: 'Belum ada film di watchlist. Tambahkan film favoritmu dari halaman detail.',
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) {
                final movie = state.watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: state.watchlistMovies.length,
            );
          } else {
            return Center(
              key: const Key('error_message_movie'),
              child: Text(state.message),
            );
          }
        },
      ),
    );
  }
}
