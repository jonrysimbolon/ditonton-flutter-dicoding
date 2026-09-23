import 'package:ditonton_tv/data/models/tv_model.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvModel = TVModel(
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

  final tTvJson = {
    'backdrop_path': '/backdrop1.jpg',
    'first_air_date': '2023-01-01',
    'genre_ids': [18, 80],
    'id': 100,
    'name': 'Test TV Airing Today',
    'origin_country': ['US'],
    'original_language': 'en',
    'original_name': 'Test TV Airing Today',
    'overview': 'Overview airing today tv series for testing.',
    'popularity': 100.5,
    'poster_path': '/poster1.jpg',
    'vote_average': 8.5,
    'vote_count': 1000,
  };

  const tTv = TV(
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

  test('should be a subclass of TV entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });

  test('should return a valid model from JSON', () async {
    final result = TVModel.fromJson(tTvJson);
    expect(result, tTvModel);
  });

  test('should handle null genre ids and origin country', () async {
    final result = TVModel.fromJson(const {
      'backdrop_path': null,
      'first_air_date': null,
      'genre_ids': null,
      'id': 1,
      'name': null,
      'origin_country': null,
      'original_language': 'en',
      'original_name': null,
      'overview': null,
      'popularity': null,
      'poster_path': null,
      'vote_average': null,
      'vote_count': null,
    });

    expect(result.genreIds, <int>[]);
    expect(result.originCountry, <String>[]);
    expect(result.popularity, 0.0);
    expect(result.voteAverage, 0.0);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tTvModel.toJson();
    final expectedJsonMap = {
      'backdrop_path': '/backdrop1.jpg',
      'first_air_date': '2023-01-01',
      'genre_ids': [18, 80],
      'id': 100,
      'name': 'Test TV Airing Today',
      'origin_country': ['US'],
      'original_name': 'Test TV Airing Today',
      'overview': 'Overview airing today tv series for testing.',
      'popularity': 100.5,
      'poster_path': '/poster1.jpg',
      'vote_average': 8.5,
      'vote_count': 1000,
    };
    expect(result, expectedJsonMap);
  });
}
