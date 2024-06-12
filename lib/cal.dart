import 'dart:io';

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
      result = makingResult(formula).toString();
      formula = '';
    } catch (e) {
      pop(context);
    }
  }

  // 초기화
  void clearFormula() {
    setState(() {
      result = '';
      formula = '';
    });
  }

  // 결괏값 제작
  num makingResult(String formula) {
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
              } else if(buttonText == '0') {
                if(formula == '0') {
                  print('추가 불가');
                } else {
                  result = '';
                  formula += buttonText;
                }
              } else if(buttonText == '.') {
                result == '';
                if(formula == '') {
                  formula += '0';
                  formula += buttonText;
                } else if(formula.substring(formula.length - 1) == '.') {
                  print('추가 불가');
                } else {
                  formula += buttonText;
                }
              } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
                if (result != '') {
                  formula += result;
                  result = '';
                  formula += buttonText;
                } else if (formula == '' || formula.substring(formula.length - 1) == '+' || formula.substring(formula.length - 1) == '-' || formula.substring(formula.length - 1) == '*' || formula.substring(formula.length - 1) == '/') {
                  print('추가 불가');
                } else {
                  formula += buttonText;
                }
              } else if(buttonText == '<') {
                try {
                  if(result != '') {
                    formula += result;
                    result = '';
                  }
                  formula = formula.substring(0, formula.length - 1);
                } catch (e) {
                  print(e);
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

  Future pop(BuildContext context) {
    return showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text('close', style: TextStyle(
            fontSize: 24, color: Colors.white
        ),))
      ],
      title: Text('Alert', style: TextStyle(
          fontSize: 28, color: Colors.white
      ),),
      content: Text('올바른 계산식이 아니거나, 아까의 결괏값 그대로에요!', style: TextStyle(
          fontSize: 24, color: Colors.white
      ),),
    ));
  }

  Future closePop(BuildContext context) {
    return showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        TextButton(onPressed: () {
          formula = '';
          result = '';
          exit(0);
        }, child: Text('예', style: TextStyle(
            fontSize: 24, color: Colors.white
        ),)),
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text('취소', style: TextStyle(
            fontSize: 24, color: Colors.white
        ),)),
      ],
      title: Text('Alert', style: TextStyle(
          fontSize: 28, color: Colors.white
      ),),
      content: Text('정말로 종료하시겠어요?', style: TextStyle(
          fontSize: 24, color: Colors.white
      ),),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('Calculator', style: TextStyle(
          color: Colors.white
        ),),
        actions: [IconButton(
          icon: Icon(Icons.close, color: Colors.white,),
          onPressed: () {
            closePop(context);
          },
        ),],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
              buildButton('C'),
              buildButton('+'),
            ],
          ),
          Row(
            children: [
              buildButton('='),
              buildButton('<')
            ],
          ),
        ],
      ),
    );
  }
}
