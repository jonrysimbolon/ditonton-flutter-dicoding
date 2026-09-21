import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/airing_today_tvs_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Provider.of<AiringTodayTVsNotifier>(
        context,
        listen: false,
      ).fetchAiringTodayTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Airing Today TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AiringTodayTVsNotifier>(
          builder: (_, data, _) {
            if (data.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvs[index];
                  return TVCard(tv);
                },
                itemCount: data.tvs.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
