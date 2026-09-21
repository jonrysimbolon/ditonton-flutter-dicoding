import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_season_arguments.dart';
import 'package:ditonton/presentation/pages/tv_season_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const TVDetailContent(
    this.tv,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _PosterHeader(tv: tv),
        _DetailSheet(
          tv: tv,
          recommendations: recommendations,
          isAddedWatchlist: isAddedWatchlist,
        ),
        const _BackButton(),
      ],
    );
  }
}

class _PosterHeader extends StatelessWidget {
  final TVDetail tv;

  const _PosterHeader({required this.tv});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$baseImageUrl${tv.posterPath}',
      width: MediaQuery.of(context).size.width,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => const Icon(Icons.error),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedWatchlist;

  const _DetailSheet({
    required this.tv,
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
                      _TVMetaSection(
                        tv: tv,
                        isAddedWatchlist: isAddedWatchlist,
                      ),
                      _Section(title: 'Overview', child: Text(tv.overview)),
                      _Section(
                        title: 'Seasons',
                        child: _SeasonsSection(tv: tv),
                      ),
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

class _TVMetaSection extends StatelessWidget {
  final TVDetail tv;
  final bool isAddedWatchlist;

  const _TVMetaSection({required this.tv, required this.isAddedWatchlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tv.name, style: heading5),
        _WatchlistButton(tv: tv, isAddedWatchlist: isAddedWatchlist),
        Text(_showGenres(tv.genres)),
        Text(
          'Seasons: ${tv.numberOfSeasons} | Episodes: ${tv.numberOfEpisodes}',
        ),
        Row(
          children: [
            RatingBarIndicator(
              rating: tv.voteAverage / 2,
              itemCount: 5,
              itemBuilder: (_, __) =>
                  const Icon(Icons.star, color: mikadoYellow),
              itemSize: 24,
            ),
            Text('${tv.voteAverage}'),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _WatchlistButton extends StatelessWidget {
  final TVDetail tv;
  final bool isAddedWatchlist;

  const _WatchlistButton({required this.tv, required this.isAddedWatchlist});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        if (!isAddedWatchlist) {
          await Provider.of<TVDetailNotifier>(
            context,
            listen: false,
          ).addWatchlist(tv);
        } else {
          await Provider.of<TVDetailNotifier>(
            context,
            listen: false,
          ).removeFromWatchlist(tv);
        }
        if (!context.mounted) return;
        final message = Provider.of<TVDetailNotifier>(
          context,
          listen: false,
        ).watchlistMessage;
        if (message == TVDetailNotifier.watchlistAddSuccessMessage ||
            message == TVDetailNotifier.watchlistRemoveSuccessMessage) {
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

class _SeasonsSection extends StatelessWidget {
  final TVDetail tv;

  const _SeasonsSection({required this.tv});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tv.seasons.length,
        itemBuilder: (context, index) {
          final season = tv.seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVSeasonPage.routeName,
                  arguments: TVSeasonArguments(
                    id: tv.id,
                    seasonNumber: season.seasonNumber,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: '$baseImageUrl${season.posterPath}',
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      season.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('${season.episodeCount} episodes'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Recommendations extends StatelessWidget {
  const _Recommendations();

  @override
  Widget build(BuildContext context) {
    return Consumer<TVDetailNotifier>(
      builder: (_, data, _) {
        if (data.recommendationState == RequestState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (data.recommendationState == RequestState.error) {
          return Text(data.message);
        } else if (data.recommendationState == RequestState.loaded) {
          final recommendations = data.tvRecommendations;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final item = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TVDetailPage.routeName,
                        arguments: item.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: '$baseImageUrl${item.posterPath}',
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
