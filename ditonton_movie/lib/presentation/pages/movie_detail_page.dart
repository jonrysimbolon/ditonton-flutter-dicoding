import 'package:ditonton_core/common/analytics.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movie/presentation/widgets/movie_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieDetailBloc>()
        ..add(FetchMovieDetail(widget.id))
        ..add(LoadMovieWatchlistStatus(widget.id));
      logAnalyticsEvent(
        'detail_view',
        parameters: {'type': 'movie', 'id': widget.id},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.movieState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.movieState == RequestState.loaded) {
            final movie = state.movie!;
            return SafeArea(
              child: MovieDetailContent(
                movie,
                state.movieRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(state.message);
          }
        },
      ),
    );
  }
}
