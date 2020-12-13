import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//import esta em desuso nessa versao, foi necessário adicionar a depencencia no pubspec.yaml
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=001dc633";
// const request = "https://api.hgbrasil.com/finance?format=json&key=60df7606";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);

  // print(jsonDecode(response.body)["results"]["currencies"]["USD"]["buy"]);
  // print(jsonDecode(response.body)["results"]["currencies"]["EUR"]["buy"]);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;


  void _realChange(String text) {

    if(text.isEmpty){
      _resetFields();
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChange(String text) {

    if(text.isEmpty){
      _resetFields();
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {

    if(text.isEmpty){
      _resetFields();
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _resetFields(){
    dolarController.text = "";
    euroController.text = "";
    realController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados ...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar dados .",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber),
                        buildTextField(
                            "Reais", "R\$", realController, _realChange),
                        Divider(),
                        buildTextField(
                            "Dólares", "U\$", dolarController, _dolarChange),
                        Divider(),
                        buildTextField(
                            "Euro", "€", euroController, _euroChange),
                        Divider(),
                        Text(
                          'Cotação em relação ao real \n'
                              'Euro : '+(euro).toStringAsFixed(2)+'\n'
                              'Dolar :'+(dolar).toStringAsFixed(2)+'',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber),

                        )

                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

buildTextField(String lable, String prefix, TextEditingController textEditing, Function f) {
  return TextField(
    controller: textEditing,
    decoration: InputDecoration(
        labelText: lable,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    onChanged: f,
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    keyboardType: TextInputType.number,
  );
}
