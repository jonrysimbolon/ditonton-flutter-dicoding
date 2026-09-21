import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).fetchMovieDetail(widget.id);
      Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (_, data, _) {
          if (data.movieState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.movieState == RequestState.loaded) {
            final movie = data.movie;
            return SafeArea(
              child: MovieDetailContent(
                movie,
                data.movieRecommendations,
                data.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(data.message);
          }
        },
      ),
    );
  }
}
