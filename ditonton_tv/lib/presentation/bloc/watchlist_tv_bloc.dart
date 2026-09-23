import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTVEvent extends Equatable {
  const WatchlistTVEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistTVs extends WatchlistTVEvent {
  const FetchWatchlistTVs();
}

class WatchlistTVState extends Equatable {
  final List<TV> watchlistTvs;
  final RequestState watchlistState;
  final String message;

  const WatchlistTVState({
    this.watchlistTvs = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
  });

  WatchlistTVState copyWith({
    List<TV>? watchlistTvs,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistTVState(
      watchlistTvs: watchlistTvs ?? this.watchlistTvs,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistTvs, watchlistState, message];
}

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTVs getWatchlistTvs;

  WatchlistTVBloc({required this.getWatchlistTvs})
    : super(const WatchlistTVState()) {
    on<FetchWatchlistTVs>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.loading));

      final result = await getWatchlistTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            watchlistState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvsData) => emit(
          state.copyWith(
            watchlistState: RequestState.loaded,
            watchlistTvs: tvsData,
          ),
        ),
      );
    });
  }
}
