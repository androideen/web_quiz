import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:quiz/constants/app.dart';
import 'package:quiz/controllers/quiz_controllers.dart';
import 'package:quiz/models/quiz.dart';
import 'package:quiz/utils/quiz_utils.dart';
import 'package:quiz/widgets/appbar.dart';
import 'package:simple_animations/simple_animations.dart';

class QuizPage extends StatefulWidget {
  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  QuizController _quizController = Get.put(QuizController());

  Question get _currentQuestion => _quizController.question.value;

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _quizController.loadQuiz(Get.parameters['category']);
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack);

    _animationController.forward(from: 0.0);
  }

  Widget _quiz() {
    return Obx(() {
      if (_quizController.question.value.question.isNotEmpty ||
          _quizController.question.value.image.isNotEmpty) {
        return Container(
          width: 729,
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _questionGroup(),
                  _answerGroup(),
                  _choicesGroup(),
                ],
              ),
            ),
          ),
        );
      }
      return CircularProgressIndicator();
    });
  }

  Widget _questionGroup() {
    var fontSize = Get.width > 729 ? 48.0 : 24.0;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _quizController.progress,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: fontSize),
          ),
        ),
        _currentQuestion.question.isNotEmpty
            ? Text(_quizController.question.value.question, style: TextStyle(fontSize: fontSize),)
            : Container(),
        _currentQuestion.question.isNotEmpty &&
                _currentQuestion.image.isNotEmpty
            ? SizedBox(
                height: 30,
              )
            : Container(),
        _currentQuestion.image.isNotEmpty
            ? Container(
                width: 300,
                height: 200,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(
                      _quizController.imageURL(_currentQuestion.image)),
                ))
            : Container(),
      ],
    );
  }

  Padding _answerGroup() {
    List<Widget> widgets = List<Widget>();

    //answer's characters
    for (var i = 0; i < _currentQuestion.answer.length; i++) {
      widgets.add(SizedBox(
        width: 50,
        child: FlatButton(
          onPressed: () {
            //reset disable character and replace it in answer as well
            _quizController.choices[i] = QuizUtil.answerPlaceholder;
            SystemSound.play(SystemSoundType.click);
            setState(() {});
          },
          child: Text(
            _quizController.choices[i],
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

  Padding _choicesGroup() {
    List<Widget> widgets = List<Widget>();

    //next button: show when the answer is correct
    var next;
    if (_quizController.index.value == _quizController.quiz.questionCount - 1) {
      next = Wrap(
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
          FlatButton(
            onPressed: () {
              Get.offAllNamed('/');
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppConfig.textColor,
            ),
          )
        ],
      );
    } else {
      next = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Correct!",
              style: TextStyle(color: Colors.lime, fontSize: 24.0),
            ),
            SizedBox(
              width: 20,
            ),
            FlatButton(
              child: Icon(
                Icons.navigate_next,
                color: AppConfig.textColor,
              ),
              onPressed: () {
                _quizController.updateIndex();
                //play animation
                _animationController.forward(from: 0.0);
              },
            ),
          ]);
    }

    //choices
    for (var i = 0; i < _currentQuestion.randomChoices.length; i++) {
      String buttonValue = _currentQuestion.randomChoices[i];
      widgets.add(SizedBox(
        width: 50,
        child: OutlineButton(
          borderSide: BorderSide(color: AppConfig.textColor),
          onPressed: () {
            for (var i = 0; i < _currentQuestion.answer.length; i++) {
              if (_quizController.choices[i] == QuizUtil.answerPlaceholder) {
                _quizController.choices[i] = buttonValue;
                break;
              }
            }
            setState(() {});
          },
          child: Text(
            buttonValue,
            style: TextStyle(color: AppConfig.textColor, fontSize: 20),
            //key: ObjectKey("choice_$i"),
          ),
        ),
      ));
      widgets.add(SizedBox(
        width: 10,
      ));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: Container(
        width: 300,
        child: Column(
          children: [
            Visibility(
              child: next,
              visible: _quizController.validateAnswer(),
            ),
            Visibility(
              child: Wrap(
                children: widgets,
              ),
              visible: !_quizController.validateAnswer(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: Get.parameters['category'] + ' ' + AppConfig.APP_NAME,
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            child: _quiz(),
          ),
        ),
      ),
    );
  }
}
