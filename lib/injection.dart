import 'package:ditonton_core/data/datasources/db/database_helper.dart';
import 'package:ditonton_movie/data/datasources/movie_local_data_source.dart';
import 'package:ditonton_movie/data/datasources/movie_local_data_source_impl.dart';
import 'package:ditonton_movie/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton_movie/data/datasources/movie_remote_data_source_impl.dart';
import 'package:ditonton_movie/data/repositories/movie_repository_impl.dart';
import 'package:ditonton_movie/domain/repositories/movie_repository.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movie/domain/usecases/search_movies.dart';
import "package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart";
import "package:ditonton_movie/presentation/bloc/movie_list_bloc.dart";
import "package:ditonton_movie/presentation/bloc/movie_search_bloc.dart";
import "package:ditonton_movie/presentation/bloc/popular_movies_bloc.dart";
import "package:ditonton_movie/presentation/bloc/top_rated_movies_bloc.dart";
import "package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart";
import 'package:ditonton_tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/data/datasources/tv_local_data_source_impl.dart';
import 'package:ditonton_tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/data/datasources/tv_remote_data_source_impl.dart';
import 'package:ditonton_tv/data/repositories/tv_repository_impl.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/search_tvs.dart';
import "package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart";
import "package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart";
import "package:ditonton_tv/presentation/bloc/popular_tvs_bloc.dart";
import "package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart";
import "package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart";
import "package:ditonton_tv/presentation/bloc/tv_list_bloc.dart";
import "package:ditonton_tv/presentation/bloc/tv_search_bloc.dart";
import "package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart";
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(
    () => TopRatedMoviesBloc(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieBloc(getWatchlistMovies: locator()),
  );
  locator.registerFactory(
    () => TVListBloc(
      getAiringTodayTvs: locator(),
      getOnTheAirTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TVDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getSeasonDetail: locator(),
      getWatchlistTvStatus: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
    ),
  );
  locator.registerFactory(() => TVSearchBloc(searchTvs: locator()));
  locator.registerFactory(() => PopularTVsBloc(locator()));
  locator.registerFactory(() => TopRatedTVsBloc(getTopRatedTvs: locator()));
  locator.registerFactory(
    () => AiringTodayTVsBloc(getAiringTodayTvs: locator()),
  );
  locator.registerFactory(() => OnTheAirTVsBloc(getOnTheAirTvs: locator()));
  locator.registerFactory(() => WatchlistTVBloc(getWatchlistTvs: locator()));

  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetAiringTodayTVs(locator()));
  locator.registerLazySingleton(() => GetOnTheAirTVs(locator()));
  locator.registerLazySingleton(() => GetPopularTVs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVs(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => GetSeasonDetail(locator()));
  locator.registerLazySingleton(() => SearchTVs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTV(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTV(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVs(locator()));

  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TVRemoteDataSource>(
    () => TVRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TVLocalDataSource>(
    () => TVLocalDataSourceImpl(databaseHelper: locator()),
  );

  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  locator.registerLazySingleton(() => http.Client());
}
