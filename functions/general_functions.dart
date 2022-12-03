// general-purpose functions will be here

import 'dart:math';

num getRangeRandom({
  required num from,
  required num to,
  RandomType randomType = RandomType.int,
}) {
  final doubleRandom = Random().nextDouble() * (to - from) + from;

  if (randomType == RandomType.double) {
    return doubleRandom;
  }

  return doubleRandom.toInt();
}

enum RandomType {
  int,
  double,
}
