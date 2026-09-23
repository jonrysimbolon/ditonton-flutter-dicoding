import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTVsEvent extends Equatable {
  const TopRatedTVsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopRatedTVs extends TopRatedTVsEvent {}

class TopRatedTVsState extends Equatable {
  final RequestState state;
  final List<TV> tvs;
  final String message;

  const TopRatedTVsState({
    this.state = RequestState.empty,
    this.tvs = const [],
    this.message = '',
  });

  TopRatedTVsState copyWith({
    RequestState? state,
    List<TV>? tvs,
    String? message,
  }) {
    return TopRatedTVsState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvs, message];
}

class TopRatedTVsBloc extends Bloc<TopRatedTVsEvent, TopRatedTVsState> {
  final GetTopRatedTVs getTopRatedTvs;

  TopRatedTVsBloc({required this.getTopRatedTvs})
    : super(const TopRatedTVsState()) {
    on<FetchTopRatedTVs>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getTopRatedTvs.execute();
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
