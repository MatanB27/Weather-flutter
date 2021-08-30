import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  TextEditingController searchController = TextEditingController();
  final base = 'https://api.openweathermap.org/data/2.5/weather';
  final key = 'appid=79eb640d1eed05dbcbf5f784f2fea112';
  final units = 'units=metric';
  String city = '';
  String country = '';
  String desc = '';
  dynamic temp = 0;
  String imgIcon = '';

  //Example https://api.openweathermap.org/data/2.5/weather?q=london&appid=79eb640d1eed05dbcbf5f784f2fea112&units=metric
  Future<void> fetchData() async {
    String apiUrl = base + '?q=' + city + '&' + key + '&' + units;
    final response = await http.get(Uri.parse(apiUrl));
    final Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((key, value) {
      if (key == 'name') {
        setState(() {
          city = value;
        });
      }
      if (key == 'main') {
        Map<String, dynamic> findTemp = value;
        findTemp.forEach((key, value) {
          if (key == 'temp') {
            setState(() {
              temp = value;
            });
          }
        });
      }
      if (key == 'sys') {
        Map<String, dynamic> findCountry = value;
        findCountry.forEach((key, value) {
          if (key == 'country') {
            setState(() {
              country = value;
            });
          }
        });
      }
      if (key == 'weather') {
        List<dynamic> findArr = value;
        findArr.forEach((element) {
          Map<String, dynamic> findDesc = element;
          findDesc.forEach((key, value) {
            if (key == 'description') {
              setState(() {
                desc = value;
              });
            }
            if (key == 'icon') {
              setState(() {
                imgIcon = value;
              });
            }
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  buildText(String text, double size, [bool isBold, bool isItalic]) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          color: Colors.white,
          fontWeight: isBold ? FontWeight.bold : null,
          fontStyle: isItalic ? FontStyle.italic : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Icon(Icons.wb_sunny),
        title: Text('Weather app'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextField(
                  onChanged: (result) async {
                    city = result;
                    await fetchData();
                  },
                  controller: searchController,
                  decoration: new InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildText(city, 40, true, false),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: buildText(',' + country, 40, true, false),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child:
                    buildText(temp.floor().toString() + '°', 65.0, true, false),
              ),
              SizedBox(
                height: 10.0,
              ),
              buildText(desc, 18.0, false, true),
              SizedBox(
                height: 50.0,
              ),
              Image.network(
                  'https://openweathermap.org/img/wn/' + imgIcon + '@2x.png')
            ],
          ),
        ),
      ),
    );
  }
}
