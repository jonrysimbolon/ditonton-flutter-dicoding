import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:flutter/foundation.dart';

class OnTheAirTVsNotifier extends ChangeNotifier {
  final GetOnTheAirTVs getOnTheAirTvs;

  OnTheAirTVsNotifier({required this.getOnTheAirTvs});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TV> _tvs = [];
  List<TV> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirTvs() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();

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
