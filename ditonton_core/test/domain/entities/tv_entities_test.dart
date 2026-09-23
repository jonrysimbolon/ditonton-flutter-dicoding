import 'package:ditonton_core/domain/entities/episode.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_core/domain/entities/season.dart';
import 'package:ditonton_core/domain/entities/season_detail.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV supports value equality and watchlist constructor', () {
    const tvA = TV(
      backdropPath: 'backdrop',
      firstAirDate: '2023-01-01',
      genreIds: [1],
      id: 1,
      name: 'name',
      originCountry: ['US'],
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'poster',
      voteAverage: 8.0,
      voteCount: 10,
    );
    const tvB = TV(
      backdropPath: 'backdrop',
      firstAirDate: '2023-01-01',
      genreIds: [1],
      id: 1,
      name: 'name',
      originCountry: ['US'],
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1.0,
      posterPath: 'poster',
      voteAverage: 8.0,
      voteCount: 10,
    );
    expect(tvA, tvB);
    expect(tvA.props.length, 12);

    const watchlist = TV.watchlist(
      id: 1,
      overview: 'overview',
      posterPath: 'poster',
      name: 'name',
    );
    expect(watchlist.id, 1);
    expect(watchlist.name, 'name');
    expect(watchlist.props.length, 12);
  });

  test('TVDetail supports value equality', () {
    TVDetail make() => const TVDetail(
      backdropPath: 'backdrop',
      firstAirDate: '2021-01-01',
      genres: [Genre(id: 1, name: 'Drama')],
      id: 1,
      lastAirDate: '2023-01-01',
      name: 'name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'poster',
      seasons: [
        Season(
          airDate: '2021-01-01',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'overview',
          posterPath: 'poster',
          seasonNumber: 1,
          voteAverage: 8.0,
        ),
      ],
      status: 'Returning Series',
      tagline: 'tagline',
      type: 'Scripted',
      voteAverage: 8.0,
      voteCount: 100,
    );
    expect(make(), make());
    expect(make().props.length, 17);
  });

  test('Season, Episode and SeasonDetail support value equality', () {
    const season = Season(
      airDate: '2021-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: 'poster',
      seasonNumber: 1,
      voteAverage: 8.0,
    );
    expect(season.props.length, 8);

    const episode = Episode(
      airDate: '2021-01-01',
      episodeNumber: 1,
      id: 1,
      name: 'Pilot',
      overview: 'overview',
      runtime: 55,
      seasonNumber: 1,
      stillPath: 'still',
      voteAverage: 8.0,
      voteCount: 10,
    );
    expect(episode.props.length, 10);

    const detail = SeasonDetail(
      airDate: '2021-01-01',
      episodes: [episode],
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: 'poster',
      seasonNumber: 1,
    );
    expect(detail.props.length, 7);
    expect(detail.episodes, [episode]);
  });
}
