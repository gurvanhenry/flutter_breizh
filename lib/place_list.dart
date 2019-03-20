import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_breizh/data/place.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_breizh/place_detail.dart';

class PlaceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Breizh'),
      ),
      body: FutureBuilder<List<Place>>(
        future: getPlaces_Api(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
           } else {
            final places = snapshot.data
                .where((place) =>
                    place.pictures != null && place.pictures.length > 0)
                .toList();
            return _PlaceList(
              places: places,
            );
          }
        },
      ),
    );
  }
}

class _PlaceList extends StatelessWidget {
  _PlaceList({
    Key key,
    @required this.places,
  }) : super(key: key);

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: places.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => _PlaceTile(
            place: places[index],
          ),
    );
  }
}

class _PlaceTile extends StatefulWidget {
  _PlaceTile({
    Key key,
    @required this.place,
  }) : super(key: key);

  final Place place;
  @override
  _PlaceTileState createState() {
    return new _PlaceTileState();
  }
}

class _PlaceTileState extends State<_PlaceTile> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 100,
        height: 70,
        child: CachedNetworkImage(
          placeholder: Container(
            color: Colors.black12,
          ),
          imageUrl: widget.place.pictures[0],
          fit: BoxFit.cover,
        ),
      ),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
          });
        },
      ),
      title: Text(widget.place.title),
      subtitle: Text(widget.place.city),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlaceDetailPage(
                place: widget.place,
              ),
        ),
      ),
    );
  }
}
/// Gets a list of places from local file
Future<List<Place>> getPlaces() async {
  String json;
  json = await rootBundle.loadString('assets/places.json');
  return placesFromJson(json);
}

/// Gets a list of places from data-tourisme API.
Future<List<Place>> getPlaces_Api() async {
  String json;
  final response = await http.get(
      "http://www.data-tourisme-bretagne.com/dataserver/tourismebretagne/data/patnaturelBREfr?\$format=json&\$top=1000");
  if (response.statusCode == 200) {
    json = response.body;
  } else {
    json = await rootBundle.loadString('assets/places.json');
  }
  return placesFromJson(json);
}