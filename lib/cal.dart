import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  CalculatorState createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  // 계산식, 결과
  String formula = '';
  String result = '';

  // 계산
  void calculateFormula() {
    try {
      result = make_result(formula).toString();
      formula = '';
    } catch (e) {}
  }

  // 초기화
  void clearFormula() {
    setState(() {
      result = '';
      formula = '';
    });
  }

  // 결괏값 제작
  num make_result(String formula) {
    List<String> tokens = [];
    String currentToken = '';
    for (int i = 0; i < formula.length; i++) {
      if (formula[i] == '+' || formula[i] == '-' || formula[i] == '*' || formula[i] == '/') {
        tokens.add(currentToken);
        currentToken = '';
        tokens.add(formula[i]);
      } else {
        currentToken += formula[i];
      }
    }
    tokens.add(currentToken);

    // 곱셈 나눗셈
    List<String> temporaryTokens = [];
    double currentResult = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      if (tokens[i] == '*') {
        currentResult *= double.parse(tokens[i + 1]);
      } else if (tokens[i] == '/') {
        currentResult /= double.parse(tokens[i + 1]);
      } else {
        temporaryTokens.add(currentResult.toString());
        temporaryTokens.add(tokens[i]);
        currentResult = double.parse(tokens[i + 1]);
      }
    }
    temporaryTokens.add(currentResult.toString());

    // 덧셈 뺄셈
    double finalResult = double.parse(temporaryTokens[0]);
    int finalIntResult = 0;
    for (int i = 1; i < temporaryTokens.length; i += 2) {
      if (temporaryTokens[i] == '+') {
        finalResult += double.parse(temporaryTokens[i + 1]);
      } else if (temporaryTokens[i] == '-') {
        finalResult -= double.parse(temporaryTokens[i + 1]);
      }
    }
    if (finalResult % 1 == 0) {
      finalIntResult = finalResult.round();
      return finalIntResult;
    } else {
      return finalResult;
    }
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              if (buttonText == '=') {
                calculateFormula();
              } else if (buttonText == 'C') {
                clearFormula();
              } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
                if (result != '') {
                  formula += result;
                  result = '';
                  formula += buttonText;
                } else if (formula == '') {
                  print('추가 불가');
                } else {
                  formula += buttonText;
                }
              } else {
                result = '';
                formula += buttonText;
              }
            });
          },
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16),
              child: Text(
                result != '' ? result : (formula != '' ? formula : '0'),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('/'),
            ],
          ),
          Row(
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('*'),
            ],
          ),
          Row(
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('-'),
            ],
          ),
          Row(
            children: [
              buildButton('.'),
              buildButton('0'),
              buildButton('='),
              buildButton('+'),
            ],
          ),
          Row(
            children: [
              buildButton('C'),
            ],
          ),
        ],
      ),
    );
  }
}
