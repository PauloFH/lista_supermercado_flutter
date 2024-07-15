import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  @override
  _CalculadoraPageState createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  String _output = "0";
  String _formula = "";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _formula = "";
        _currentNumber = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
        _num1 = double.parse(_output);
        _operation = buttonText;
        _formula = "$_output $buttonText ";
        _currentNumber = "";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentNumber);
        if (_operation == "+") {
          _output = (_num1 + _num2).toString();
        } else if (_operation == "-") {
          _output = (_num1 - _num2).toString();
        } else if (_operation == "x") {
          _output = (_num1 * _num2).toString();
        } else if (_operation == "/") {
          _output = (_num1 / _num2).toString();
        }
        _formula = "$_formula = $_output";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _currentNumber = "";
      } else if (buttonText == ".") {
        if (!_currentNumber.contains(".")) {
          _currentNumber += buttonText;
          _output = _currentNumber;
        }
      } else {
        _currentNumber += buttonText;
        _output = _currentNumber;
        _formula += buttonText;
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),  // Aumenta o espaçamento entre os botões
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(10.0),  // Aumenta o tamanho dos botões
            backgroundColor: Colors.black38,  // Cor de fundo dos botões
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),  // Sobe a calculadora
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            child: Text(
              _formula,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("/")
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("x")
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-")
              ]),
              Row(children: [
                _buildButton("C"),
                _buildButton("0"),
                _buildButton("."),
                _buildButton("+")
              ]),
              Row(children: [
                _buildButton("="),
              ]),
            ],
          )
        ],
      ),
    );
  }
}
