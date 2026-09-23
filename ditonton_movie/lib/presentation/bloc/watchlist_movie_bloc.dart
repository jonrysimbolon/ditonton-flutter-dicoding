import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistMovies extends WatchlistMovieEvent {
  const FetchWatchlistMovies();
}

class WatchlistMovieState extends Equatable {
  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  const WatchlistMovieState({
    this.watchlistMovies = const [],
    this.watchlistState = RequestState.empty,
    this.message = '',
  });

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistMovies, watchlistState, message];
}

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
    : super(const WatchlistMovieState()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(state.copyWith(watchlistState: RequestState.loading));

      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            watchlistState: RequestState.error,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            watchlistState: RequestState.loaded,
            watchlistMovies: moviesData,
          ),
        ),
      );
    });
  }
}
