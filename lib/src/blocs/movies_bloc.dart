import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../models/track_model.dart';
import '../models/lyrics_model.dart';

class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _trackFetcher = PublishSubject<Trackmodel>();
  final _lyricsFetcher = PublishSubject<Lyrics>();

  Stream<ItemModel> get allMovies => _moviesFetcher.stream;
  Stream<Trackmodel> get allTracks => _trackFetcher.stream;
  Stream<Lyrics> get alllyrics => _lyricsFetcher.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel);
  }

  fetchtrackdetails(trackId) async {
    Trackmodel trackModel = await _repository.fetchTrackDetails(trackId);
    _trackFetcher.sink.add(trackModel);
  }
  fetchlyricsdetails(trackId) async {
    Lyrics lyricsModel = await _repository.fetchLyricsDetails(trackId);
    _lyricsFetcher.sink.add(lyricsModel);
  }
  dispose() {
    _moviesFetcher.close();
    _trackFetcher.close();
    _lyricsFetcher.close();
  }
}

final bloc = MoviesBloc();
