import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;
  Answer(this.selectHandler, this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromARGB(255, 17, 0, 255)),
            foregroundColor: MaterialStateProperty.all(Colors.white)),
        child: Text(answerText),
        onPressed: selectHandler,
      ),
    );
  }
}
