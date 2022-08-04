import 'package:converter_app_flutter/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar = 0;
  double euro = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Conversor'),
        centerTitle: true,
        backgroundColor: const Color(0x99BA9D00),
      ),
      body: FutureBuilder<Map<dynamic, dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: Text(
                  'Carregando dados...',
                  style: TextStyle(
                    color: Color(0x99BA9D00),
                    fontSize: 25,
                  ),
                ),
              );
            case ConnectionState.done:
            case ConnectionState.active:
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Carregando dados...',
                    style: TextStyle(
                      color: Color(0x99BA9D00),
                      fontSize: 25,
                    ),
                  ),
                );
              } else {
                final Map<String, dynamic> currencies =
                    snapshot.data!['results']['currencies'];
                final Map<String, dynamic> usd = currencies['USD'];
                final Map<String, dynamic> eur = currencies['EUR'];
                dolar = usd['buy'];
                euro = eur['buy'];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Icon(Icons.add),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map<dynamic, dynamic>> getData() async {
  var url =
      Uri.parse('https://api.hgbrasil.com/finance/quotations?key=$apikey');
  var response = await http.get(url);
  return json.decode(response.body);
}
