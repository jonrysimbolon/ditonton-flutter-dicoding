import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieSearch extends MovieSearchEvent {
  final String query;

  const FetchMovieSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class MovieSearchState extends Equatable {
  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  const MovieSearchState({
    this.state = RequestState.empty,
    this.searchResult = const [],
    this.message = '',
  });

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
    : super(const MovieSearchState()) {
    on<FetchMovieSearch>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (data) => emit(
          state.copyWith(searchResult: data, state: RequestState.loaded),
        ),
      );
    });
  }
}
