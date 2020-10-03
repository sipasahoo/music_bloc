import 'package:flutter/material.dart';
import '../blocs/movies_bloc.dart';
import '../models/track_model.dart';
import '../models/lyrics_model.dart';
import 'package:connectivity/connectivity.dart';

class TrackDetails extends StatefulWidget {
  final trackId;
  TrackDetails({Key key, @required this.trackId}) : super(key: key);
  @override
  _TrackDetailsState createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  var subscription;
  var connectionStatus;
  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() => connectionStatus = result);
    });
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus != ConnectivityResult.none) {
      bloc.fetchtrackdetails(widget.trackId);
      bloc.fetchlyricsdetails(widget.trackId);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Track Detail"),
        ),
        body: connectionStatus == ConnectivityResult.none
            ? Container(
                child: Center(child: Text("NO INTERNET CONNECTION")),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(
                        stream: bloc.allTracks,
                        // ignore: missing_return
                        builder: (context, AsyncSnapshot<Trackmodel> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text("Name"),
                                  subtitle: Text(snapshot
                                      .data.message.body.track.trackName),
                                ),
                                ListTile(
                                  title: Text("Artist"),
                                  subtitle: Text(snapshot
                                      .data.message.body.track.artistName),
                                ),
                                ListTile(
                                  title: Text("Album Name"),
                                  subtitle: Text(snapshot
                                      .data.message.body.track.albumName),
                                ),
                                ListTile(
                                  title: Text("Explicit"),
                                  subtitle: Text(snapshot.data.message.body
                                              .track.explicit ==
                                          0
                                      ? "False"
                                      : "True"),
                                ),
                                ListTile(
                                  title: Text("Rating"),
                                  subtitle: Text(snapshot
                                      .data.message.body.track.trackRating
                                      .toString()),
                                )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                    StreamBuilder(
                        stream: bloc.alllyrics,
                        builder: (context, AsyncSnapshot<Lyrics> snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  snapshot.data.message.body.lyrics.lyricsBody),
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                  ],
                ),
              ));
  }
}
