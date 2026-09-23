import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/season_detail.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVDetailEvent extends Equatable {
  const TVDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTVDetail extends TVDetailEvent {
  final int id;

  const FetchTVDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchSeasonDetail extends TVDetailEvent {
  final int id;
  final int seasonNumber;

  const FetchSeasonDetail(this.id, this.seasonNumber);

  @override
  List<Object?> get props => [id, seasonNumber];
}

class AddTVWatchlist extends TVDetailEvent {
  final TVDetail tv;

  const AddTVWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class RemoveTVWatchlist extends TVDetailEvent {
  final TVDetail tv;

  const RemoveTVWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class LoadTVWatchlistStatus extends TVDetailEvent {
  final int id;

  const LoadTVWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class TVDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final TVDetail? tv;
  final RequestState tvState;
  final List<TV> tvRecommendations;
  final RequestState recommendationState;
  final SeasonDetail? seasonDetail;
  final RequestState seasonDetailState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TVDetailState({
    this.tv,
    this.tvState = RequestState.empty,
    this.tvRecommendations = const [],
    this.recommendationState = RequestState.empty,
    this.seasonDetail,
    this.seasonDetailState = RequestState.empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TVDetailState copyWith({
    TVDetail? tv,
    RequestState? tvState,
    List<TV>? tvRecommendations,
    RequestState? recommendationState,
    SeasonDetail? seasonDetail,
    RequestState? seasonDetailState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TVDetailState(
      tv: tv ?? this.tv,
      tvState: tvState ?? this.tvState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      seasonDetail: seasonDetail ?? this.seasonDetail,
      seasonDetailState: seasonDetailState ?? this.seasonDetailState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tv,
    tvState,
    tvRecommendations,
    recommendationState,
    seasonDetail,
    seasonDetailState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  final GetTVDetail getTvDetail;
  final GetTVRecommendations getTvRecommendations;
  final GetSeasonDetail getSeasonDetail;
  final GetWatchlistTVStatus getWatchlistTvStatus;
  final SaveWatchlistTV saveWatchlistTv;
  final RemoveWatchlistTV removeWatchlistTv;

  TVDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getSeasonDetail,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(const TVDetailState()) {
    on<FetchTVDetail>((event, emit) async {
      emit(state.copyWith(tvState: RequestState.loading));

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendations.execute(event.id);

      detailResult.fold(
        (failure) => emit(
          state.copyWith(tvState: RequestState.error, message: failure.message),
        ),
        (tv) {
          emit(
            state.copyWith(tv: tv, recommendationState: RequestState.loading),
          );

          recommendationResult.fold(
            (failure) => emit(
              state.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ),
            ),
            (tvs) => emit(
              state.copyWith(
                tvRecommendations: tvs,
                recommendationState: RequestState.loaded,
              ),
            ),
          );

          emit(state.copyWith(tvState: RequestState.loaded));
        },
      );
    });

    on<FetchSeasonDetail>((event, emit) async {
      emit(state.copyWith(seasonDetailState: RequestState.loading));

      final result = await getSeasonDetail.execute(
        event.id,
        event.seasonNumber,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            seasonDetailState: RequestState.error,
            message: failure.message,
          ),
        ),
        (data) => emit(
          state.copyWith(
            seasonDetail: data,
            seasonDetailState: RequestState.loaded,
          ),
        ),
      );
    });

    on<AddTVWatchlist>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tv);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      await _loadWatchlistStatus(event.tv.id, emit);
    });

    on<RemoveTVWatchlist>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tv);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      await _loadWatchlistStatus(event.tv.id, emit);
    });

    on<LoadTVWatchlistStatus>((event, emit) async {
      await _loadWatchlistStatus(event.id, emit);
    });
  }

  Future<void> _loadWatchlistStatus(int id, Emitter<TVDetailState> emit) async {
    final result = await getWatchlistTvStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
