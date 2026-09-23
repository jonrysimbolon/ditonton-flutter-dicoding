import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_core/presentation/widgets/empty_watchlist.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVsList extends StatelessWidget {
  const WatchlistTVsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
        builder: (context, state) {
          if (state.watchlistState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.watchlistState == RequestState.loaded) {
            if (state.watchlistTvs.isEmpty) {
              return const EmptyWatchlist(
                key: Key('empty_watchlist_tv'),
                icon: Icons.tv_outlined,
                title: 'Watchlist TV series kosong',
                message: 'Belum ada TV series di watchlist. Tambahkan series favoritmu dari halaman detail.',
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.watchlistTvs[index];
                return TVCard(tv);
              },
              itemCount: state.watchlistTvs.length,
            );
          } else {
            return Center(
              key: const Key('error_message_tv'),
              child: Text(state.message),
            );
          }
        },
      ),
    );
  }
}
