import 'package:vanarbalak/game_state.dart';
import 'dart:math';

int simulatedNumber = 0;
int simulatedComputerNumber = 0;
int simulatedVanarNumber = 0;
int refinedNumber = 0;
int level = 0;

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

void simulateMasterNumber() {
  simulatedNumber = bellWithRareExtremes(1000);
}

void levelPlayRules(int level) {
  refinedNumber = simulatedNumber;
  if (level == 2) {
    if (simulatedNumber.isEven) {
      refinedNumber = simulatedNumber + 200;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 3) {
    if (simulatedNumber.isEven) {
      refinedNumber = simulatedNumber + 200;
    }
    if (simulatedNumber.isOdd) {
      refinedNumber = simulatedNumber + 300;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 4) {
    if (simulatedNumber.isEven) {
      refinedNumber = simulatedNumber - 200;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 5) {
    if (simulatedNumber % 3 == 0) {
      refinedNumber = simulatedNumber * 2;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 6) {
    if (simulatedNumber.isEven) {
      refinedNumber = simulatedNumber - 100;
    }
    if (simulatedNumber.isOdd) {
      refinedNumber = simulatedNumber - 200;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 7) {
    if (simulatedNumber % 5 == 0) {
      refinedNumber = simulatedNumber * 3;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 8) {
    if (simulatedNumber % 5 == 0) {
      refinedNumber = simulatedNumber * 3;
    }
    if (simulatedNumber % 3 == 0) {
      refinedNumber = simulatedNumber * 2;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 9) {
    if (simulatedNumber % 7 == 0) {
      refinedNumber = simulatedNumber * 4;
    }
    if (simulatedNumber % 3 == 0) {
      refinedNumber = simulatedNumber * 2;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
  if (level == 10) {
    if (simulatedNumber % 13 == 0) {
      refinedNumber = simulatedNumber * 7;
    }
    if (simulatedNumber % 7 == 0) {
      refinedNumber = simulatedNumber * 4;
    }
    if (simulatedNumber % 3 == 0) {
      refinedNumber = simulatedNumber * 2;
    }
    if (simulatedNumber.isPrime) {
      refinedNumber = simulatedNumber + 400;
    }
  }
}

void simulate(gameState game) {
  final level = game.level;

  for (int i = 0; i < 4 - game.computerDigit; i++) {
    simulateMasterNumber();
    levelPlayRules(level);
    simulatedComputerNumber =
        game.computerSide + game.refinedNumber + refinedNumber;
  }
  for (int i = 0; i < 4 - game.vanarBalakDigit; i++) {
    simulateMasterNumber();
    levelPlayRules(level);
    simulatedVanarNumber =
        game.vanarBalakSide + game.refinedNumber + refinedNumber;
  }
  if (simulatedComputerNumber > simulatedVanarNumber) {
    game.simulationWin = true;
  }
}
