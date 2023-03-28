import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttt/main.dart';
import 'dart:async';
import '../colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool winnerFound = false;
  String result = '';
  bool oTurn = true;
  List<String> input = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int attempts = 0;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 28),
  );
  int oScore = 0;
  int xScore = 0;
  int filledBox = 0;
  static const maxSec = 30;
  int seconds = maxSec;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          1;
        }
      });
    });
  }

  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        _tapped(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: matchedIndexes.contains(index)
                                ? MainColor.accentColor
                                : MainColor.secondaryColor),
                        child: Center(
                          child: Text(
                            input[index],
                            style: GoogleFonts.coiny(
                                fontSize: 60, color: MainColor.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      result,
                      style: customFontWhite,
                    ),
                    SizedBox(height: 25),
                    _buildTimer()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MainColor.buttonColor,
        onPressed: () => setState(() {
          stopTimer();
        }),
        child: Icon(Icons.restart_alt),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      setState(
        () {
          if (oTurn && input[index] == '') {
            input[index] = 'O';
            filledBox++;
          } else if (!oTurn && input[index] == '') {
            input[index] = "X";
            filledBox++;
          }
          oTurn = !oTurn;
          _checkWinner();
        },
      );
    }
  }

  void _checkWinner() {
    if (input[0] == input[1] && input[0] == input[2] && input[0] != '') {
      setState(
        () {
          result = 'player ' + input[0] + ' Wins!';
          matchedIndexes.addAll([0, 1, 2]);
          stopTimer();
          _updateScore(input[0]);
        },
      );
    }
    if (input[3] == input[4] && input[3] == input[5] && input[3] != '') {
      setState(
        () {
          result = 'player ' + input[3] + ' Wins!';
          matchedIndexes.addAll([3, 4, 5]);
          stopTimer();
          _updateScore(input[3]);
        },
      );
    }
    if (input[6] == input[7] && input[6] == input[8] && input[6] != '') {
      setState(
        () {
          result = 'player ' + input[6] + ' Wins!';
          matchedIndexes.addAll([6, 7, 8]);
          stopTimer();
          _updateScore(input[6]);
        },
      );
    }
    if (input[0] == input[3] && input[0] == input[6] && input[0] != '') {
      setState(
        () {
          result = 'player ' + input[0] + ' Wins!';
          matchedIndexes.addAll([0, 3, 6]);
          stopTimer();
          _updateScore(input[0]);
        },
      );
    }
    if (input[1] == input[4] && input[1] == input[7] && input[1] != '') {
      setState(
        () {
          result = 'player ' + input[1] + ' Wins!';
          matchedIndexes.addAll([1, 4, 7]);
          stopTimer();
          _updateScore(input[1]);
        },
      );
    }
    if (input[2] == input[5] && input[2] == input[8] && input[2] != '') {
      setState(
        () {
          result = 'player ' + input[2] + ' Wins!';
          matchedIndexes.addAll([2, 5, 8]);
          stopTimer();
          _updateScore(input[2]);
        },
      );
    }
    if (input[0] == input[4] && input[0] == input[8] && input[0] != '') {
      setState(
        () {
          result = 'player ' + input[0] + ' Wins!';
          matchedIndexes.addAll([0, 4, 8]);
          stopTimer();
          _updateScore(input[0]);
        },
      );
    }
    if (input[2] == input[4] && input[2] == input[6] && input[2] != '') {
      setState(
        () {
          result = 'player ' + input[2] + ' Wins!';
          matchedIndexes.addAll([2, 4, 6]);
          stopTimer();
          _updateScore(input[2]);
        },
      );
    }
    if (!winnerFound && filledBox == 9) {
      setState(() {
        result = 'It\'s a tie!';
        stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        input[i] = '';
      }
      result = '';
    });
    filledBox = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;
    return isRunning
        ? SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxSec,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 8,
                  backgroundColor: MainColor.accentColor,
                ),
                Center(
                  child: Text(
                    '$seconds',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 50),
                  ),
                ),
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              startTimer();
              _clearBoard();
              matchedIndexes = [];
              attempts++;
            },
            child: Text(
              attempts == 0 ? 'Start' : 'Play Again',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2),
            ),
          );
  }
}
