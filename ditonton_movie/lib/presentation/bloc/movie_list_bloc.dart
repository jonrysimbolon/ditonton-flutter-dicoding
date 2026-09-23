import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object?> get props => [];
}

class FetchNowPlayingMovies extends MovieListEvent {
  const FetchNowPlayingMovies();
}

class FetchPopularMoviesList extends MovieListEvent {
  const FetchPopularMoviesList();
}

class FetchTopRatedMoviesList extends MovieListEvent {
  const FetchTopRatedMoviesList();
}

class MovieListState extends Equatable {
  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingState;
  final List<Movie> popularMovies;
  final RequestState popularMoviesState;
  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;
  final String message;

  const MovieListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingState = RequestState.empty,
    this.popularMovies = const [],
    this.popularMoviesState = RequestState.empty,
    this.topRatedMovies = const [],
    this.topRatedMoviesState = RequestState.empty,
    this.message = '',
  });

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingState,
    List<Movie>? popularMovies,
    RequestState? popularMoviesState,
    List<Movie>? topRatedMovies,
    RequestState? topRatedMoviesState,
    String? message,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    nowPlayingMovies,
    nowPlayingState,
    popularMovies,
    popularMoviesState,
    topRatedMovies,
    topRatedMoviesState,
    message,
  ];
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(state.copyWith(nowPlayingState: RequestState.loading));

      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            nowPlayingState: RequestState.error,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            nowPlayingMovies: moviesData,
            nowPlayingState: RequestState.loaded,
          ),
        ),
      );
    });

    on<FetchPopularMoviesList>((event, emit) async {
      emit(state.copyWith(popularMoviesState: RequestState.loading));

      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            popularMoviesState: RequestState.error,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            popularMovies: moviesData,
            popularMoviesState: RequestState.loaded,
          ),
        ),
      );
    });

    on<FetchTopRatedMoviesList>((event, emit) async {
      emit(state.copyWith(topRatedMoviesState: RequestState.loading));

      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            topRatedMoviesState: RequestState.error,
            message: failure.message,
          ),
        ),
        (moviesData) => emit(
          state.copyWith(
            topRatedMovies: moviesData,
            topRatedMoviesState: RequestState.loaded,
          ),
        ),
      );
    });
  }
}
