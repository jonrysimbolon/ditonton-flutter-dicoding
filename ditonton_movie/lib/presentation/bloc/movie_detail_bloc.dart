import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_core/domain/entities/movie_detail.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movie/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveMovieWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class LoadMovieWatchlistStatus extends MovieDetailEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class MovieDetailState extends Equatable {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movie,
    this.movieState = RequestState.empty,
    this.movieRecommendations = const [],
    this.recommendationState = RequestState.empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieDetail? movie,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    movieState,
    movieRecommendations,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieState: RequestState.loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult = await getMovieRecommendations.execute(
        event.id,
      );

      detailResult.fold(
        (failure) => emit(
          state.copyWith(
            movieState: RequestState.error,
            message: failure.message,
          ),
        ),
        (movie) {
          emit(
            state.copyWith(
              movie: movie,
              recommendationState: RequestState.loading,
            ),
          );

          recommendationResult.fold(
            (failure) => emit(
              state.copyWith(
                recommendationState: RequestState.error,
                message: failure.message,
              ),
            ),
            (movies) => emit(
              state.copyWith(
                movieRecommendations: movies,
                recommendationState: RequestState.loaded,
              ),
            ),
          );

          emit(state.copyWith(movieState: RequestState.loaded));
        },
      );
    });

    on<AddMovieWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      await _loadWatchlistStatus(event.movie.id, emit);
    });

    on<RemoveMovieWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      await result.fold(
        (failure) async {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) async {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      await _loadWatchlistStatus(event.movie.id, emit);
    });

    on<LoadMovieWatchlistStatus>((event, emit) async {
      await _loadWatchlistStatus(event.id, emit);
    });
  }

  Future<void> _loadWatchlistStatus(
    int id,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
