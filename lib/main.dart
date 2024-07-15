import 'package:flutter/material.dart';
import 'calculadora_page.dart';
import 'planilha_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mercadinho',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black, // Cor de fundo geral do aplicativo
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // Cor de fundo da barra superior
          centerTitle: true, // Centraliza o título na barra superior
          titleTextStyle: TextStyle(color: Colors.white), // Cor do texto do título na barra superior
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black, // Cor de fundo da barra de navegação inferior
          selectedItemColor: Colors.purple, // Cor do ícone e do texto selecionado
          unselectedItemColor: Colors.white, // Cor do ícone e do texto não selecionado
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white), // Cor do título (usado no AppBar)
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    CalculadoraPage(),
    PlanilhaPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png', // Substitua pelo caminho da sua imagem
              fit: BoxFit.contain,
              height: 32, // Altura da imagem
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Mercadinho',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculadora',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Planilha',
          ),
        ],
      ),
    );
  }
}
