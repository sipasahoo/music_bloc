import 'dart:async';
import 'movie_api_provider.dart';
import '../models/item_model.dart';
import '../models/track_model.dart';
import '../models/lyrics_model.dart';



class Repository {
  final moviesApiProvider = MovieApiProvider();
  Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
    Future<Trackmodel> fetchTrackDetails(trackId) => moviesApiProvider.fetchtrack(trackId);
    Future<Lyrics> fetchLyricsDetails(trackId) => moviesApiProvider.fetchtracklyrics(trackId);

}