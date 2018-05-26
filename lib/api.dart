import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:salat/salat.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:async';

class Api {
  final HttpClient _httpClient = HttpClient();
  final String _url = "http://jadwalsholat.pkpu.or.id/monthly.php?id=";

  Future<Salat> getSalatTime(String id) async {
    try {
      final uri = Uri.parse("$_url$id");
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return parseHtmlSalatTime(responseBody);
    } on Exception catch (e) {
      print("$e");
      return null;
    }
  }

  Salat parseHtmlSalatTime(String html) {
    final document = parse(html);
    final headerResult = document.querySelectorAll("table tr.table_title td b");

    final String city = headerResult[1].text;
    final String monthYearText = headerResult[0].text;
    var date;
    var shubuh;
    var dzhuhur;
    var ashr;
    var maghrib;
    var isya;

    final highlightResult = document.querySelector("table tr.table_highlight");
    final nodes = highlightResult.nodes;

    var index = 0;
    nodes.forEach((f) {
      switch (index) {
        case 0:
          date = "${f.text} ${monthYearText}";
          break;

        case 1:
          shubuh = f.text;
          break;

        case 2:
          dzhuhur = f.text;
          break;

        case 3:
          ashr = f.text;
          break;

        case 4:
          maghrib = f.text;
          break;

        case 5:
          isya = f.text;
          break;

        default:
          break;
      }
      index++;
    });

    return Salat(city, date, shubuh, dzhuhur, ashr, maghrib, isya);
  }
}
