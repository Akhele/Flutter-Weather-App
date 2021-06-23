import 'package:flutter/material.dart';

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
  String location = "Tangier";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/clear.png'),
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
