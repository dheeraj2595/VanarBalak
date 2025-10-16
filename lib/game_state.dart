import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vanarbalak/leaderBoardData.dart';

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
  bool playerHasName = false;
  int gameTripleStreak = 0;
  bool levelPlay = false;
  int level = 1;

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
    newOrOldPlayer();

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
      "उत्कृष्ट", // Excellent
      "सशक्त", // Empowered
      "साहसी", // Courageous
      "ज्ञानी", // Wise
      "शुभ्र", // Pure
      "संपन्न", // Prosperous
      "सुशांत", // Calm / Peaceful
      "सफल", // Successful
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
      "वज्र", // Thunderbolt
      "सिंहासन", // Throne
      "असुर", // Demon
      "देव", // God
      "अमर", // Immortal
      "सिंह", // Lion (another form)
      "चक्र", // Discus / Wheel
      "ध्वज", // Flag / Banner
      "भानु", // Sun
      "वायु", // Wind
      "अस्त्र", // Weapon
      "नक्षत्र", // Star
      "विक्रम", // Valor
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
    if (setNumber.isOdd) {
      isComputerTurn = true;
      Future.delayed(Duration(milliseconds: 1500), () {
        computerPlay();
      });
    } else {
      isComputerTurn = false;
    }
    gameStats();
    notifyListeners();
  }

  void addLeader() {
    // Check if player already exists
    final existingIndex = _leaders.indexWhere(
      (e) => e.leaderName == playerName,
    );

    if (existingIndex >= 0) {
      // Update score if the new score is higher
      if (playerFinalScore > _leaders[existingIndex].leaderScore) {
        _leaders[existingIndex] = leaderBoardData(
          leaderName: playerName,
          leaderScore: playerFinalScore,
        );
      }
    } else {
      // Add as a new leader if not found
      _leaders.add(
        leaderBoardData(leaderName: playerName, leaderScore: playerFinalScore),
      );
    }

    // Sort leaderboard by score descending
    _leaders.sort((a, b) => b.leaderScore.compareTo(a.leaderScore));

    // Save to SharedPreferences
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

  Future<void> saveLastPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPlayerName', playerName);
  }

  Future<String?> loadLastPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastPlayerName');
  }

  Future<void> newOrOldPlayer() async {
    final lastPlayerName = await loadLastPlayerName();

    if (lastPlayerName == null) {
      randomNameGenerate();
      await saveLastPlayerName();
      playerHasName = true;
    } else {
      playerHasName = false;
      playerName = lastPlayerName;
    }
    notifyListeners();
  }

  void newIdentity() {
    randomNameGenerate();
    playerHasName = true;

    notifyListeners();
  }

  void oldIdentity() {
    playerHasName = true;

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
      if (totalSet > 10 && levelPlay == true && winnerVanar == 1) {
        level = level + 1;
      }
      gameStats();
      gameScore = playerFinalScore;
      addLeader();
      loadLeaders();
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
      gameTripleStreak = gameTripleStreak + 1;
      gameLooseStreak = 0;
      playerFinalScore = playerFinalScore + 200;
    }
    if (winnerComputer == 1) {
      totalLooseGame = totalLooseGame + 1;
      gameLooseStreak = gameLooseStreak + 1;
      gameWinStreak = 0;
      gameTripleStreak = 0;
      playerFinalScore = playerFinalScore - 150;
    }
    if (winnerBoth == 1) {
      totalTieGame = totalTieGame + 1;
      playerFinalScore = playerFinalScore + 100;
      gameLooseStreak = 0;
      gameWinStreak = 0;
      gameTripleStreak = 0;
    }
    if (gameTripleStreak == 3) {
      finalGameWinStreak = finalGameWinStreak + 1;
      playerFinalScore = playerFinalScore + 300;
      gameTripleStreak = 0;
    }
    if (gameWinStreak == 2) {
      finalMiniWinStreak = finalMiniWinStreak + 1;
      playerFinalScore = playerFinalScore + 150;
      gameWinStreak = 0;
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
