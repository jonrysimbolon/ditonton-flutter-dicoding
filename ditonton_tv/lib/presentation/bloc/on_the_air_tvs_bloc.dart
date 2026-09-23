import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTVsEvent extends Equatable {
  const OnTheAirTVsEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnTheAirTVs extends OnTheAirTVsEvent {}

class OnTheAirTVsState extends Equatable {
  final RequestState state;
  final List<TV> tvs;
  final String message;

  const OnTheAirTVsState({
    this.state = RequestState.empty,
    this.tvs = const [],
    this.message = '',
  });

  OnTheAirTVsState copyWith({
    RequestState? state,
    List<TV>? tvs,
    String? message,
  }) {
    return OnTheAirTVsState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvs, message];
}

class OnTheAirTVsBloc extends Bloc<OnTheAirTVsEvent, OnTheAirTVsState> {
  final GetOnTheAirTVs getOnTheAirTvs;

  OnTheAirTVsBloc({required this.getOnTheAirTvs})
    : super(const OnTheAirTVsState()) {
    on<FetchOnTheAirTVs>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getOnTheAirTvs.execute();
      result.fold(
        (failure) => emit(
          state.copyWith(state: RequestState.error, message: failure.message),
        ),
        (tvsData) =>
            emit(state.copyWith(state: RequestState.loaded, tvs: tvsData)),
      );
    });
  }
}
