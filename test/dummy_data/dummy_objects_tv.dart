import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

const testTv = TV(
  backdropPath: '/backdrop1.jpg',
  firstAirDate: '2023-01-01',
  genreIds: [18, 80],
  id: 100,
  name: 'Test TV Airing Today',
  originCountry: ['US'],
  originalName: 'Test TV Airing Today',
  overview: 'Overview airing today tv series for testing.',
  popularity: 100.5,
  posterPath: '/poster1.jpg',
  voteAverage: 8.5,
  voteCount: 1000,
);

final testTvList = [testTv];

const testSeason = Season(
  airDate: '2021-01-01',
  episodeCount: 10,
  id: 1001,
  name: 'Season 1',
  overview: 'Season 1 overview.',
  posterPath: '/season1.jpg',
  seasonNumber: 1,
  voteAverage: 8.0,
);

const testTvDetail = TVDetail(
  backdropPath: '/backdrop_detail.jpg',
  firstAirDate: '2021-01-01',
  genres: [Genre(id: 18, name: 'Drama')],
  id: 1,
  lastAirDate: '2023-01-01',
  name: 'Test TV Detail',
  numberOfEpisodes: 20,
  numberOfSeasons: 2,
  originalName: 'Test TV Detail',
  overview: 'Detailed overview of test tv series.',
  posterPath: '/poster_detail.jpg',
  seasons: [
    Season(
      airDate: '2021-01-01',
      episodeCount: 10,
      id: 1001,
      name: 'Season 1',
      overview: 'Season 1 overview.',
      posterPath: '/season1.jpg',
      seasonNumber: 1,
      voteAverage: 8.0,
    ),
  ],
  status: 'Returning Series',
  tagline: 'Test tagline',
  type: 'Scripted',
  voteAverage: 8.7,
  voteCount: 1500,
);

const testEpisode = Episode(
  airDate: '2021-01-01',
  episodeNumber: 1,
  id: 5001,
  name: 'Pilot',
  overview: 'Pilot episode overview.',
  runtime: 55,
  seasonNumber: 1,
  stillPath: '/still1.jpg',
  voteAverage: 8.0,
  voteCount: 100,
);

const testSeasonDetail = SeasonDetail(
  airDate: '2021-01-01',
  episodes: [
    Episode(
      airDate: '2021-01-01',
      episodeNumber: 1,
      id: 5001,
      name: 'Pilot',
      overview: 'Pilot episode overview.',
      runtime: 55,
      seasonNumber: 1,
      stillPath: '/still1.jpg',
      voteAverage: 8.0,
      voteCount: 100,
    ),
    Episode(
      airDate: '2021-01-08',
      episodeNumber: 2,
      id: 5002,
      name: 'Second Episode',
      overview: 'Second episode overview.',
      runtime: 50,
      seasonNumber: 1,
      stillPath: '/still2.jpg',
      voteAverage: 8.3,
      voteCount: 90,
    ),
  ],
  id: 1001,
  name: 'Season 1',
  overview: 'Season 1 overview.',
  posterPath: '/season1.jpg',
  seasonNumber: 1,
);

const testWatchlistTv = TV.watchlist(
  id: 1,
  name: 'Test TV Detail',
  posterPath: '/poster_detail.jpg',
  overview: 'Detailed overview of test tv series.',
);

const testTvTable = TVTable(
  id: 1,
  name: 'Test TV Detail',
  posterPath: '/poster_detail.jpg',
  overview: 'Detailed overview of test tv series.',
);

final testTvMap = {
  'id': 1,
  'name': 'Test TV Detail',
  'posterPath': '/poster_detail.jpg',
  'overview': 'Detailed overview of test tv series.',
};
