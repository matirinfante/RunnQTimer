import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
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
            child: NiceButtons(
              onTap: (tap) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => TimerCompanion()));
              },
              child: const Text('Maraton'),
            ),
          ),
          NiceButtons(
            onTap: (tap) {},
            child: const Text("Carrera trivia"),
          )
        ],
      ),
    );
  }
}
