import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/empty_watchlist.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistTVsList extends StatelessWidget {
  const WatchlistTVsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTVNotifier>(
        builder: (_, data, _) {
          if (data.watchlistState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.watchlistState == RequestState.loaded) {
            if (data.watchlistTvs.isEmpty) {
              return const EmptyWatchlist(
                key: Key('empty_watchlist_tv'),
                icon: Icons.tv_outlined,
                title: 'Watchlist TV series kosong',
                message: 'Belum ada TV series di watchlist. Tambahkan series favoritmu dari halaman detail.',
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = data.watchlistTvs[index];
                return TVCard(tv);
              },
              itemCount: data.watchlistTvs.length,
            );
          } else {
            return Center(
              key: const Key('error_message_tv'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
