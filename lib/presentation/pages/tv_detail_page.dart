import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  static const routeName = '/tv-detail';
  static const routeNameAlias = '/detail-tv';

  final int id;

  const TVDetailPage({super.key, required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<TVDetailNotifier>(
        context,
        listen: false,
      ).fetchTvDetail(widget.id);
      Provider.of<TVDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TVDetailNotifier>(
        builder: (_, data, _) {
          if (data.tvState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.tvState == RequestState.loaded) {
            final tv = data.tv;
            return SafeArea(
              child: TVDetailContent(
                tv,
                data.tvRecommendations,
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
