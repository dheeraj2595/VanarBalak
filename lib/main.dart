import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vanarbalak/leaderBoardData.dart';
import 'sounds.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => gameState(), child: const MyApp()),
  );
}

class gameState extends ChangeNotifier {
  int computerSide = 0;
  int vanarBalakSide = 0;
  late int masterNumber;
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
  int totalWinGame = 0;
  int totalLooseGame = 0;
  int gameWinStreak = 0;
  int finalGameWinStreak = 0;
  int gameLooseStreak = 0;
  int finalGameLooseStreak = 0;
  int totalTieGame = 0;
  int vanarStreakScore = 0;
  int computerStreakScore = 0;
  int playerFinalScore = 0;
  int maxWinMargin = 0;
  int maxLooseMargin = 0;
  int winMargin = 0;
  int looseMargin = 0;
  String playerName = "";
  List namePrefix = [];
  List nameNoun = [];
  List nameDevanagiriA = [];
  List nameDevanagiriB = [];
  int finalMiniWinStreak = 0;
  int halfGameWin = 0;
  int halfGameLoose = 0;
  int totalRoundsWon = 0;
  int totalRoundsLost = 0;
  int vanarRoundStreakCounter = 0;
  int computerRoundStreakCounter = 0;
  int miniRoundStreak = 0;
  int roundStreak = 0;
  int heavyRoundStreak = 0;
  int legendaryWin = 0;
  int wipeOut = 0;
  int miniRoundStreakL = 0;
  int roundStreakL = 0;
  int heavyRoundStreakL = 0;
  int legendaryWinL = 0;
  int wipeOutL = 0;
  int gameScore = 0;
  int leaderBoardScore = 0;

  gameState() {
    initializeGame();
  }

  List<leaderBoardData> _leaders = [];
  List<leaderBoardData> get leaders => _leaders;

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

  void initializeGame() {
    randomNameGenerate();
    updateMasterNumber();
    loadLeaders();

    notifyListeners();
  }

  void randomNameGenerate() {
    namePrefix = [
      "शक्तिशाली",
      "चालाक",
      "वीर",
      "स्वर्णिम",
      "महान",
      "निर्भीक",
      "अदृश्य",
      "अमर",
      "अजेय",
      "दिव्य",
    ];
    nameNoun = [
      "योद्धा",
      "रक्षक",
      "राजा",
      "नाग",
      "बाघ",
      "शेर",
      "गरुड़",
      "भूत",
      "आत्मा",
      "पर्वत",
      "अग्नि",
    ];
    nameDevanagiriA = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"];
    nameDevanagiriB = ["०", "१", "२", "३", "४", "५", "६", "७", "८", "९"];
    String prefix = namePrefix[random.nextInt(namePrefix.length)];
    String noun = nameNoun[random.nextInt(nameNoun.length)];
    String devanagiriA =
        nameDevanagiriA[random.nextInt(nameDevanagiriA.length)];
    String devanagiriB =
        nameDevanagiriB[random.nextInt(nameDevanagiriB.length)];

    playerName = prefix + noun + devanagiriA + devanagiriB;

    notifyListeners();
  }

  void updateMasterNumber() {
    masterNumber = bellWithRareExtremes(1000);
    gameStats();
    notifyListeners();
  }

  void addLeader() {
    final leaderBoardData newLeader = leaderBoardData(
      leaderName: playerName,
      leaderScore: playerFinalScore,
    );

    _leaders.add(newLeader);

    _leaders.sort((a, b) => b.leaderScore.compareTo(a.leaderScore));
    saveLeaders();
    notifyListeners();
  }

  Future<void> saveLeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = leaderBoardData.encode(_leaders);
    await prefs.setString('leaderBoard', encoded);
  }

  Future<void> loadLeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('leaderBoard');
    if (data != null && data.isNotEmpty) {
      _leaders = leaderBoardData.decode(data);
      _leaders.sort((a, b) => b.leaderScore.compareTo(a.leaderScore));
      notifyListeners();
    }
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
        vanarRoundStreakCounter = vanarRoundStreakCounter + 1;
        computerRoundStreakCounter = 0;
        totalRoundsWon = totalRoundsWon + 1;
        playerFinalScore = playerFinalScore + 40;
        winMargin = vanarBalakSide - computerSide;
        setVictoryMargin = vanarBalakSide - computerSide;
        if (maxWinMargin < winMargin) {
          maxWinMargin = winMargin;
        }
        if (vanarRoundStreakCounter == 2) {
          miniRoundStreak = miniRoundStreak + 1;
          playerFinalScore = playerFinalScore + 30;
        }
        if (vanarRoundStreakCounter == 3) {
          roundStreak = roundStreak + 1;
          playerFinalScore = playerFinalScore + 80;
        }
        if (vanarRoundStreakCounter == 5) {
          heavyRoundStreak = heavyRoundStreak + 1;
          playerFinalScore = playerFinalScore + 150;
        }
        if (vanarRoundStreakCounter == 7) {
          legendaryWin = legendaryWin + 1;
          playerFinalScore = playerFinalScore + 200;
        }
        if (vanarRoundStreakCounter == 10) {
          wipeOut = wipeOut + 1;
          playerFinalScore = playerFinalScore + 500;
        }
      } else if (computerSide > vanarBalakSide) {
        computerScore = computerScore + 1;
        computerRoundStreakCounter = computerRoundStreakCounter + 1;
        vanarRoundStreakCounter = 0;
        totalRoundsLost = totalRoundsLost + 1;
        playerFinalScore = playerFinalScore - 30;
        looseMargin = computerSide - vanarBalakSide;
        setVictoryMargin = vanarBalakSide - computerSide;
        if (maxLooseMargin < looseMargin) {
          maxLooseMargin = looseMargin;
        }
        if (computerRoundStreakCounter == 2) {
          miniRoundStreakL = miniRoundStreakL + 1;
          playerFinalScore = playerFinalScore - 30;
        }
        if (computerRoundStreakCounter == 3) {
          roundStreakL = roundStreakL + 1;
          playerFinalScore = playerFinalScore - 80;
        }
        if (computerRoundStreakCounter == 5) {
          heavyRoundStreakL = heavyRoundStreakL + 1;
          playerFinalScore = playerFinalScore - 150;
        }
        if (computerRoundStreakCounter == 7) {
          legendaryWinL = legendaryWinL + 1;
          playerFinalScore = playerFinalScore - 200;
        }
        if (computerRoundStreakCounter == 10) {
          wipeOutL = wipeOutL + 1;
          playerFinalScore = playerFinalScore - 500;
        }
      } else {
        vanarScore = vanarScore + 0.5;
        computerScore = computerScore + 0.5;
        vanarRoundStreakCounter = 0;
        computerRoundStreakCounter = 0;
        setVictoryMargin = 0;
      }
      computerSide = 0;
      vanarBalakSide = 0;
      setNumber = 0;
      vanarBalakDigit = 0;
      computerDigit = 0;
      totalSet = totalSet + 1;
      leaderBoardScore = playerFinalScore;
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
            "Vanar Balak reigns supreme! 🐒🔥"; // Vanar Balak is the overall winner
      } else if (computerScore > vanarScore) {
        winnerComputer = 1;
        winStatement =
            "The Dushman seizes victory! ⚔️ "; // Computer is the overall winner
      } else {
        winnerBoth = 1;
        winStatement =
            "The battle continues in a stalemate ."; // It's a tie overall
      }
      gameStats();
      gameScore = playerFinalScore;
      notifyListeners();
    }
  }

  void resetGame() {
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

  void gameStats() {
    if (winnerVanar == 1) {
      totalWinGame = totalWinGame + 1;
      gameWinStreak = gameWinStreak + 1;
      playerFinalScore = playerFinalScore + 200;
    }
    if (winnerComputer == 1) {
      totalLooseGame = totalLooseGame + 1;
      gameLooseStreak = gameLooseStreak + 1;
      playerFinalScore = playerFinalScore - 150;
    }
    if (winnerBoth == 1) {
      totalTieGame = totalTieGame + 1;
      playerFinalScore = playerFinalScore + 100;
    }
    if (gameWinStreak == 3) {
      finalGameWinStreak = finalGameWinStreak + 1;
      gameWinStreak = 0;
      playerFinalScore = playerFinalScore + 300;
    }
    if (gameWinStreak == 2) {
      finalMiniWinStreak = finalMiniWinStreak + 1;
      playerFinalScore = playerFinalScore + 150;
    }
    if (gameLooseStreak == 3) {
      finalGameLooseStreak = finalGameLooseStreak + 1;
      gameLooseStreak = 0;
      playerFinalScore = playerFinalScore - 250;
    }
    if (setNumber / 5 == 1 || setNumber / 5 == 2) {
      if (vanarBalakSide > computerSide) {
        halfGameWin = halfGameWin + 1;
        playerFinalScore = playerFinalScore + 20;
      }
      if (computerSide > vanarBalakSide) {
        halfGameLoose = halfGameLoose + 1;
        playerFinalScore = playerFinalScore - 20;
      }
    }
    notifyListeners();
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
    final playerName = context.read<gameState>().playerName;
    final playerFinalScore = context.read<gameState>().playerFinalScore;

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
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Menu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.leaderboard),
              title: Text("Leaderboard"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const leaderBoard()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "🛡️Vanar Identity: $playerName",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    "⚡Vanar Aura: $playerFinalScore",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
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
        Text("🐒", style: TextStyle(fontSize: 24)),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => const InstructionsPage(),
            );
          },
          label: Text("Instructions"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => const matchStats(),
            );
          },
          label: Text("Vanar Records", textAlign: TextAlign.center),
        ),
        SizedBox(height: 80),
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
                      Sounds.playClickTake();
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
                        Sounds.playClickGive();
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
                SizedBox(height: 90),
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
                    'Set ${game.totalSet - 1} won by Dushman',
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
    final vanarScore = context.read<gameState>().vanarScore;
    final computerScore = context.read<gameState>().computerScore;
    final winnerVanar = context.read<gameState>().winnerVanar;
    final winnerComputer = context.read<gameState>().winnerComputer;
    final winnerBoth = context.read<gameState>().winnerBoth;
    final playerFinalScore = context.read<gameState>().playerFinalScore;
    final gameScore = context.read<gameState>().gameScore;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            color: theme.colorScheme.primaryContainer,
            child: Text(
              "$winText\n"
              "$vanarScore - $computerScore",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.10,
              ),
            ),
          ),
          if (winnerVanar == 1)
            Text(
              " + 200 points",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          if (winnerComputer == 1)
            Text(
              "-150 points",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          if (winnerBoth == 1)
            Text(
              "+100 points",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.03,
              ),
            ),
          SizedBox(height: 30),
          Container(
            color: theme.colorScheme.secondaryContainer,
            child: Text(
              "Grand Score : $playerFinalScore",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
          if (gameScore >= 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "(Increased by $gameScore in this game)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
          if (gameScore < 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "(Decreased by $gameScore in this game)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
          SizedBox(height: 30),
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

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Text(
                    "1. You are Vanar Balak and you need to win against dushman! You win by getting the highest possible number in a set composed of 10 rounds.\n"
                    "2. A random number is generated from the void in each round and you can either keep it or give it to dushman and the next round turn will belong to dushman.\n"
                    "3. A new number from the void, Dushman in their turn can also keep or give the number in that round to you.\n "
                    "4. Your numbers will add up in your score and dushman's in their score.\n"
                    "5. Also, both parties can keep only 5 numbers with themselves. That means if you have 5 numbers added up already in this set,\n"
                    "Then you cannot take the number in your round and Dusham cannot give you the number in his round.\n"
                    "6. The one to score the maximum number will win the set.\n"
                    "\n"
                    "-> 1 Set = 10 Rounds\n"
                    "-> Total sets = 10\n"
                    "\n"
                    "Best of luck Vanar Balak!",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.020,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class matchStats extends StatelessWidget {
  const matchStats({super.key});

  @override
  Widget build(BuildContext context) {
    final totalWinGame = context.read<gameState>().totalWinGame;
    final totalLooseGame = context.read<gameState>().totalLooseGame;
    final finalGameWinStreak = context.read<gameState>().finalGameWinStreak;
    final finalGameLooseStreak = context.read<gameState>().finalGameLooseStreak;
    final playerFinalScore = context.read<gameState>().playerFinalScore;
    final maxWinMargin = context.read<gameState>().maxWinMargin;
    final maxLooseMargin = context.read<gameState>().maxLooseMargin;
    final finalMiniWinStreak = context.read<gameState>().finalMiniWinStreak;
    final halfGameWin = context.read<gameState>().halfGameWin;
    final halfGameLoose = context.read<gameState>().halfGameLoose;
    final totalTieGame = context.read<gameState>().totalTieGame;
    final totalRoundsWon = context.read<gameState>().totalRoundsWon;
    final totalRoundsLost = context.read<gameState>().totalRoundsLost;
    final miniRoundStreak = context.read<gameState>().miniRoundStreak;
    final roundStreak = context.read<gameState>().roundStreak;
    final heavyRoundStreak = context.read<gameState>().heavyRoundStreak;
    final legendaryWin = context.read<gameState>().legendaryWin;
    final wipeOut = context.read<gameState>().wipeOut;
    final miniRoundStreakL = context.read<gameState>().miniRoundStreakL;
    final roundStreakL = context.read<gameState>().roundStreakL;
    final heavyRoundStreakL = context.read<gameState>().heavyRoundStreakL;
    final legendaryWinL = context.read<gameState>().legendaryWinL;
    final wipeOutL = context.read<gameState>().wipeOutL;

    return Dialog(
      child: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: Text(
                    "Vanar Aura : $playerFinalScore",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "\n"
                  "Total games won [+200]: $totalWinGame \n"
                  "Total games lost [-150]: $totalLooseGame \n"
                  "Total game tie [+100]: $totalTieGame \n"
                  "\n"
                  "Total Rounds Won [+40]: $totalRoundsWon \n"
                  "total Rounds Lost [-30]: $totalRoundsLost \n"
                  "\n"
                  "Total Half Rounds wins [+20]: $halfGameWin \n"
                  "Total Half Rounds lost [-20]: $halfGameLoose \n"
                  "\n"
                  "Winning round streaks: \n"
                  "Round Mini Streak (2 wins in a row) [+30]: $miniRoundStreak \n"
                  "Round Streak (3 wins in a row) [+80]: $roundStreak \n"
                  "Heavy Round Streak: (5 wins in a row) [+150]: $heavyRoundStreak \n"
                  "Legendary win (7 wins in a row) [+200]: $legendaryWin \n"
                  "Wipe out win (10 wins in a row) [+500]: $wipeOut \n"
                  "\n"
                  "Loosing Round streaks: \n"
                  "Round loosing Mini Streak (2 losses in a row) [-30]: $miniRoundStreakL \n"
                  "Round loosing Streak (3 losses in a row) [-80]: $roundStreakL \n"
                  "Heavy Round loosing Streak: (5 losses in a row) [-150]: $heavyRoundStreakL \n"
                  "Legendary loss (7 losses in a row) [-200]: $legendaryWinL \n"
                  "Wipe out loss (10 losses in a row) [-500]: $wipeOutL \n"
                  "\n"
                  "Game mini streak (2 wins in a row) [+300]: $finalMiniWinStreak \n"
                  "Game Streaks (3 wins in a row) [+600]: $finalGameWinStreak \n"
                  "Loosing streak (lost 3 rounds in a row) [-500]: $finalGameLooseStreak \n"
                  "\n"
                  "Maximum win margin: $maxWinMargin \n"
                  "Maximum loose margin: $maxLooseMargin \n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class leaderBoard extends StatelessWidget {
  const leaderBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaders = context.watch<gameState>().leaders;

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
      body: leaders.isEmpty
          ? const Center(child: Text("No scores yet"))
          : ListView.builder(
              itemCount: leaders.length,
              itemBuilder: (context, index) {
                final leader = leaders[index];
                return ListTile(
                  leading: Text("#${index + 1}"),
                  title: Text(leader.leaderName),
                  trailing: Text(leader.leaderScore.toString()),
                );
              },
            ),
    );
  }
}
