import 'dart:async';
import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import '../models/track_model.dart';
import '../models/lyrics_model.dart';

class MovieApiProvider {
  Client client = Client();

  Future<ItemModel> fetchMovieList() async {
    final response = await client
        .get("https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    if (response.statusCode == 200) {
      return movieFromJson(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
  Future<Trackmodel> fetchtrack(trackid) async {
    final response = await client
        .get("https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    if (response.statusCode == 200) {
      return trackFromJson(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
  Future<Lyrics> fetchtracklyrics(trackid) async {
    final response = await client
        .get("https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackid&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7");
    if (response.statusCode == 200) {
      return lyricsFromJson(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}