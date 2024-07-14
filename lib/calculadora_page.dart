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
        _formula = _output + " " + buttonText + " ";
        _currentNumber = "";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentNumber);
        if (_operation == "+") {
          _output = (_num1 + _num2).toString();
        }
        if (_operation == "-") {
          _output = (_num1 - _num2).toString();
        }
        if (_operation == "x") {
          _output = (_num1 * _num2).toString();
        }
        if (_operation == "/") {
          _output = (_num1 / _num2).toString();
        }
        _formula = _formula + " = " + _output;
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _currentNumber = "";
      } else {
        _currentNumber += buttonText;
        _output = _currentNumber;
        _formula += buttonText;
      }
    });
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _buttonPressed(buttonText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
          child: Text(
            _output,
            style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Text(
            _formula,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Expanded(
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
              _buildButton("="),
              _buildButton("+")
            ]),
          ],
        )
      ],
    );
  }
}
