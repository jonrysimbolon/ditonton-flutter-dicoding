import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTVsPage extends StatefulWidget {
  static const routeName = '/airing-today-tv';

  const AiringTodayTVsPage({super.key});

  @override
  State<AiringTodayTVsPage> createState() => _AiringTodayTVsPageState();
}

class _AiringTodayTVsPageState extends State<AiringTodayTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<AiringTodayTVsBloc>().add(FetchAiringTodayTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airing Today TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTVsBloc, AiringTodayTVsState>(
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
