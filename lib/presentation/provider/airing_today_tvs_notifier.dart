import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:flutter/foundation.dart';

class AiringTodayTVsNotifier extends ChangeNotifier {
  final GetAiringTodayTVs getAiringTodayTvs;

  AiringTodayTVsNotifier({required this.getAiringTodayTvs});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TV> _tvs = [];
  List<TV> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchAiringTodayTvs() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getAiringTodayTvs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvsData) {
        _tvs = tvsData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
