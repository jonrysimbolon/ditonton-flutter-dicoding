import 'dart:async';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    Provider.of<TVSearchNotifier>(context, listen: false).fetchTvSearch(query);
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
            Consumer<TVSearchNotifier>(
              builder: (_, data, _) {
                if (data.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (data.state == RequestState.loaded) {
                  final result = data.searchResult;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final tv = data.searchResult[index];
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
