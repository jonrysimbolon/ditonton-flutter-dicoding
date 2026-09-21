import 'package:equatable/equatable.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
    airDate: json['air_date'],
    episodeCount: json['episode_count'] ?? 0,
    id: json['id'],
    name: json['name'] ?? '',
    overview: json['overview'] ?? '',
    posterPath: json['poster_path'],
    seasonNumber: json['season_number'] ?? 0,
    voteAverage: json['vote_average'] == null
        ? 0.0
        : (json['vote_average'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episode_count': episodeCount,
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'season_number': seasonNumber,
    'vote_average': voteAverage,
  };

  @override
  List<Object?> get props => [
    airDate,
    episodeCount,
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
    voteAverage,
  ];
}
