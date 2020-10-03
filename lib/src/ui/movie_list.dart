import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_movie/src/ui/track_details.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
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
      bloc.fetchAllMovies();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Trends'),
        ),
        body: connectionStatus == ConnectivityResult.none
            ? Container(
                child: Center(child: Text("NO INTERNET CONNECTION")),
              )
            : StreamBuilder(
                stream: bloc.allMovies,
                builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.message.body.trackList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TrackDetails(
                                          trackId: snapshot
                                              .data
                                              .message
                                              .body
                                              .trackList[index]
                                              .track
                                              .trackId)));
                            },
                            child: ListTile(
                              leading: Icon(Icons.music_video),
                              title: Text(snapshot.data.message.body
                                  .trackList[index].track.trackName),
                              subtitle: Text(snapshot.data.message.body
                                  .trackList[index].track.albumName),
                              trailing: Text(snapshot.data.message.body
                                  .trackList[index].track.artistName),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ));
  }
}
