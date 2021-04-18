import 'dart:math';

class Utility {
  Utility();

  // return a random generated number
  int returnRandomNumber() {
    var rNum = new Random.secure();

    return rNum.nextInt(10000) * 30;
  }
}
