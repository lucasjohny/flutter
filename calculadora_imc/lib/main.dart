import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

MaterialColor _estilo = Colors.green;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();


  GlobalKey <FormState> _formKey = GlobalKey <FormState>();

  String _infoText = "Informe seus dados";
  IconData _face = Icons.person_outline;

  void _resetFields() {
      weightController.text = "";
      heightController.text = "";
      _infoText = "";
      setState(() {
      _estilo = Colors.green;
      _formKey = GlobalKey<FormState>();
      _face = Icons.person_outline;
    });

  }

  void _calculate() {
    setState(() {

        double weight = double.parse(weightController.text);
        double height = double.parse(heightController.text) / 100;

        double imc = weight / (height * height);
        String imcQuatroCasas = imc.toStringAsPrecision(3);

        if (imc < 17) {
          _face = Icons.sentiment_very_dissatisfied;
          _estilo = Colors.red;
          _infoText = "Muito abaixo do peso ($imcQuatroCasas)";
        }else if (imc >= 17 && imc <= 18.49) {
          _face = Icons.sentiment_dissatisfied;
          _estilo = Colors.orange;
          _infoText = "Abaixo do peso ($imcQuatroCasas)";
        }else if (imc >= 18.5 && imc <= 24.99) {
          _face = Icons.sentiment_very_satisfied;
          _estilo = Colors.green;
          _infoText = "Peso normal ($imcQuatroCasas)";
        }else if (imc >= 25 && imc <= 29.99) {
          _face = Icons.sentiment_dissatisfied;
          _estilo = Colors.orange;
          _infoText = "Acima do peso $imcQuatroCasas)";
        }else if (imc >= 30 && imc <= 34.99) {
          _face = Icons.sentiment_very_dissatisfied;
          _estilo = Colors.red;
          _infoText = "Obesidade I ($imcQuatroCasas)";
        }else if (imc >= 35 && imc <= 39.99) {
          _face = Icons.sentiment_very_dissatisfied;
          _estilo = Colors.red;
          _infoText = "Obesidade II (severa) ($imcQuatroCasas)";
        }else if (imc >= 40) {
          _face = Icons.sentiment_very_dissatisfied;
          _estilo = Colors.red;
          _infoText = "Obesidade III (mórbida) ($imcQuatroCasas)";
        }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(_face, size: 120.0, color: _estilo),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: _estilo)),
                textAlign: TextAlign.center,
                style: TextStyle(color: _estilo, fontSize: 25.0),
                controller: weightController,
                  validator: (value){
                    if(value.isEmpty){
                      return "insira seu peso";
                    }
                  },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "altura (cm)",
                    labelStyle: TextStyle(color: _estilo)),
                textAlign: TextAlign.center,
                style: TextStyle(color: _estilo, fontSize: 25.0),
                controller: heightController,
                validator: (value){
                  if(value.isEmpty){
                    return "insira sua altura";
                  }
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()){
                          _calculate();
                        }
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: _estilo,
                    ),
                  )),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: _estilo, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
