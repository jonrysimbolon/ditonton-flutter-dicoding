import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/movie_detail.dart';
import 'package:ditonton_movie/domain/repositories/movie_repository.dart';

class SaveWatchlist {
  final MovieRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
