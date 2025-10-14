import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sounds.dart';
import 'package:vanarbalak/game_state.dart';
import 'package:vanarbalak/levelpage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => gameState(), child: const MyApp()),
  );
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
          } else if (game.playerHasName == false) {
            return const oldPlayerChoice();
          } // show choice screen
          else {
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
              title: Text("Balak’s Scroll of Triumphs 📜"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const leaderBoard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.integration_instructions),
              title: Text("🪶 The Sage’s Guidance"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const instructions()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.score),
              title: Text("The Balak’s Tally"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VanarTallyPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.forest),
              title: Text("Jungle Progression"),
              onTap: () {
                context.read<gameState>().levelPlay = true;
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => levelPage()),
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
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                SizedBox(height: 20),
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
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                SizedBox(height: 30),
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
              "Vanar Aura : $playerFinalScore",
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
    final theme = Theme.of(context);
    return Dialog(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.brown),
            title: const Text(
              "You are Vanar Balak. Win by scoring the highest in a 10-round set.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.casino, color: Colors.blue),
            title: const Text(
              "Each round generates a random number from the void.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.green),
            title: const Text(
              "You can keep the number or give it to Dushman and vice versa.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exposure_plus_1, color: Colors.orange),
            title: const Text("Both players can only keep 5 numbers per set."),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.red),
            title: const Text(
              "After 10 rounds, the higher total wins the set.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bolt, color: Colors.purple),
            title: const Text(
              "Your score is called Vanar Aura ⚡. The stronger your aura, the closer you are to victory.",
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "⚔️ 1 Set = 10 Rounds\n🏆 Total Sets = 10\n🔥 May the best warrior win!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class matchStats extends StatelessWidget {
  const matchStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final game = context.read<gameState>();

    return Dialog(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Vanar Aura
              Card(
                color: theme.colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.bolt, color: Colors.yellow),
                  title: const Text("Vanar Aura"),
                  trailing: Text(
                    game.playerFinalScore.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Games Summary
              Text("🎮 Game Summary", style: theme.textTheme.titleLarge),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.green),
                title: const Text("Total Games Won (+200 each)"),
                trailing: Text("${game.totalWinGame}"),
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.red),
                title: const Text("Total Games Lost (-150 each)"),
                trailing: Text("${game.totalLooseGame}"),
              ),
              ListTile(
                leading: const Icon(Icons.handshake, color: Colors.orange),
                title: const Text("Total Game Ties (+100 each)"),
                trailing: Text("${game.totalTieGame}"),
              ),
              const Divider(),

              // Round Summary
              Text("⚔️ Round Summary", style: theme.textTheme.titleLarge),
              ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.green),
                title: const Text("Rounds Won (+40 each)"),
                trailing: Text("${game.totalRoundsWon}"),
              ),
              ListTile(
                leading: const Icon(Icons.remove_circle, color: Colors.red),
                title: const Text("Rounds Lost (-30 each)"),
                trailing: Text("${game.totalRoundsLost}"),
              ),
              ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.blue),
                title: const Text("Half Rounds Won (+20 each)"),
                trailing: Text("${game.halfGameWin}"),
              ),
              ListTile(
                leading: const Icon(Icons.flash_off, color: Colors.redAccent),
                title: const Text("Half Rounds Lost (-20 each)"),
                trailing: Text("${game.halfGameLoose}"),
              ),
              const Divider(),

              // Streaks
              Text("🔥 Streaks (in a row)", style: theme.textTheme.titleLarge),
              ListTile(
                leading: const Icon(Icons.trending_up, color: Colors.purple),
                title: const Text("Mini Streak (2 wins) +30"),
                trailing: Text("${game.miniRoundStreak}"),
              ),
              ListTile(
                leading: const Icon(Icons.auto_graph, color: Colors.purple),
                title: const Text("Round Streak (3 wins) +80"),
                trailing: Text("${game.roundStreak}"),
              ),
              ListTile(
                leading: const Icon(Icons.whatshot, color: Colors.deepOrange),
                title: const Text("Heavy Streak (5 wins) +150"),
                trailing: Text("${game.heavyRoundStreak}"),
              ),
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: const Text("Legendary Win (7 wins) +200"),
                trailing: Text("${game.legendaryWin}"),
              ),
              ListTile(
                leading: const Icon(Icons.king_bed, color: Colors.black),
                title: const Text("Wipe Out (10 wins) +500"),
                trailing: Text("${game.wipeOut}"),
              ),
              const Divider(),

              // Loss Streaks
              Text(
                "💀 Loss Streaks (in a row)",
                style: theme.textTheme.titleLarge,
              ),
              ListTile(
                leading: const Icon(Icons.trending_down, color: Colors.red),
                title: const Text("Mini Loss (2 losses) -30"),
                trailing: Text("${game.miniRoundStreakL}"),
              ),
              ListTile(
                leading: const Icon(
                  Icons.trending_down,
                  color: Colors.redAccent,
                ),
                title: const Text("Loss Streak (3 losses) -80"),
                trailing: Text("${game.roundStreakL}"),
              ),
              ListTile(
                leading: const Icon(Icons.fireplace, color: Colors.deepOrange),
                title: const Text("Heavy Loss (5 losses) -150"),
                trailing: Text("${game.heavyRoundStreakL}"),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_5, color: Colors.black),
                title: const Text("Legendary Loss (7 losses) -200"),
                trailing: Text("${game.legendaryWinL}"),
              ),
              ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text("Wipe Out Loss (10 losses) -500"),
                trailing: Text("${game.wipeOutL}"),
              ),
              const Divider(),

              // Game Streaks
              Text("🏆 Game Streaks", style: theme.textTheme.titleLarge),
              ListTile(
                leading: const Icon(
                  Icons.stacked_line_chart,
                  color: Colors.teal,
                ),
                title: const Text("Mini Streak (2 wins) +300"),
                trailing: Text("${game.finalMiniWinStreak}"),
              ),
              ListTile(
                leading: const Icon(Icons.show_chart, color: Colors.tealAccent),
                title: const Text("Game Streak (3 wins) +600"),
                trailing: Text("${game.finalGameWinStreak}"),
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.grey),
                title: const Text("Losing Streak (3 losses) -500"),
                trailing: Text("${game.finalGameLooseStreak}"),
              ),
              const Divider(),

              // Margins
              Text("📏 Margins", style: theme.textTheme.titleLarge),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.green),
                title: const Text("Maximum Win Margin"),
                trailing: Text("${game.maxWinMargin}"),
              ),
              ListTile(
                leading: const Icon(Icons.remove, color: Colors.red),
                title: const Text("Maximum Loss Margin"),
                trailing: Text("${game.maxLooseMargin}"),
              ),
            ],
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
                  leading: Text(
                    "#${index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  title: Text(
                    leader.leaderName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  trailing: Text(
                    leader.leaderScore.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class VanarTallyPage extends StatelessWidget {
  const VanarTallyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final game = context.read<gameState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vanar Balak Tally ⚡",
          style: TextStyle(
            fontSize: theme.textTheme.headlineMedium!.fontSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Vanar Aura
          Card(
            color: theme.colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.bolt, color: Colors.yellow),
              title: const Text("Vanar Aura"),
              trailing: Text(
                game.playerFinalScore.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Games Summary
          Text("🎮 Game Summary", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.green),
            title: const Text("Total Games Won (+200 each)"),
            trailing: Text("${game.totalWinGame}"),
          ),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.red),
            title: const Text("Total Games Lost (-150 each)"),
            trailing: Text("${game.totalLooseGame}"),
          ),
          ListTile(
            leading: const Icon(Icons.handshake, color: Colors.orange),
            title: const Text("Total Game Ties (+100 each)"),
            trailing: Text("${game.totalTieGame}"),
          ),
          const Divider(),

          // Round Summary
          Text("⚔️ Round Summary", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text("Rounds Won (+40 each)"),
            trailing: Text("${game.totalRoundsWon}"),
          ),
          ListTile(
            leading: const Icon(Icons.remove_circle, color: Colors.red),
            title: const Text("Rounds Lost (-30 each)"),
            trailing: Text("${game.totalRoundsLost}"),
          ),
          ListTile(
            leading: const Icon(Icons.flash_on, color: Colors.blue),
            title: const Text("Half Rounds Won (+20 each)"),
            trailing: Text("${game.halfGameWin}"),
          ),
          ListTile(
            leading: const Icon(Icons.flash_off, color: Colors.redAccent),
            title: const Text("Half Rounds Lost (-20 each)"),
            trailing: Text("${game.halfGameLoose}"),
          ),
          const Divider(),

          // Streaks
          Text("🔥 Streaks (in a row)", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.purple),
            title: const Text("Mini Streak (2 wins) +30"),
            trailing: Text("${game.miniRoundStreak}"),
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph, color: Colors.purple),
            title: const Text("Round Streak (3 wins) +80"),
            trailing: Text("${game.roundStreak}"),
          ),
          ListTile(
            leading: const Icon(Icons.whatshot, color: Colors.deepOrange),
            title: const Text("Heavy Streak (5 wins) +150"),
            trailing: Text("${game.heavyRoundStreak}"),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.amber),
            title: const Text("Legendary Win (7 wins) +200"),
            trailing: Text("${game.legendaryWin}"),
          ),
          ListTile(
            leading: const Icon(Icons.king_bed, color: Colors.black),
            title: const Text("Wipe Out (10 wins) +500"),
            trailing: Text("${game.wipeOut}"),
          ),
          const Divider(),

          // Loss Streaks
          Text("💀 Loss Streaks (in a row)", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.trending_down, color: Colors.red),
            title: const Text("Mini Loss (2 losses) -30"),
            trailing: Text("${game.miniRoundStreakL}"),
          ),
          ListTile(
            leading: const Icon(Icons.trending_down, color: Colors.redAccent),
            title: const Text("Loss Streak (3 losses) -80"),
            trailing: Text("${game.roundStreakL}"),
          ),
          ListTile(
            leading: const Icon(Icons.fireplace, color: Colors.deepOrange),
            title: const Text("Heavy Loss (5 losses) -150"),
            trailing: Text("${game.heavyRoundStreakL}"),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_5, color: Colors.black),
            title: const Text("Legendary Loss (7 losses) -200"),
            trailing: Text("${game.legendaryWinL}"),
          ),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: const Text("Wipe Out Loss (10 losses) -500"),
            trailing: Text("${game.wipeOutL}"),
          ),
          const Divider(),

          // Game Streaks
          Text("🏆 Game Streaks", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.stacked_line_chart, color: Colors.teal),
            title: const Text("Mini Streak (2 wins) +300"),
            trailing: Text("${game.finalMiniWinStreak}"),
          ),
          ListTile(
            leading: const Icon(Icons.show_chart, color: Colors.tealAccent),
            title: const Text("Game Streak (3 wins) +600"),
            trailing: Text("${game.finalGameWinStreak}"),
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.grey),
            title: const Text("Losing Streak (3 losses) -500"),
            trailing: Text("${game.finalGameLooseStreak}"),
          ),
          const Divider(),

          // Margins
          Text("📏 Margins", style: theme.textTheme.titleLarge),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.green),
            title: const Text("Maximum Win Margin"),
            trailing: Text("${game.maxWinMargin}"),
          ),
          ListTile(
            leading: const Icon(Icons.remove, color: Colors.red),
            title: const Text("Maximum Loss Margin"),
            trailing: Text("${game.maxLooseMargin}"),
          ),
        ],
      ),
    );
  }
}

class instructions extends StatelessWidget {
  const instructions({super.key});

  @override
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.brown),
            title: const Text(
              "You are Vanar Balak. Win by scoring the highest in a 10-round set.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.casino, color: Colors.blue),
            title: const Text(
              "Each round generates a random number from the void.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.green),
            title: const Text(
              "You can keep the number or give it to Dushman and vice versa.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exposure_plus_1, color: Colors.orange),
            title: const Text("Both players can only keep 5 numbers per set."),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events, color: Colors.red),
            title: const Text(
              "After 10 rounds, the higher total wins the set.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bolt, color: Colors.purple),
            title: const Text(
              "Your score is called Vanar Aura ⚡. The stronger your aura, the closer you are to victory.",
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "⚔️ 1 Set = 10 Rounds\n🏆 Total Sets = 10\n🔥 May the best warrior win!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class oldPlayerChoice extends StatelessWidget {
  const oldPlayerChoice({super.key});

  @override
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Welcome back Vanar Balak.\n"
              "Do you want to continue with the old vanar identity or forge a new one?",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<gameState>().oldIdentity();
              },
              icon: const Icon(Icons.casino),
              label: const Text("Continue with Old Identity"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                context.read<gameState>().newIdentity();
              },
              icon: const Icon(Icons.auto_fix_high),
              label: const Text("Forge a New Identity"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
