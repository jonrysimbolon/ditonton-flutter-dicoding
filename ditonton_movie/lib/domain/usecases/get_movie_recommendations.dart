import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/repositories/movie_repository.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
