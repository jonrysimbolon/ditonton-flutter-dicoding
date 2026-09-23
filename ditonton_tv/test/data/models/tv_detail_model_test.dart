import 'dart:convert';

import 'package:ditonton_tv/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../json_reader.dart';

void main() {
  test('should return a valid model from JSON', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/tv_detail.json'),
    );
    final result = TVDetailModel.fromJson(jsonMap);

    expect(result.id, 1);
    expect(result.name, 'Test TV Detail');
    expect(result.numberOfSeasons, 2);
    expect(result.numberOfEpisodes, 20);
    expect(result.seasons.length, 2);
    expect(result.genres.length, 2);
  });

  test('should return a JSON map containing proper data', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/tv_detail.json'),
    );
    final model = TVDetailModel.fromJson(jsonMap);
    final result = model.toJson();

    expect(result['id'], 1);
    expect(result['name'], 'Test TV Detail');
    expect((result['seasons'] as List).length, 2);
  });

  test('should map to TVDetail entity correctly', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/tv_detail.json'),
    );
    final model = TVDetailModel.fromJson(jsonMap);
    final entity = model.toEntity();

    expect(entity.id, 1);
    expect(entity.name, 'Test TV Detail');
    expect(entity.seasons.length, 2);
    expect(entity.voteAverage, 8.7);
  });

  test('should support value equality', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/tv_detail.json'),
    );
    final modelA = TVDetailModel.fromJson(jsonMap);
    final modelB = TVDetailModel.fromJson(jsonMap);

    expect(modelA, modelB);
    expect(modelA.props.isNotEmpty, true);
    expect(testTvDetail.id, 1);
  });
}
