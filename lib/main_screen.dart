import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Calculator',
            style: TextStyle(fontSize: 72, color: Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 150,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.pushNamed((context), '/cal');
                print(result);
              },
              child: Text(
                'Start',
                style: TextStyle(color: Colors.white, fontSize: 36),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.deepPurple)),
            ),
          )
        ],
      )),
    );
  }
}
