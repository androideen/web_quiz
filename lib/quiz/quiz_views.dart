import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/data.dart';
import 'package:provider/provider.dart';
import 'package:quiz/quiz/quiz_model.dart';
import 'package:quiz/quiz_category/category_screen.dart';

class QuestionCard extends StatefulWidget {
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack);

    _animationController.forward();

    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.width > 1023 ? 36.0 : 24.0;
    //play animation if playAnimation is triggered
    if(context.watch<QuizModel>().playAnimation){
      context.watch<QuizModel>().playAnimation = false;
      _animationController.forward(from: 0.0);
    }

    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: MediaQuery.of(context).size.width,
        //color: AppConfig.primaryColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.watch<QuizModel>().progress,
              style: TextStyle(color: AppConfig.primaryColor, fontSize: fontSize),
            ),
            context.watch<QuizModel>().question.question.isNotEmpty
                ? Text(
              context.watch<QuizModel>().question.question,
              style: TextStyle(fontSize: fontSize),
            )
                : Container(),
            context.watch<QuizModel>().question.question.isNotEmpty &&
                context.watch<QuizModel>().question.image.isNotEmpty
                ? SizedBox(
              height: 30,
            )
                : Container(),
            context.watch<QuizModel>().question.image.isNotEmpty
                ? Container(
                width: 300,
                height: 200,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(context.watch<QuizModel>().imageURL()),
                ))
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ChoiceCard extends StatefulWidget {
  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack);

    _animationController.forward();

    super.initState();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _answerGroup(BuildContext context, Question question) {
    List<Widget> widgets = List<Widget>();

    //answer's characters
    for (var i = 0; i < question.answer.length; i++) {
      widgets.add(SizedBox(
        width: 50,
        child: TextButton(
          onPressed: () {
            //reset disable character and replace it in answer as well
            context.read<QuizModel>().resetAnswer(i);
            SystemSound.play(SystemSoundType.click);
            setState(() {});
          },
          child: Text(
            context.watch<QuizModel>().answers[i],
            style: TextStyle(fontSize: 20, color: AppConfig.textColor),
          ),
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Wrap(
        spacing: 5.0,
        runSpacing: 5.0,
        direction: Axis.horizontal,
        children: widgets,
      ),
    );
  }

  Widget _resultGroup(BuildContext context, Question question) {
    var result;
    if (context.watch<QuizModel>().isLastQuestion) {
      result = Wrap(
        spacing: 5.0,
        runSpacing: 5.0,
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "Congratulations!",
            style: TextStyle(color: Colors.lime, fontSize: 24.0),
          ),
          Text(
            "You've completed all questions!",
            style: TextStyle(color: Colors.lime, fontSize: 16.0),
          ),
          TextButton(
            onPressed: () {
              context.read<QuizModel>().index = 0;
              Navigator.pushNamedAndRemoveUntil(
                  context, CategoryPage.routeName, (route) => false);
            },
            child: Icon(
              Icons.navigate_before,
              color: AppConfig.textColor,
            ),
          )
        ],
      );
    } else {
      result = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Correct!",
              style: TextStyle(color: AppConfig.successColor, fontSize: 24.0),
            ),
            SizedBox(
              width: 20,
            ),
            TextButton(
              child: Icon(
                Icons.navigate_next,
                color: AppConfig.textColor,
              ),
              onPressed: () {
                context.read<QuizModel>().nextQuestion();
                //play animation
                _animationController.forward(from: 0.0);
                //reset animation state
                context.read<QuizModel>().playAnimation = true;
                /*setState(() {

                });*/
              },
            )
          ]);
    }
    return result;
  }

  Widget _choicesGroup(BuildContext context, Question question, Widget result) {
    List<Widget> widgets = List<Widget>();

    //choices
    if (question.randomChoices != null) {
      for (var i = 0; i < question.randomChoices.length; i++) {
        String buttonValue = question.randomChoices[i];
        widgets.add(SizedBox(
          width: 50,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              side: BorderSide(width: 1, color: AppConfig.textColor),
            ),
            onPressed: () {
              for (var i = 0; i < question.answer.length; i++) {
                if (context.read<QuizModel>().answerNotSet(i)) {
                  context.read<QuizModel>().answers[i] = buttonValue;
                  break;
                }
              }
              setState(() {});
            },
            child: Text(
              buttonValue,
              style: TextStyle(color: AppConfig.textColor, fontSize: 20),
            ),
          ),
        ));
        widgets.add(SizedBox(
          width: 10,
        ));
      }
    }

    return Container(
      width: 300,
      child: Column(
        children: [
          Visibility(
            child: result,
            visible: context.watch<QuizModel>().isCorrect(),
          ),
          Visibility(
            child: Wrap(
              children: widgets,
            ),
            visible: !context.watch<QuizModel>().isCorrect(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = context.watch<QuizModel>().question;
    return ScaleTransition(
      scale: _animation,
      child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _answerGroup(context, question),
              _choicesGroup(context, question, _resultGroup(context, question)),
            ],
          )),
    );
  }
}
