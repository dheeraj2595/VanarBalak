import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => gameState(), child: const MyApp()),
  );
}

class gameState extends ChangeNotifier {
  int computerSide = 0;
  int vanarBalakSide = 0;
  int masterNumber = 2;
  int totalSet = 0;
  int setNumber = 0;
  double vanarScore = 0;
  double computerScore = 0;
  int winnerVanar = 0;
  int winnerComputer = 0;
  int winnerBoth = 0;

  void updateMasterNumber() {
    masterNumber = Random().nextInt(100);
    setNumber = setNumber + 1;
    notifyListeners();
  }

  void setSystem() {
    if (setNumber > 10) {
      if (vanarBalakSide > computerSide) {
        vanarScore = vanarScore + 1;
      } else if (computerSide > vanarBalakSide) {
        computerScore = computerScore + 1;
      } else {
        vanarScore = vanarScore + 0.5;
        computerScore = computerScore + 0.5;
      }
      computerSide = 0;
      vanarBalakSide = 0;
      setNumber = 0;
      totalSet = totalSet + 1;
      notifyListeners();
    }
  }

  void winnerSystem() {
    if (totalSet > 10) {
      if (vanarScore > computerScore) {
        winnerVanar = 1; // Vanar Balak is the overall winner
      } else if (computerScore > vanarScore) {
        winnerComputer = 1; // Computer is the overall winner
      } else {
        winnerBoth = 1; // It's a tie overall
      }
      notifyListeners();
    }
  }

  void resetGame() {
    if (winnerVanar == 1 || winnerComputer == 1 || winnerBoth == 1) {
      computerSide = 0;
      vanarBalakSide = 0;
      masterNumber = 2;
      totalSet = 0;
      setNumber = 0;
      vanarScore = 0;
      computerScore = 0;
      winnerVanar = 0;
      winnerComputer = 0;
      winnerBoth = 0;
      notifyListeners();
    }
  }

  void takeNumber() {
    vanarBalakSide += masterNumber;
    computerSide -= masterNumber;
    notifyListeners();
  }

  void giveNumber() {
    vanarBalakSide -= masterNumber;
    computerSide += masterNumber;
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
        title: Text(
          "Vanar Balak",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 233, 5, 5),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Color.fromARGB(131, 206, 219, 146),
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
              color: Color.fromARGB(131, 206, 219, 146),
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
          '${game.masterNumber}',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<gameState>().takeNumber();
                context.read<gameState>().updateMasterNumber();
                context.read<gameState>().setSystem();
                context.read<gameState>().winnerSystem();
                context.read<gameState>().resetGame();
              },
              child: Text('Take'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  context.read<gameState>().giveNumber();
                  context.read<gameState>().updateMasterNumber();
                  context.read<gameState>().setSystem();
                  context.read<gameState>().winnerSystem();
                  context.read<gameState>().resetGame();
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
        'Dushman Side: $computerSide',
        style: TextStyle(
          fontSize: computerFontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
