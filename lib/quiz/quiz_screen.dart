import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/appbar.dart';
import 'package:quiz/common/data.dart';
import 'package:quiz/quiz/quiz_model.dart';
import 'package:quiz/quiz/quiz_repository.dart';
import 'package:quiz/quiz_category/category_screen.dart';
import 'package:quiz/utils/quiz_utils.dart';

class QuizPage extends StatefulWidget {
  static const routeName = '/quiz';
  final Category category;

  const QuizPage({Key key, this.category}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();

    //redirect back to home if there is no category
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _redirectCheck(context));

    //load quiz
    Future.microtask(() {
      if (widget.category != null)
        context.read<QuizModel>().loadQuiz(widget.category);
    });
  }

  _redirectCheck(BuildContext context) {
    if (widget.category == null) {
      Navigator.pushNamedAndRemoveUntil(
          context, CategoryPage.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category != null) {
      //rename title
      SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
        label: "${widget.category.description} | ${AppConfig.APP_NAME}",
        primaryColor: Theme.of(context).primaryColor.value,
      ));

      return Scaffold(
        appBar: MainAppBar(),
        body: SafeArea(
          child: MediaQuery.of(context).size.width > 1023
              ? QuizCard()
              : QuizCardMobile(),
        ),
      );
    }

    //empty placeholder
    return Container();
  }
}

class QuizCard extends StatefulWidget {
  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 4, child: QuestionCard()),
          Spacer(),
          Expanded(flex: 4, child: ChoiceCard()),
        ],
      ),
    );
  }
}

class QuizCardMobile extends StatefulWidget {
  @override
  _QuizCardMobileState createState() => _QuizCardMobileState();
}

class _QuizCardMobileState extends State<QuizCardMobile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [QuestionCard(), ChoiceCard()],
    );
  }
}

class QuestionCard extends StatefulWidget {
  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    var fontSize = MediaQuery.of(context).size.width > 1023 ? 36.0 : 24.0;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
    );
  }
}

class ChoiceCard extends StatefulWidget {
  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  Widget _answerGroup(BuildContext context, Question question) {
    List<Widget> widgets = List<Widget>();

    //answer's characters
    for (var i = 0; i < question.answer.length; i++) {
      widgets.add(SizedBox(
        width: 50,
        child: FlatButton(
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
              style: TextStyle(color: Colors.lime, fontSize: 24.0),
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
                //_animationController.forward(from: 0.0);
              },
            )
            /*FlatButton(
              child: Icon(
                Icons.navigate_next,
                color: AppConfig.textColor,
              ),
              onPressed: () {
                //context.watch<QuizModel>().nextQuestion();
                //play animation
                //_animationController.forward(from: 0.0);
              },
            ),*/
          ]);
    }
    return result;
  }

  Widget _choicesGroup(BuildContext context, Question question, Widget result) {
    List<Widget> widgets = List<Widget>();

    //next button: show when the answer is correct

    //choices
    if (question.randomChoices != null) {
      for (var i = 0; i < question.randomChoices.length; i++) {
        String buttonValue = question.randomChoices[i];
        widgets.add(SizedBox(
          width: 50,
          child: OutlineButton(
            borderSide: BorderSide(color: AppConfig.textColor),
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
    return Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _answerGroup(context, question),
            _choicesGroup(context, question, _resultGroup(context, question)),

          ],
        ));
  }
}
