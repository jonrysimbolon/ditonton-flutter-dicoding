import 'dart:convert';

import 'package:ditonton/common/api_config.dart';
import 'package:ditonton/common/server_exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source_impl.dart';
import 'package:ditonton/data/models/season_detail_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

import 'package:http/http.dart' as http;

void main() {
  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Airing Today TVs', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_airing_today.json')),
    ).tvList;

    test('should return list of TVModel when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/airing_today?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_airing_today.json'), 200),
      );
      final result = await dataSource.getAiringTodayTvs();
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/airing_today?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getAiringTodayTvs();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get On The Air TVs', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    ).tvList;

    test('should return list of TVModel when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/on_the_air?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_on_the_air.json'), 200),
      );
      final result = await dataSource.getOnTheAirTvs();
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/on_the_air?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getOnTheAirTvs();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TVs', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvList;

    test('should return list of TVModel when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/popular?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_popular.json'), 200),
      );
      final result = await dataSource.getPopularTvs();
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/popular?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getPopularTvs();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TVs', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_top_rated.json')),
    ).tvList;

    test('should return list of TVModel when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/top_rated?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_top_rated.json'), 200),
      );
      final result = await dataSource.getTopRatedTvs();
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/top_rated?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTopRatedTvs();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Detail', () {
    const tId = 1;
    final tTvDetail = TVDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test('should return tv detail when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_detail.json'), 200),
      );
      final result = await dataSource.getTvDetail(tId);
      expect(result, equals(tTvDetail));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Recommendations', () {
    const tId = 1;
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId/recommendations?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_recommendations.json'), 200),
      );
      final result = await dataSource.getTvRecommendations(tId);
      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId/recommendations?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Season Detail', () {
    const tId = 1;
    const tSeason = 1;
    final tSeasonDetail = SeasonDetailModel.fromJson(
      json.decode(readJson('dummy_data/tv_season_detail.json')),
    );

    test('should return season detail when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId/season/$tSeason?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_season_detail.json'), 200),
      );
      final result = await dataSource.getSeasonDetail(tId, tSeason);
      expect(result, equals(tSeasonDetail));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/tv/$tId/season/$tSeason?api_key=$tmdbApiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getSeasonDetail(tId, tSeason);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TVs', () {
    const tQuery = 'Search';
    final tResult = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_search.json')),
    ).tvList;

    test('should return list when response code is 200', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/search/tv?api_key=$tmdbApiKey&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(readJson('dummy_data/tv_search.json'), 200),
      );
      final result = await dataSource.searchTvs(tQuery);
      expect(result, tResult);
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$tmdbBaseUrl/search/tv?api_key=$tmdbApiKey&query=$tQuery'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchTvs(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
