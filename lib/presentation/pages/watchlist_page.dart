import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/widgets/watchlist_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist';

  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
      context.read<WatchlistTVBloc>().add(const FetchWatchlistTVs());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMovies());
    context.read<WatchlistTVBloc>().add(const FetchWatchlistTVs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: const WatchlistSection(),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
