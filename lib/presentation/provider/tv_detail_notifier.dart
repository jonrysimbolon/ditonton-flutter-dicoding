import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TVDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTvDetail;
  final GetTVRecommendations getTvRecommendations;
  final GetSeasonDetail getSeasonDetail;
  final GetWatchlistTVStatus getWatchlistTvStatus;
  final SaveWatchlistTV saveWatchlistTv;
  final RemoveWatchlistTV removeWatchlistTv;

  TVDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getSeasonDetail,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TVDetail _tv;
  TVDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendations = [];
  List<TV> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  SeasonDetail? _seasonDetail;
  SeasonDetail? get seasonDetail => _seasonDetail;

  RequestState _seasonDetailState = RequestState.empty;
  RequestState get seasonDetailState => _seasonDetailState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.loading;
        _tv = tv;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = tvs;
          },
        );
        _tvState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchSeasonDetail(int id, int seasonNumber) async {
    _seasonDetailState = RequestState.loading;
    notifyListeners();

    final result = await getSeasonDetail.execute(id, seasonNumber);
    result.fold(
      (failure) {
        _seasonDetailState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _seasonDetailState = RequestState.loaded;
        _seasonDetail = data;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVDetail tv) async {
    final result = await saveWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TVDetail tv) async {
    final result = await removeWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistTvStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
