import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTVsPage({super.key});

  @override
  State<TopRatedTVsPage> createState() => _TopRatedTVsPageState();
}

class _TopRatedTVsPageState extends State<TopRatedTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedTVsBloc>().add(FetchTopRatedTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVsBloc, TopRatedTVsState>(
          builder: (context, state) {
            if (state.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TVCard(tv);
                },
                itemCount: state.tvs.length,
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
}
