import 'dart:async';

import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTVPage extends StatefulWidget {
  static const routeName = '/search-tv';

  const SearchTVPage({super.key});

  @override
  State<SearchTVPage> createState() => _SearchTVPageState();
}

class _SearchTVPageState extends State<SearchTVPage> {
  static const _debounceDuration = Duration(milliseconds: 500);

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String query) {
    context.read<TVSearchBloc>().add(FetchTVSearch(query));
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
      appBar: AppBar(title: const Text('Search TV Series')),
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
            BlocBuilder<TVSearchBloc, TVSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == RequestState.loaded) {
                  final result = state.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = state.searchResult[index];
                        return TVCard(tv);
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
