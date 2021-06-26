import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int temperature = -5000;
  String location = "Casablanca";
  int woeid = 1532755;
  String weather = "clear";
  String abbreviation = "sn";
  String errorMgs= "";

  //API

  String searchApiUrl =
      "https://www.metaweather.com/api/location/search/?query=";
  String locationApiUrl = "https://www.metaweather.com/api/location/";

  initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchSearch(String input) async {
    try {
      var SearchResult = await http.get(Uri.parse(searchApiUrl + input));
      var result = json.decode(SearchResult.body)[0];

      setState(() {
        location = result['title'];
        woeid = result['woeid'];
      });
      errorMgs = "";
    }
    catch(error)
    {
      setState(() {
        errorMgs = "Error..nothing to show, Please try another city";
      });
    }
  }

  Future<void> fetchLocation() async {
    var locationResult =
        await http.get(Uri.parse(locationApiUrl + woeid.toString()));
    var result = json.decode(locationResult.body);

    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    setState(() {
      temperature = data['the_temp'].round();
      weather = data["weather_state_name"].replaceAll(' ', '').toLowerCase();

      // Weather Icon

      abbreviation = data["weather_state_abbr"];
    });
  }

  Future<void> onTextFieldSubmitted(String input) async {
    await fetchSearch(input);
    await fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/$weather.png'), fit: BoxFit.cover)),
        child: temperature == -5000
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Image.network(
                            'https://www.metaweather.com/static/img/weather/png/$abbreviation.png',
                            width: 170,
                          ),
                        ),
                        Center(
                          child: Text(
                            temperature.toString() + ' C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(children: [
                      Container(
                        width: 300,
                        child: TextField(
                          onSubmitted: (String input) {
                            onTextFieldSubmitted(input);
                          },
                          style: TextStyle(color: Colors.white, fontSize: 24),
                          decoration: InputDecoration(
                              hintText: 'Search a city..',
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Container(
                        child: Text(
                          errorMgs,textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )
                    ])
                  ],
                ),
              ),
      ),
    );
  }
}
