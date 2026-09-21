import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            Consumer<TVListNotifier>(
              builder: (_, data, _) {
                final state = data.airingTodayState;
                if (state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TVList(data.airingTodayTvs);
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
            Consumer<TVListNotifier>(
              builder: (_, data, _) {
                final state = data.onTheAirState;
                if (state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TVList(data.onTheAirTvs);
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
            Consumer<TVListNotifier>(
              builder: (_, data, _) {
                final state = data.popularTvsState;
                if (state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TVList(data.popularTvs);
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
            Consumer<TVListNotifier>(
              builder: (_, data, _) {
                final state = data.topRatedTvsState;
                if (state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state == RequestState.loaded) {
                  return TVList(data.topRatedTvs);
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
