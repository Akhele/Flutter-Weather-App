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

  int temperature = 0;
  String location = "London";
  int woeid = 44418;
  String weather = "clear";
  String abbreviation = "sn";

  //API

  String searchApiUrl = "https://www.metaweather.com/api/location/search/?query=";
  String locationApiUrl = "https://www.metaweather.com/api/location/";

  initState() {
    super.initState();
    fetchLocation();
  }

  void fetchSearch( String input) async
  {
    var SearchResult = await http.get(Uri.parse(searchApiUrl + input));
    var result = json.decode(SearchResult.body)[0];


    setState(() {
      location = result['title'];
      woeid = result['woeid'];

    });
  }

  void fetchLocation () async {
    var locationResult = await http.get(Uri.parse(locationApiUrl + woeid.toString()));
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

  void onTextFieldSubmitted(String input){
    fetchSearch(input);
    fetchLocation();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/$weather.png'),
                fit: BoxFit.cover
            )
        ),
        child: Scaffold(
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
                      style: TextStyle(color: Colors.white,fontSize: 100,),
                    ),

                  ),
                  Center(
                    child: Text(
                      location,
                      style: TextStyle(color: Colors.white,fontSize: 40,),
                    ),
                  )
                ],
              ),

              Column(
                children:[
                  Container(
                    width: 300,
                    child: TextField(
                      onSubmitted: (String input){
                        onTextFieldSubmitted(input);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      decoration: InputDecoration(
                        hintText: 'Search a city..',
                        hintStyle: TextStyle(color: Colors.white,fontSize: 20),
                        prefixIcon: Icon(Icons.search,color: Colors.white,)
                      ),
                    ),
                  )
              ]

              )

            ],
          ),
        ),

      ),
    );  }
}
