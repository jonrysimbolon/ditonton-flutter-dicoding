import 'package:ditonton_core/common/api_config.dart';
import 'package:ditonton_core/common/connection_failure.dart';
import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/database_exception.dart';
import 'package:ditonton_core/common/database_failure.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/common/server_exception.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_core/data/models/genre_model.dart';
import 'package:ditonton_core/data/models/movie_table.dart';
import 'package:ditonton_core/data/models/tv_table.dart';
import 'package:ditonton_core/domain/entities/episode.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_core/domain/entities/movie_detail.dart';
import 'package:ditonton_core/domain/entities/season.dart';
import 'package:ditonton_core/domain/entities/season_detail.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_core/presentation/pages/home_section.dart';
import 'package:ditonton_core/presentation/widgets/empty_watchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('common', () {
    test('api config exposes non-empty defaults', () {
      expect(tmdbBaseUrl, 'https://api.themoviedb.org/3');
      expect(tmdbApiKey, isNotEmpty);
    });

    test('constants expose expected values', () {
      expect(baseImageUrl, 'https://image.tmdb.org/t/p/w500');
      expect(richBlack, const Color(0xFF000814));
      expect(prussianBlue, const Color(0xFF003566));
      expect(mikadoYellow, const Color(0xFFffc300));
      expect(davysGrey, const Color(0xFF4B5358));
      expect(colorScheme.primary, mikadoYellow);
      expect(colorScheme.surface, richBlack);
      expect(drawerTheme.backgroundColor, Colors.grey.shade700);
    });

    test('utils exposes a route observer', () {
      expect(routeObserver, isA<RouteObserver<ModalRoute>>());
    });

    test('request state enum exposes all values', () {
      expect(RequestState.values, [
        RequestState.empty,
        RequestState.loading,
        RequestState.loaded,
        RequestState.error,
      ]);
    });

    test('failures carry a message', () {
      const values = [
        ConnectionFailure('conn'),
        ServerFailure('server'),
        DatabaseFailure('database'),
      ];
      for (final failure in values) {
        expect(failure, isA<Failure>());
        expect(failure.props, [isNotEmpty]);
      }
    });

    test('exceptions can be constructed', () {
      final server = ServerException();
      final database = DatabaseException('db');
      expect(server, isA<ServerException>());
      expect(database.message, 'db');
    });
  });

  group('homeSection', () {
    test('exposes all sections', () {
      expect(HomeSection.values, [
        HomeSection.movies,
        HomeSection.tvSeries,
        HomeSection.watchlist,
        HomeSection.about,
      ]);
    });
  });

  group('GenreModel', () {
    const model = GenreModel(id: 1, name: 'Action');

    test('fromJson', () {
      expect(GenreModel.fromJson(const {'id': 1, 'name': 'Action'}), model);
    });

    test('toJson', () {
      expect(model.toJson(), {'id': 1, 'name': 'Action'});
    });

    test('toEntity', () {
      expect(model.toEntity(), const Genre(id: 1, name: 'Action'));
    });
  });

  group('MovieTable', () {
    const movie = Movie(
      adult: null,
      backdropPath: null,
      genreIds: null,
      id: 1,
      originalTitle: null,
      overview: 'overview',
      popularity: null,
      posterPath: '/poster',
      releaseDate: null,
      title: 'title',
      video: null,
      voteAverage: null,
      voteCount: null,
    );

    const detail = MovieDetail(
      adult: false,
      backdropPath: null,
      genres: [],
      id: 1,
      originalTitle: 'original',
      overview: 'overview',
      posterPath: '/poster',
      releaseDate: '2023-01-01',
      runtime: 90,
      title: 'title',
      voteAverage: 7,
      voteCount: 100,
    );

    test('fromEntity', () {
      final table = MovieTable.fromEntity(detail);
      expect(table.id, 1);
      expect(table.title, 'title');
      expect(table.overview, 'overview');
      expect(table.posterPath, '/poster');
    });

    test('fromMap', () {
      final table = MovieTable.fromMap(const {
        'id': 1,
        'title': 'title',
        'posterPath': '/poster',
        'overview': 'overview',
      });
      expect(
        table,
        const MovieTable(
          id: 1,
          title: 'title',
          posterPath: '/poster',
          overview: 'overview',
        ),
      );
    });

    test('toJson', () {
      const table = MovieTable(
        id: 1,
        title: 'title',
        posterPath: '/poster',
        overview: 'overview',
      );
      expect(table.toJson(), {
        'id': 1,
        'title': 'title',
        'posterPath': '/poster',
        'overview': 'overview',
      });
    });

    test('toEntity', () {
      const table = MovieTable(
        id: 1,
        title: 'title',
        posterPath: '/poster',
        overview: 'overview',
      );
      expect(table.toEntity(), movie);
    });
  });

  group('TVTable', () {
    const tv = TV(
      backdropPath: null,
      firstAirDate: null,
      genreIds: null,
      id: 1,
      name: 'name',
      originCountry: null,
      originalName: null,
      overview: 'overview',
      popularity: null,
      posterPath: '/poster',
      voteAverage: null,
      voteCount: null,
    );

    const detail = TVDetail(
      backdropPath: null,
      firstAirDate: '2023-01-01',
      genres: [],
      id: 1,
      lastAirDate: null,
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'original',
      overview: 'overview',
      posterPath: '/poster',
      seasons: [],
      status: 'Ended',
      tagline: '',
      type: 'Scripted',
      voteAverage: 7,
      voteCount: 100,
    );

    test('fromEntity', () {
      final table = TVTable.fromEntity(detail);
      expect(table.id, 1);
      expect(table.name, 'name');
      expect(table.overview, 'overview');
      expect(table.posterPath, '/poster');
    });

    test('fromMap', () {
      final table = TVTable.fromMap(const {
        'id': 1,
        'name': 'name',
        'posterPath': '/poster',
        'overview': 'overview',
      });
      expect(
        table,
        const TVTable(
          id: 1,
          name: 'name',
          posterPath: '/poster',
          overview: 'overview',
        ),
      );
    });

    test('toJson', () {
      const table = TVTable(
        id: 1,
        name: 'name',
        posterPath: '/poster',
        overview: 'overview',
      );
      expect(table.toJson(), {
        'id': 1,
        'name': 'name',
        'posterPath': '/poster',
        'overview': 'overview',
      });
    });

    test('toEntity', () {
      const table = TVTable(
        id: 1,
        name: 'name',
        posterPath: '/poster',
        overview: 'overview',
      );
      expect(table.toEntity(), tv);
    });
  });

  group('entities', () {
    const genre = Genre(id: 1, name: 'Action');
    const movieDetail = MovieDetail(
      adult: false,
      backdropPath: '/backdrop',
      genres: [genre],
      id: 1,
      originalTitle: 'original',
      overview: 'overview',
      posterPath: '/poster',
      releaseDate: '2023-01-01',
      runtime: 90,
      title: 'title',
      voteAverage: 7,
      voteCount: 100,
    );
    const season = Season(
      airDate: '2023-01-01',
      episodeCount: 10,
      id: 1,
      name: 'season',
      overview: 'overview',
      posterPath: '/poster',
      seasonNumber: 1,
      voteAverage: 7,
    );
    const episode = Episode(
      airDate: '2023-01-01',
      episodeNumber: 1,
      id: 1,
      name: 'episode',
      overview: 'overview',
      runtime: 45,
      seasonNumber: 1,
      stillPath: '/still',
      voteAverage: 7,
      voteCount: 100,
    );
    const seasonDetail = SeasonDetail(
      airDate: '2023-01-01',
      episodes: [episode],
      id: 1,
      name: 'season detail',
      overview: 'overview',
      posterPath: '/poster',
      seasonNumber: 1,
    );
    const tvDetail = TVDetail(
      backdropPath: '/backdrop',
      firstAirDate: '2023-01-01',
      genres: [genre],
      id: 1,
      lastAirDate: '2023-12-01',
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'original',
      overview: 'overview',
      posterPath: '/poster',
      seasons: [season],
      status: 'Ended',
      tagline: 'tagline',
      type: 'Scripted',
      voteAverage: 7,
      voteCount: 100,
    );

    test('movie entity equality', () {
      const watchlistMovie = Movie.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: '/poster',
        title: 'title',
      );
      expect(watchlistMovie.id, 1);
      expect(watchlistMovie.title, 'title');
    });

    test('movie detail entity', () {
      expect(movieDetail.title, 'title');
      expect(movieDetail.genres, [genre]);
      expect(movieDetail == movieDetail, isTrue);
      expect(movieDetail.props, isNotEmpty);
    });

    test('tv entities expose props', () {
      expect(tvDetail.name, 'name');
      expect(tvDetail.seasons, [season]);
      expect(seasonDetail.episodes.first.id, episode.id);
      expect(episode.name, 'episode');
      const watchlistTv = TV.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: '/poster',
        name: 'name',
      );
      expect(watchlistTv.id, 1);
      expect(watchlistTv.name, 'name');
      expect(tvDetail == tvDetail, isTrue);
      expect(season == season, isTrue);
      expect(episode == episode, isTrue);
      expect(seasonDetail == seasonDetail, isTrue);
      expect(tvDetail.props, isNotEmpty);
      expect(season.props, isNotEmpty);
      expect(episode.props, isNotEmpty);
      expect(seasonDetail.props, isNotEmpty);
    });
  });

  group('EmptyWatchlist', () {
    testWidgets('renders icon, title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyWatchlist(
              icon: Icons.playlist_remove,
              title: 'Empty',
              message: 'No data available',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.playlist_remove), findsOneWidget);
      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('No data available'), findsOneWidget);
    });
  });
}
