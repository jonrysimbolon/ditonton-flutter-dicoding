import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularMovies extends PopularMoviesEvent {}

class PopularMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const PopularMoviesState({
    this.state = RequestState.empty,
    this.movies = const [],
    this.message = '',
  });

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(const PopularMoviesState()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (moviesData) => emit(
          state.copyWith(state: RequestState.loaded, movies: moviesData),
        ),
      );
    });
  }
}
