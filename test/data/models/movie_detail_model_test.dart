import 'dart:convert';

import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('should return a JSON map containing proper data', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/movie_detail.json'),
    );
    final model = MovieDetailResponse.fromJson(jsonMap);
    final result = model.toJson();

    expect(result['id'], 1);
    expect(result['title'], 'Title');
    expect(result['runtime'], 120);
    expect((result['genres'] as List).length, 1);
    expect(result['vote_average'], 1.0);
  });

  test('should support value equality', () async {
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('dummy_data/movie_detail.json'),
    );
    final modelA = MovieDetailResponse.fromJson(jsonMap);
    final modelB = MovieDetailResponse.fromJson(jsonMap);

    expect(modelA, modelB);
    expect(modelA.props.isNotEmpty, true);
  });
}
