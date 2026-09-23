import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVsPage extends StatefulWidget {
  static const routeName = '/watchlist-tv';

  const WatchlistTVsPage({super.key});

  @override
  State<WatchlistTVsPage> createState() => _WatchlistTVsPageState();
}

class _WatchlistTVsPageState extends State<WatchlistTVsPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
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
    context.read<WatchlistTVBloc>().add(const FetchWatchlistTVs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
          builder: (context, state) {
            if (state.watchlistState == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.watchlistState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.watchlistTvs[index];
                  return TVCard(tv);
                },
                itemCount: state.watchlistTvs.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
