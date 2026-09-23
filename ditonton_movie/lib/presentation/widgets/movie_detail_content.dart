import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/common/analytics.dart';
import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_core/domain/entities/movie_detail.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const MovieDetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _PosterHeader(movie: movie),
        _DetailSheet(
          movie: movie,
          recommendations: recommendations,
          isAddedWatchlist: isAddedWatchlist,
        ),
        const _BackButton(),
      ],
    );
  }
}

class _PosterHeader extends StatelessWidget {
  final MovieDetail movie;

  const _PosterHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$baseImageUrl${movie.posterPath}',
      width: MediaQuery.of(context).size.width,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => const Icon(Icons.error),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const _DetailSheet({
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48 + 8),
      child: DraggableScrollableSheet(
        minChildSize: 0.25,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: richBlack,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MovieMetaSection(
                        movie: movie,
                        isAddedWatchlist: isAddedWatchlist,
                      ),
                      _Section(title: 'Overview', child: Text(movie.overview)),
                      const _Section(
                        title: 'Recommendations',
                        child: _Recommendations(),
                      ),
                    ],
                  ),
                ),
                const _DragHandle(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MovieMetaSection extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const _MovieMetaSection({
    required this.movie,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: heading5),
        _WatchlistButton(movie: movie, isAddedWatchlist: isAddedWatchlist),
        Text(_showGenres(movie.genres)),
        Text(_showDuration(movie.runtime)),
        Row(
          children: [
            RatingBarIndicator(
              rating: movie.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: mikadoYellow),
              itemSize: 24,
            ),
            Text('${movie.voteAverage}'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _WatchlistButton extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;

  const _WatchlistButton({required this.movie, required this.isAddedWatchlist});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final bloc = context.read<MovieDetailBloc>();
        logAnalyticsEvent(
          'watchlist_toggle',
          parameters: {
            'action': isAddedWatchlist ? 'remove' : 'add',
            'id': movie.id,
          },
        );
        if (!isAddedWatchlist) {
          bloc.add(AddMovieWatchlist(movie));
        } else {
          bloc.add(RemoveMovieWatchlist(movie));
        }
        await bloc.stream.firstWhere(
          (state) => state.watchlistMessage.isNotEmpty,
        );
        if (!context.mounted) return;
        final message = bloc.state.watchlistMessage;
        if (message == MovieDetailState.watchlistAddSuccessMessage ||
            message == MovieDetailState.watchlistRemoveSuccessMessage) {
          messenger.showSnackBar(SnackBar(content: Text(message)));
        } else {
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(content: Text(message));
            },
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isAddedWatchlist ? const Icon(Icons.check) : const Icon(Icons.add),
          const Text('Watchlist'),
        ],
      ),
    );
  }
}

class _Recommendations extends StatelessWidget {
  const _Recommendations();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailBloc, MovieDetailState>(
      builder: (context, state) {
        if (state.recommendationState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.recommendationState == RequestState.error) {
          return Text(state.message);
        } else if (state.recommendationState == RequestState.loaded) {
          final recommendations = state.movieRecommendations;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final movie = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MovieDetailPage.routeName,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: '$baseImageUrl${movie.posterPath}',
                        placeholder: (_, __) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: heading6),
        child,
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(color: Colors.white, height: 4, width: 48),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: richBlack,
        foregroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

String _showGenres(List<Genre> genres) {
  var result = '';
  for (final genre in genres) {
    result += '${genre.name}, ';
  }

  if (result.isEmpty) {
    return result;
  }

  return result.substring(0, result.length - 2);
}

String _showDuration(int runtime) {
  final hours = runtime ~/ 60;
  final minutes = runtime % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}
