import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVListEvent extends Equatable {
  const TVListEvent();

  @override
  List<Object?> get props => [];
}

class FetchAiringTodayTvsList extends TVListEvent {
  const FetchAiringTodayTvsList();
}

class FetchOnTheAirTvsList extends TVListEvent {
  const FetchOnTheAirTvsList();
}

class FetchPopularTvsList extends TVListEvent {
  const FetchPopularTvsList();
}

class FetchTopRatedTvsList extends TVListEvent {
  const FetchTopRatedTvsList();
}

class TVListState extends Equatable {
  final List<TV> airingTodayTvs;
  final RequestState airingTodayState;
  final List<TV> onTheAirTvs;
  final RequestState onTheAirState;
  final List<TV> popularTvs;
  final RequestState popularTvsState;
  final List<TV> topRatedTvs;
  final RequestState topRatedTvsState;
  final String message;

  const TVListState({
    this.airingTodayTvs = const [],
    this.airingTodayState = RequestState.empty,
    this.onTheAirTvs = const [],
    this.onTheAirState = RequestState.empty,
    this.popularTvs = const [],
    this.popularTvsState = RequestState.empty,
    this.topRatedTvs = const [],
    this.topRatedTvsState = RequestState.empty,
    this.message = '',
  });

  TVListState copyWith({
    List<TV>? airingTodayTvs,
    RequestState? airingTodayState,
    List<TV>? onTheAirTvs,
    RequestState? onTheAirState,
    List<TV>? popularTvs,
    RequestState? popularTvsState,
    List<TV>? topRatedTvs,
    RequestState? topRatedTvsState,
    String? message,
  }) {
    return TVListState(
      airingTodayTvs: airingTodayTvs ?? this.airingTodayTvs,
      airingTodayState: airingTodayState ?? this.airingTodayState,
      onTheAirTvs: onTheAirTvs ?? this.onTheAirTvs,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularTvs: popularTvs ?? this.popularTvs,
      popularTvsState: popularTvsState ?? this.popularTvsState,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      topRatedTvsState: topRatedTvsState ?? this.topRatedTvsState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    airingTodayTvs,
    airingTodayState,
    onTheAirTvs,
    onTheAirState,
    popularTvs,
    popularTvsState,
    topRatedTvs,
    topRatedTvsState,
    message,
  ];
}

class TVListBloc extends Bloc<TVListEvent, TVListState> {
  final GetAiringTodayTVs getAiringTodayTvs;
  final GetOnTheAirTVs getOnTheAirTvs;
  final GetPopularTVs getPopularTvs;
  final GetTopRatedTVs getTopRatedTvs;

  TVListBloc({
    required this.getAiringTodayTvs,
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TVListState()) {
    on<FetchAiringTodayTvsList>((event, emit) async {
      emit(state.copyWith(airingTodayState: RequestState.loading));

      final result = await getAiringTodayTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            airingTodayState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvsData) => emit(
          state.copyWith(
            airingTodayTvs: tvsData,
            airingTodayState: RequestState.loaded,
          ),
        ),
      );
    });

    on<FetchOnTheAirTvsList>((event, emit) async {
      emit(state.copyWith(onTheAirState: RequestState.loading));

      final result = await getOnTheAirTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            onTheAirState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvsData) => emit(
          state.copyWith(
            onTheAirTvs: tvsData,
            onTheAirState: RequestState.loaded,
          ),
        ),
      );
    });

    on<FetchPopularTvsList>((event, emit) async {
      emit(state.copyWith(popularTvsState: RequestState.loading));

      final result = await getPopularTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            popularTvsState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvsData) => emit(
          state.copyWith(
            popularTvs: tvsData,
            popularTvsState: RequestState.loaded,
          ),
        ),
      );
    });

    on<FetchTopRatedTvsList>((event, emit) async {
      emit(state.copyWith(topRatedTvsState: RequestState.loading));

      final result = await getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(
            topRatedTvsState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvsData) => emit(
          state.copyWith(
            topRatedTvs: tvsData,
            topRatedTvsState: RequestState.loaded,
          ),
        ),
      );
    });
  }
}
