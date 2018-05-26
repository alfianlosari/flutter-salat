import 'package:flutter/material.dart';
import 'package:salat/api.dart';
import 'package:salat/salat.dart';
import 'dart:async';

class Detail extends StatefulWidget {
  final String cityName;
  final String cityId;

  Detail({Key key, this.cityId, this.cityName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final key = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String error = '';
  Salat salat;

  @override
  void initState() {
    super.initState();
    loadSalat();
  }

  void loadSalat() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    final salat = await Api().getSalatTime(widget.cityId);
    if (salat == null) {
      setState(() {
        error = 'Failed to get salat time';
        isLoading = false;
      });
    } else {
      setState(() {
        error = '';
        isLoading = false;
        this.salat = salat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.cityName),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (salat == null) {
      if (isLoading) {
        return ListView(children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0, top: 16.0),
            child: Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          )
        ]);
      } else if (error != null) {
        return ListView(children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0, top: 16.0),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          )
        ]);
      } else {
        return null;
      }
    } else {
      return ListView(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0, top: 16.0),
            child: Text(
              salat.date,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Text(
              'Shubuh: ${salat.shubuh}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Text(
              'Dzhuhur: ${salat.dzhuhur}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Text(
              'Ashr: ${salat.ashr}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Text(
              'Maghrib: ${salat.maghrib}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0.0),
            child: Text(
              'Isya: ${salat.isya}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body1,
            ),
          )
        ],
      );
    }
  }
}
