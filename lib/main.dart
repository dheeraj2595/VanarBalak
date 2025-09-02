import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => gameState(), child: const MyApp()),
  );
}

class gameState extends ChangeNotifier {
  int computerSide = 15;
  int vanarBalakSide = 50;
  int masterNumber = 0;

  void updateMasterNumber() {
    masterNumber = Random().nextInt(100);
    notifyListeners();
  }

  void takeNumber() {
    vanarBalakSide -= masterNumber;
    computerSide += masterNumber;
    notifyListeners();
  }

  void giveNumber() {
    vanarBalakSide += masterNumber;
    computerSide -= masterNumber;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vanar Balak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var computerSide = 0;
  var vanarBalakSide = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vanar Balak"),
        backgroundColor: Color.fromARGB(255, 245, 78, 181),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Color.fromARGB(131, 29, 206, 147),
              child: ComputerNumber(),
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(132, 255, 201, 202),
              child: randomNumber(),
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(201, 111, 210, 092),
              child: vanarBalakNumber(),
            ),
          ),
        ],
      ),
    );
  }

  State<MyHomePage> createState() => _MyHomePageState();
}

class randomNumber extends StatelessWidget {
  const randomNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<gameState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Master Number: ${game.masterNumber}',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<gameState>().takeNumber();
                context.read<gameState>().updateMasterNumber();
              },
              child: Text('Take'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<gameState>().giveNumber();
                  context.read<gameState>().updateMasterNumber();
                },
                child: Text('give'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class vanarBalakNumber extends StatelessWidget {
  const vanarBalakNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final vanarBalakSide = context.watch<gameState>().vanarBalakSide;
    double vanarBalakFontSize =
        35 -
        (15 /
            (1 +
                vanarBalakSide)); // Asymptotic formula, approaches 25 but never reaches
    return Center(
      child: Text(
        'Vanar Balak Side: $vanarBalakSide',
        style: TextStyle(
          fontSize: vanarBalakFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ComputerNumber extends StatelessWidget {
  const ComputerNumber({super.key});
  @override
  Widget build(BuildContext context) {
    final computerSide = context.watch<gameState>().computerSide;
    double computerFontSize = 35 - (15 / (1 + computerSide));
    return Center(
      child: Text(
        'Computer Side: $computerSide',
        style: TextStyle(
          fontSize: computerFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
