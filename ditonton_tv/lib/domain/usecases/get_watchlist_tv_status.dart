import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class GetWatchlistTVStatus {
  final TVRepository repository;

  GetWatchlistTVStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
