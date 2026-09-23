import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVsPage extends StatefulWidget {
  static const routeName = '/on-the-air-tv';

  const OnTheAirTVsPage({super.key});

  @override
  State<OnTheAirTVsPage> createState() => _OnTheAirTVsPageState();
}

class _OnTheAirTVsPageState extends State<OnTheAirTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<OnTheAirTVsBloc>().add(FetchOnTheAirTVs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTVsBloc, OnTheAirTVsState>(
          builder: (context, state) {
            if (state.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (_, index) {
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
