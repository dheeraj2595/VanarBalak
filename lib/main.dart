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
  String winStatement = " ";
  int vanarBalakDigit = 0;
  int computerDigit = 0;

  void updateMasterNumber() {
    masterNumber = Random().nextInt(100);
    setNumber = setNumber + 1;
    notifyListeners();
  }

  void setSystem() {
    if (setNumber >= 10) {
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
      vanarBalakDigit = 0;
      computerDigit = 0;
      totalSet = totalSet + 1;
      notifyListeners();
    }
  }

  void winnerSystem() {
    if (totalSet > 9) {
      if (vanarScore > computerScore) {
        winnerVanar = 1;
        winStatement =
            "Vanar Balak is the ultimate winner."; // Vanar Balak is the overall winner
      } else if (computerScore > vanarScore) {
        winnerComputer = 1;
        winStatement =
            "Dushman is the ultimate winner."; // Computer is the overall winner
      } else {
        winnerBoth = 1;
        winStatement = "It's a tie."; // It's a tie overall
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
      vanarBalakDigit = 0;
      computerDigit = 0;
      notifyListeners();
    }
  }

  void takeNumber() {
    if (vanarBalakDigit < 5) {
      vanarBalakSide += masterNumber;
      vanarBalakDigit = vanarBalakDigit + 1;
    } else {
      computerSide += masterNumber;
      computerDigit = computerDigit + 1; // Do nothing if the limit is reached
    }

    notifyListeners();
  }

  void giveNumber() {
    if (computerDigit < 5) {
      computerSide += masterNumber;
      computerDigit = computerDigit + 1;
    } else {
      vanarBalakSide += masterNumber;
      vanarBalakDigit =
          vanarBalakDigit + 1; // Do nothing if the limit is reached
    }
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
        textTheme: ThemeData.light().textTheme.copyWith(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vanar Balak",
          style: TextStyle(
            fontSize: theme.textTheme.headlineMedium!.fontSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: Row(
        children: [
          Flexible(
            child: Container(
              color: theme.colorScheme.primaryContainer,
              child: vanarBalakNumber(),
            ),
          ),
          Flexible(
            child: Container(
              color: theme.colorScheme.secondaryContainer,
              child: randomNumber(),
            ),
          ),
          Flexible(
            child: Container(
              color: theme.colorScheme.primaryContainer,
              child: ComputerNumber(),
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
          '${game.totalSet} out of 10 Sets',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.0006,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${game.masterNumber}',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: game.vanarBalakDigit >= 5
                  ? null
                  : () {
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
                onPressed: game.computerDigit >= 5
                    ? null
                    : () {
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

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Vanar Score : ${game.vanarScore}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dushman Score : ${game.computerScore}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              SizedBox(width: 10),
              Text(
                '${game.winStatement}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  foreground: Paint()
                    ..style = PaintingStyle.fill
                    ..strokeWidth = 5
                    ..color = const Color.fromARGB(255, 235, 11, 22),
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.emoji_events, color: Colors.amber, size: 30),
            ],
          ),
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
        0.03 -
        (0.03 /
            (5 +
                vanarBalakSide)); // Asymptotic formula, approaches 25 but never reaches
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Vanar Balak Side: $vanarBalakSide',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * vanarBalakFontSize,
            fontWeight: FontWeight.bold,
          ),
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
    double computerFontSize =
        0.03 -
        0.03 /
            (5 +
                computerSide); // Asymptotic formula, approaches 0.03 but never reaches
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Dushman Side: $computerSide',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * computerFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
