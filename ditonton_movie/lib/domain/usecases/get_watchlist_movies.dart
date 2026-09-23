import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/repositories/movie_repository.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
