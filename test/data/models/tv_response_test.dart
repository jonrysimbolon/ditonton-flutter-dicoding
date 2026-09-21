import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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
  const tTvModel2 = TVModel(
    backdropPath: '/backdrop2.jpg',
    firstAirDate: '2023-02-01',
    genreIds: [35],
    id: 101,
    name: 'Second TV',
    originCountry: ['GB'],
    originalName: 'Second TV',
    overview: 'Second overview.',
    popularity: 80.0,
    posterPath: '/poster2.jpg',
    voteAverage: 7.5,
    voteCount: 500,
  );
  const tTvResponseModel = TVResponse(tvList: <TVModel>[tTvModel, tTvModel2]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_airing_today.json'),
      );
      final result = TVResponse.fromJson(jsonMap);

      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tTvResponseModel.toJson();

      final expectedJsonMap = {
        'results': [
          {
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
          },
          {
            'backdrop_path': '/backdrop2.jpg',
            'first_air_date': '2023-02-01',
            'genre_ids': [35],
            'id': 101,
            'name': 'Second TV',
            'origin_country': ['GB'],
            'original_name': 'Second TV',
            'overview': 'Second overview.',
            'popularity': 80.0,
            'poster_path': '/poster2.jpg',
            'vote_average': 7.5,
            'vote_count': 500,
          },
        ],
      };

      expect(result, expectedJsonMap);
    });
  });
}
