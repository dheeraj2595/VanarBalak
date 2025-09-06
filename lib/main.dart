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
  int masterNumber;
  int totalSet = 1;
  int setNumber = 0;
  double vanarScore = 0;
  double computerScore = 0;
  int winnerVanar = 0;
  int winnerComputer = 0;
  int winnerBoth = 0;
  String winStatement = " ";
  int vanarBalakDigit = 0;
  int computerDigit = 0;
  bool isComputerTurn = false;
  List<String> moveHistory = []; // V for vanar and C for computer
  List<String> vanarNumberAdded = [];
  List<String> computerNumberAdded = [];
  int setVictoryMargin = 0;

  gameState() : masterNumber = Random().nextInt(1000);

  final Random random = Random();
  double bellLike({int samples = 6}) {
    double total = 0;
    for (int i = 0; i < samples; i++) {
      total += random.nextDouble();
    }
    return total / samples;
  }

  int bellWithRareExtremes(int max) {
    if (random.nextDouble() < 0.20) {
      return random.nextInt(max);
    } else {
      double val = bellLike(samples: 6);
      return (val * (max)).round();
    }
  }

  void updateMasterNumber() {
    masterNumber = bellWithRareExtremes(1000);
    notifyListeners();
  }

  void computerPlay() {
    if (masterNumber >= 500 && computerDigit < 5) {
      giveNumber();
      updateMasterNumber();
    } else if (masterNumber < 500 && vanarBalakDigit < 5) {
      takeNumber();
      updateMasterNumber();
    } else {
      giveNumber();
      takeNumber();
      updateMasterNumber();
    }
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
      setVictoryMargin = vanarBalakSide - computerSide;
      computerSide = 0;
      vanarBalakSide = 0;
      setNumber = 0;
      vanarBalakDigit = 0;
      computerDigit = 0;
      totalSet = totalSet + 1;
      moveHistory.clear();
      vanarNumberAdded.clear();
      computerNumberAdded.clear();
      notifyListeners();
    }
  }

  void winnerSystem() {
    if (totalSet > 10) {
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
      masterNumber = 0;
      totalSet = 1;
      setNumber = 0;
      vanarScore = 0;
      computerScore = 0;
      vanarBalakDigit = 0;
      computerDigit = 0;
      winnerVanar = 0;
      winnerComputer = 0;
      winnerBoth = 0;
      notifyListeners();
    }
  }

  void takeNumber() {
    if (vanarBalakDigit < 5) {
      vanarBalakSide += masterNumber;
      vanarBalakDigit = vanarBalakDigit + 1;
      setNumber = setNumber + 1;
      moveHistory.add('V');
      vanarNumberAdded.add('$masterNumber');
    }

    notifyListeners();
  }

  void giveNumber() {
    if (computerDigit < 5) {
      computerSide += masterNumber;
      computerDigit = computerDigit + 1;
      setNumber = setNumber + 1;
      moveHistory.add('C');
      computerNumberAdded.add('$masterNumber');
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
      home: Consumer<gameState>(
        builder: (context, game, _) {
          if (game.winnerVanar == 1 ||
              game.winnerComputer == 1 ||
              game.winnerBoth == 1) {
            return const winnerPage();
          } else {
            return MyHomePage();
          }
        },
      ),
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
              color: theme.colorScheme.primaryContainer,
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
    if (game.setNumber.isOdd) {
      game.isComputerTurn = true;
      Future.delayed(Duration(milliseconds: 1500), () {
        context.read<gameState>().computerPlay();
      });
    } else {
      game.isComputerTurn = false;
    }
    Future.delayed(Duration(milliseconds: 1500), () {
      context.read<gameState>().setSystem();
      context.read<gameState>().winnerSystem();
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${game.totalSet} out of 10 Sets',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
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
              onPressed:
                  game.vanarBalakDigit >= 5 || game.isComputerTurn == true
                  ? null
                  : () {
                      context.read<gameState>().takeNumber();
                      context.read<gameState>().updateMasterNumber();
                    },
              child: Text('Take'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed:
                    game.computerDigit >= 5 || game.isComputerTurn == true
                    ? null
                    : () {
                        context.read<gameState>().giveNumber();
                        context.read<gameState>().updateMasterNumber();
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
        Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                SizedBox(height: 30),
                if (game.vanarBalakSide - game.computerSide >= 0)
                  Text(
                    'Vanar Balak winning by ${game.vanarBalakSide - game.computerSide}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 5
                        ..color = const Color.fromARGB(255, 235, 11, 22),
                    ),
                  ),
                if (game.vanarBalakSide - game.computerSide < 0)
                  Text(
                    'Vanar Balak loosing by ${game.computerSide - game.vanarBalakSide}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      foreground: Paint()
                        ..style = PaintingStyle.fill
                        ..strokeWidth = 5
                        ..color = const Color.fromARGB(255, 235, 11, 22),
                    ),
                  ),

                SizedBox(height: 30),
                Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                SizedBox(height: 100),
                if (game.setVictoryMargin > 0)
                  Text(
                    'set ${game.totalSet - 1} won by Vanar Balak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (game.setVictoryMargin < 0)
                  Text(
                    'Set ${game.totalSet - 1} won by Vanar Balak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
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
        0.03 -
        (0.03 /
            (5 +
                vanarBalakSide)); // Asymptotic formula, approaches 25 but never reaches
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                ...List.generate(
                  context.watch<gameState>().vanarNumberAdded.length,
                  (index) {
                    final number = context
                        .watch<gameState>()
                        .vanarNumberAdded[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('+ '),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Vanar Balak Side: $vanarBalakSide',
              style: TextStyle(
                fontSize:
                    MediaQuery.of(context).size.width * vanarBalakFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ...context.watch<gameState>().moveHistory.map((move) {
                  if (move == 'V') {
                    return Icon(
                      Icons.star_outline,
                      size: MediaQuery.of(context).size.width * 0.03,
                    );
                  } else {
                    return Icon(
                      Icons.circle,
                      size: MediaQuery.of(context).size.width * 0.03,
                    );
                  }
                }).toList(),
              ],
            ),
          ),
        ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                ...List.generate(
                  context.watch<gameState>().computerNumberAdded.length,
                  (index) {
                    final number = context
                        .watch<gameState>()
                        .computerNumberAdded[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 15),
                        Text(
                          number.toString(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '+',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Dushman Side: $computerSide',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * computerFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ...context.watch<gameState>().moveHistory.map((move) {
                  if (move == 'V') {
                    return Icon(
                      Icons.star,
                      size: MediaQuery.of(context).size.width * 0.03,
                    );
                  } else {
                    return Icon(
                      Icons.circle,
                      size: MediaQuery.of(context).size.width * 0.03,
                    );
                  }
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class winnerPage extends StatelessWidget {
  const winnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final winText = context.read<gameState>().winStatement;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: theme.colorScheme.primaryContainer,
            child: Text(
              winText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.10,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<gameState>().resetGame();
            },
            child: Text("Reset"),
          ),
        ],
      ),
    );
  }
}
