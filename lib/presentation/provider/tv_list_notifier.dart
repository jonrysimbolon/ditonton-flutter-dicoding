import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/material.dart';

class TVListNotifier extends ChangeNotifier {
  var _airingTodayTvs = <TV>[];
  List<TV> get airingTodayTvs => _airingTodayTvs;

  RequestState _airingTodayState = RequestState.empty;
  RequestState get airingTodayState => _airingTodayState;

  var _onTheAirTvs = <TV>[];
  List<TV> get onTheAirTvs => _onTheAirTvs;

  RequestState _onTheAirState = RequestState.empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTvs = <TV>[];
  List<TV> get popularTvs => _popularTvs;

  RequestState _popularTvsState = RequestState.empty;
  RequestState get popularTvsState => _popularTvsState;

  var _topRatedTvs = <TV>[];
  List<TV> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.empty;
  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getAiringTodayTvs,
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  });

  final GetAiringTodayTVs getAiringTodayTvs;
  final GetOnTheAirTVs getOnTheAirTvs;
  final GetPopularTVs getPopularTvs;
  final GetTopRatedTVs getTopRatedTvs;

  Future<void> fetchAiringTodayTvs() async {
    _airingTodayState = RequestState.loading;
    notifyListeners();

    final result = await getAiringTodayTvs.execute();
    result.fold(
      (failure) {
        _airingTodayState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _airingTodayState = RequestState.loaded;
        _airingTodayTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirState = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _onTheAirState = RequestState.loaded;
        _onTheAirTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        _popularTvsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _popularTvsState = RequestState.loaded;
        _popularTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        _topRatedTvsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTvsState = RequestState.loaded;
        _topRatedTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
