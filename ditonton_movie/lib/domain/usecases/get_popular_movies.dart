import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
