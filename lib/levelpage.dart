import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sounds.dart';
import 'package:vanarbalak/game_state.dart';
import 'package:vanarbalak/main.dart';

class levelPage extends StatelessWidget {
  levelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final playerName = context.read<gameState>().playerName;
    final playerFinalScore = context.watch<gameState>().playerFinalScore;

    return Consumer<gameState>(
      builder: (context, game, _) {
        if (game.winnerVanar == 1 ||
            game.winnerComputer == 1 ||
            game.winnerBoth == 1) {
          // ✅ If a winner is found, go to winnerPage
          return const winnerPage();
        }
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
                      MaterialPageRoute(
                        builder: (context) => const leaderBoard(),
                      ),
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
                      MaterialPageRoute(
                        builder: (context) => const instructions(),
                      ),
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
                ExpansionTile(
                  leading: Icon(Icons.mode),
                  title: Text("Game modes"),
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("Urban trail (normal mode)"),
                      onTap: () {
                        context.read<gameState>().levelPlay = true;
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.forest),
                      title: Text("Jungle Progression"),
                      onTap: () {
                        context.read<gameState>().levelPlay = true;
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => levelPage()),
                        );
                      },
                    ),
                  ],
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
                        "🛡️Vanar Identity: ${game.playerName}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        "⚡Vanar Aura: ${game.playerFinalScore}",
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
      },
    );
  }
}

class randomNumber extends StatelessWidget {
  const randomNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<gameState>();
    game.levelPlayRules();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Trail : ${game.level} ",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${game.levelRule} ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.02,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
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
        SizedBox(height: 40),
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
                      context.read<gameState>().levelPlayRules();
                      context.read<gameState>().levelTakeNumber();
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
                        context.read<gameState>().levelPlayRules();
                        context.read<gameState>().levelGiveNumber();
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
