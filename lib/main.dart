import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
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

class randomNumber extends StatefulWidget {
  @override
  State<randomNumber> createState() => _randomNumberState();
}

class _randomNumberState extends State<randomNumber> {
  int masterNumber = Random().nextInt(100);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Master Number: $masterNumber',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final homeState = context
                    .findAncestorStateOfType<_MyHomePageState>();
                if (homeState != null) {
                  homeState.setState(() {
                    homeState.vanarBalakSide += masterNumber;
                  });
                }
                setState(() {
                  masterNumber = Random().nextInt(100);
                });
              },
              child: Text('Take'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => setState(() {}),
                child: Text('give'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class vanarBalakNumber extends StatefulWidget {
  @override
  State<vanarBalakNumber> createState() => _vanarBalakNumberState();
}

class _vanarBalakNumberState extends State<vanarBalakNumber> {
  var vanarBalakSide = 50;

  @override
  Widget build(BuildContext context) {
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

class ComputerNumber extends StatefulWidget {
  @override
  State<ComputerNumber> createState() => _ComputerNumberState();
}

class _ComputerNumberState extends State<ComputerNumber> {
  var computerSide = 12;

  @override
  Widget build(BuildContext context) {
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
