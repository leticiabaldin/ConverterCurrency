import 'package:converter_app_flutter/api_key.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    scrollBehavior: ScrollBehaviorModified(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();


  double dolar = 0;
  double euro = 0;

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar)/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro)/dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('App Conversor'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.refresh_outlined),
          onPressed:_clearAll,
        ),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:  [
                        const SizedBox(height: 24),
                        const Icon(
                          Icons.monetization_on,
                          color: Color(0x99BA9D00),
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: realController,
                          onChanged: _realChanged,
                          decoration: const InputDecoration(
                            prefixText: 'R\$',
                            prefixStyle: TextStyle(
                              color: Color(0x99BA9D00),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            labelText: 'Reais',
                            labelStyle: TextStyle(
                              color: Color(0x99BA9D00),
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                width: 1.4,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: dolarController,
                          onChanged: _dolarChanged,
                          decoration: const InputDecoration(
                            prefixText: 'US\$',
                            prefixStyle: TextStyle(
                                color: Color(0x99BA9D00), fontSize: 16),
                            labelText: 'Dólares',
                            labelStyle: TextStyle(
                                color: Color(0x99BA9D00),
                                fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                width: 1.4,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: euroController,
                          onChanged: _euroChanged,
                          decoration: const InputDecoration(
                            prefixText: '€',
                            prefixStyle: TextStyle(
                              color: Color(0x99BA9D00),
                              fontSize: 16,
                            ),
                            labelText: 'Euros',
                            labelStyle: TextStyle(
                              color: Color(0x99BA9D00),
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                width: 1.4,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x99BA9D00),
                                style: BorderStyle.solid,
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
      default:
        return const ClampingScrollPhysics();
    }
  }
}

Widget customTextField(String label, String prefix,TextEditingController c, Function changed) {
  return TextField(
    decoration: InputDecoration(
      prefixText: prefix,
      prefixStyle: const TextStyle(
        color: Color(0x99BA9D00),
        fontSize: 16,
      ),
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0x99BA9D00),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
