import 'dart:async';

import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounceDuration = Duration(milliseconds: 500);

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String query) {
    context.read<MovieSearchBloc>().add(FetchMovieSearch(query));
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  void _onSubmitted(String query) {
    _debounce?.cancel();
    _search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: heading6),
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == RequestState.loaded) {
                  final result = state.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.searchResult[index];
                        return MovieCard(movie);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else {
                  return const Expanded(child: SizedBox.shrink());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
