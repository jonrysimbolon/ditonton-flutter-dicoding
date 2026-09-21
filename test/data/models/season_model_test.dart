import 'dart:convert';

import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_detail_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../json_reader.dart';

void main() {
  group('SeasonModel', () {
    test('should parse from JSON correctly', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_detail.json'),
      );
      final seasons = (jsonMap['seasons'] as List)
          .map((e) => SeasonModel.fromJson(e))
          .toList();

      expect(seasons.length, 2);
      expect(seasons[0].seasonNumber, 1);
      expect(seasons[0].name, 'Season 1');
      expect(seasons[0].episodeCount, 10);
    });

    test('should return JSON correctly', () async {
      const model = SeasonModel(
        airDate: '2021-01-01',
        episodeCount: 10,
        id: 1001,
        name: 'Season 1',
        overview: 'Season 1 overview.',
        posterPath: '/season1.jpg',
        seasonNumber: 1,
        voteAverage: 8.0,
      );
      final json = model.toJson();
      expect(json['season_number'], 1);
      expect(json['name'], 'Season 1');
      expect(model.props.isNotEmpty, true);
      expect(testSeason.seasonNumber, 1);
    });
  });

  group('EpisodeModel', () {
    test('should parse episode list from season detail JSON', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_season_detail.json'),
      );
      final model = SeasonDetailModel.fromJson(jsonMap);

      expect(model.episodes.length, 2);
      expect(model.episodes[0].name, 'Pilot');
      expect(model.episodes[0].episodeNumber, 1);
    });

    test('should map EpisodeModel to entity', () async {
      const model = EpisodeModel(
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
      final entity = model.toEntity();
      expect(entity, testEpisode);
      final json = model.toJson();
      expect(json['episode_number'], 1);
      expect(model.props.isNotEmpty, true);
    });
  });

  group('SeasonDetailModel', () {
    test('should parse full season detail', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_season_detail.json'),
      );
      final model = SeasonDetailModel.fromJson(jsonMap);

      expect(model.seasonNumber, 1);
      expect(model.name, 'Season 1');
      expect(model.episodes.length, 2);
    });

    test('should map to entity and back to json', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_season_detail.json'),
      );
      final model = SeasonDetailModel.fromJson(jsonMap);
      final entity = model.toEntity();

      expect(entity, testSeasonDetail);
      final resultJson = model.toJson();
      expect((resultJson['episodes'] as List).length, 2);
      expect(model.props.isNotEmpty, true);
    });
  });
}
