import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesContent extends StatelessWidget {
  const TVSeriesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _tvSubHeading(
              title: 'Airing Today',
              onTap: () {
                Navigator.pushNamed(context, AiringTodayTVsPage.routeName);
              },
            ),
            BlocBuilder<TVListBloc, TVListState>(
              builder: (context, state) {
                if (state.airingTodayState == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.airingTodayState == RequestState.loaded) {
                  return TVList(state.airingTodayTvs);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _tvSubHeading(
              title: 'On The Air',
              onTap: () {
                Navigator.pushNamed(context, OnTheAirTVsPage.routeName);
              },
            ),
            BlocBuilder<TVListBloc, TVListState>(
              builder: (context, state) {
                if (state.onTheAirState == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.onTheAirState == RequestState.loaded) {
                  return TVList(state.onTheAirTvs);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _tvSubHeading(
              title: 'Popular',
              onTap: () {
                Navigator.pushNamed(context, PopularTVsPage.routeName);
              },
            ),
            BlocBuilder<TVListBloc, TVListState>(
              builder: (context, state) {
                if (state.popularTvsState == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.popularTvsState == RequestState.loaded) {
                  return TVList(state.popularTvs);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _tvSubHeading(
              title: 'Top Rated',
              onTap: () {
                Navigator.pushNamed(context, TopRatedTVsPage.routeName);
              },
            ),
            BlocBuilder<TVListBloc, TVListState>(
              builder: (context, state) {
                if (state.topRatedTvsState == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.topRatedTvsState == RequestState.loaded) {
                  return TVList(state.topRatedTvs);
                } else {
                  return const Text('Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _tvSubHeading({required String title, required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: heading6),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
