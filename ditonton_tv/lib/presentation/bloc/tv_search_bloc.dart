import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/search_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSearchEvent extends Equatable {
  const TVSearchEvent();

  @override
  List<Object?> get props => [];
}

class FetchTVSearch extends TVSearchEvent {
  final String query;

  const FetchTVSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class TVSearchState extends Equatable {
  final RequestState state;
  final List<TV> searchResult;
  final String message;

  const TVSearchState({
    this.state = RequestState.empty,
    this.searchResult = const [],
    this.message = '',
  });

  TVSearchState copyWith({
    RequestState? state,
    List<TV>? searchResult,
    String? message,
  }) {
    return TVSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, searchResult, message];
}

class TVSearchBloc extends Bloc<TVSearchEvent, TVSearchState> {
  final SearchTVs searchTvs;

  TVSearchBloc({required this.searchTvs}) : super(const TVSearchState()) {
    on<FetchTVSearch>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await searchTvs.execute(event.query);
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
