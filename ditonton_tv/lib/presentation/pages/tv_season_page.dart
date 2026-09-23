import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeasonPage extends StatefulWidget {
  static const routeName = '/tv-season';

  final int id;
  final int seasonNumber;

  const TVSeasonPage({super.key, required this.id, required this.seasonNumber});

  @override
  State<TVSeasonPage> createState() => _TVSeasonPageState();
}

class _TVSeasonPageState extends State<TVSeasonPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVDetailBloc>().add(
        FetchSeasonDetail(widget.id, widget.seasonNumber),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Season ${widget.seasonNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TVDetailBloc, TVDetailState>(
          builder: (context, state) {
            if (state.seasonDetailState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.seasonDetailState == RequestState.loaded) {
              final detail = state.seasonDetail!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.name, style: heading6),
                    const SizedBox(height: 8),
                    Text(detail.overview),
                    const SizedBox(height: 16),
                    Text(
                      'Episodes (${detail.episodes.length})',
                      style: heading6,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detail.episodes.length,
                      itemBuilder: (_, index) {
                        final episode = detail.episodes[index];
                        return Card(
                          child: ListTile(
                            leading: episode.stillPath != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '$baseImageUrl${episode.stillPath}',
                                      width: 100,
                                      placeholder: (_, __) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (_, __, ___) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : const Icon(Icons.tv, size: 48),
                            title: Text(
                              'E${episode.episodeNumber}: ${episode.name}',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  episode.overview,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rating: ${episode.voteAverage} (${episode.voteCount} votes)',
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else if (state.seasonDetailState == RequestState.error) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
