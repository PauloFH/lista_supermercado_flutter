import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Mercado',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.white,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
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
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
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
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Mercado',
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
