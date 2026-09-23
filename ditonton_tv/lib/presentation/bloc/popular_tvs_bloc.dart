import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTVsEvent extends Equatable {
  const PopularTVsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularTVs extends PopularTVsEvent {}

class PopularTVsState extends Equatable {
  final RequestState state;
  final List<TV> tvs;
  final String message;

  const PopularTVsState({
    this.state = RequestState.empty,
    this.tvs = const [],
    this.message = '',
  });

  PopularTVsState copyWith({
    RequestState? state,
    List<TV>? tvs,
    String? message,
  }) {
    return PopularTVsState(
      state: state ?? this.state,
      tvs: tvs ?? this.tvs,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, tvs, message];
}

class PopularTVsBloc extends Bloc<PopularTVsEvent, PopularTVsState> {
  final GetPopularTVs getPopularTvs;

  PopularTVsBloc(this.getPopularTvs) : super(const PopularTVsState()) {
    on<FetchPopularTVs>((event, emit) async {
      emit(state.copyWith(state: RequestState.loading));

      final result = await getPopularTvs.execute();
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
