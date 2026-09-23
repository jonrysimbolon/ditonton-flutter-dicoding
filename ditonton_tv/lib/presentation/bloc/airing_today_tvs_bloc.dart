import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiringTodayTVsEvent extends Equatable {
  const AiringTodayTVsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAiringTodayTVs extends AiringTodayTVsEvent {}

class AiringTodayTVsState extends Equatable {
  final RequestState state;
  final List<TV> tvs;
  final String message;

  const AiringTodayTVsState({
    this.state = RequestState.empty,
    this.tvs = const [],
    this.message = '',
  });

  AiringTodayTVsState copyWith({
    RequestState? state,
    List<TV>? tvs,
    String? message,
  }) {
    return AiringTodayTVsState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvs, message];
}

class AiringTodayTVsBloc
    extends Bloc<AiringTodayTVsEvent, AiringTodayTVsState> {
  final GetAiringTodayTVs getAiringTodayTvs;

  AiringTodayTVsBloc({required this.getAiringTodayTvs})
    : super(const AiringTodayTVsState()) {
    on<FetchAiringTodayTVs>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getAiringTodayTvs.execute();
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
