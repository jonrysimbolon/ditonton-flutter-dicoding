import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_series_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTVPage extends StatefulWidget {
  static const routeName = '/tv';

  const HomeTVPage({super.key});

  @override
  State<HomeTVPage> createState() => _HomeTVPageState();
}

class _HomeTVPageState extends State<HomeTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVListBloc>()
        ..add(const FetchAiringTodayTvsList())
        ..add(const FetchOnTheAirTvsList())
        ..add(const FetchPopularTvsList())
        ..add(const FetchTopRatedTvsList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchTVPage.routeName);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: const TVSeriesContent(),
    );
  }
}
