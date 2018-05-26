import 'package:flutter/material.dart';
import 'package:salat/city.dart';
import 'package:salat/detail.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchList> {
  Widget appBarTitle =
      Text('Indonesia Salat Time', style: TextStyle(color: Colors.white));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  List<String> cities = City.cities;
  bool _isSearching = false;
  String _searchText = '';

  _SearchState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = '';
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: buildBar(context),
      body:
          _isSearching ? buildSearchListView(context) : buildListView(context),
    );
  }

  Widget buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (BuildContext context, int index) {
        final cityName = cities[index];
        final cityId = City.cityDict[cityName];
        return ChildItem(cityName, () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Detail(cityId: cityId, cityName: cityName)));
        });
      },
    );
  }

  Widget buildSearchListView(BuildContext context) {
    if (_searchText.isEmpty) {
      return buildListView(context);
    } else {
      List<String> filteredCities = List();
      cities.forEach((c) {
        if (c.contains(_searchText)) {
          filteredCities.add(c);
        }
      });

      return ListView.builder(
        itemCount: filteredCities.length,
        itemBuilder: (BuildContext context, int index) {
          final cityName = filteredCities[index];
          final cityId = City.cityDict[cityName];
          return ChildItem(cityName, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Detail(cityId: cityId, cityName: cityName)));
          });
        },
      );
    }
  }

  Widget buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        IconButton(
            icon: actionIcon,
            onPressed: () {
              if (this.actionIcon.icon == Icons.search) {
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            })
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      this.actionIcon = Icon(Icons.close, color: Colors.white);
      this.appBarTitle = TextField(
        controller: _searchQuery,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.white)),
      );
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = Icon(Icons.search, color: Colors.white);
      this.appBarTitle =
          Text("Indonesia Salat Time", style: TextStyle(color: Colors.white));
      _isSearching = false;
      _searchQuery.clear();
    });
  }
}

class ChildItem extends StatelessWidget {
  final String name;
  final dynamic onTap;

  ChildItem(this.name, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.lightBlueAccent,
      splashColor: Colors.red,
      child: ListTile(title: Text(this.name)),
    );
  }
}
