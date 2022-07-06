import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:runnq/Views/TimerCompanion.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NiceButton(
              background: Colors.white,
              width: 255,
              elevation: 8.0,
              radius: 52.0,
              text: "Maratón",
              gradientColors: [Colors.blueGrey, Colors.blue],
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TimerCompanion()));
              },
            ),
          ),
          NiceButton(
            background: Colors.white,
            width: 255,
            elevation: 8.0,
            radius: 52.0,
            text: "Carrera Trivia",
            gradientColors: const [Colors.blueGrey, Colors.blue],
            onPressed: () {
              //Navigator.of(context).push(MaterialPageRoute(
              //  builder: (BuildContext context) => CronometroCompanion()));
            },
          )
        ],
      ),
    );
  }
}
