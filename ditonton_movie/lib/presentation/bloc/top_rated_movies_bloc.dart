import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopRatedMovies extends TopRatedMoviesEvent {}

class TopRatedMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const TopRatedMoviesState({
    this.state = RequestState.empty,
    this.movies = const [],
    this.message = '',
  });

  TopRatedMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return TopRatedMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies})
    : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getTopRatedMovies.execute();
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
