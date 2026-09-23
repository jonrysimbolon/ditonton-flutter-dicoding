import 'package:ditonton_core/common/analytics.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<TVDetailBloc>()
        ..add(FetchTVDetail(widget.id))
        ..add(LoadTVWatchlistStatus(widget.id));
      logAnalyticsEvent('detail_view', parameters: {
        'type': 'tv',
        'id': widget.id,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVDetailBloc, TVDetailState>(
        builder: (context, state) {
          if (state.tvState == RequestState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.tvState == RequestState.loaded) {
            final tv = state.tv!;
            return SafeArea(
              child: TVDetailContent(
                tv,
                state.tvRecommendations,
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
