import 'package:ditonton/domain/entities/episode.dart';
import 'package:equatable/equatable.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.runtime,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int? runtime;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    airDate: json['air_date'],
    episodeNumber: json['episode_number'] ?? 0,
    id: json['id'],
    name: json['name'] ?? '',
    overview: json['overview'] ?? '',
    runtime: json['runtime'],
    seasonNumber: json['season_number'] ?? 0,
    stillPath: json['still_path'],
    voteAverage: json['vote_average'] == null
        ? 0.0
        : (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episode_number': episodeNumber,
    'id': id,
    'name': name,
    'overview': overview,
    'runtime': runtime,
    'season_number': seasonNumber,
    'still_path': stillPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  Episode toEntity() {
    return Episode(
      airDate: airDate,
      episodeNumber: episodeNumber,
      id: id,
      name: name,
      overview: overview,
      runtime: runtime,
      seasonNumber: seasonNumber,
      stillPath: stillPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    airDate,
    episodeNumber,
    id,
    name,
    overview,
    runtime,
    seasonNumber,
    stillPath,
    voteAverage,
    voteCount,
  ];
}
