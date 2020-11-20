import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/common/data.dart';
import 'package:quiz/utils/quiz_utils.dart';

class QuizController extends GetxController{
  var quiz = Quiz();
  var index = 0.obs;
  var question = Question("", "", "").obs;
  List<String> choices = [];

  String get progress => "${(index.value + 1)} / ${quiz.questionCount}";

  @override
  void onInit() {
    super.onInit();
  }

  void loadQuiz(String category) async{
    quiz.category = Category(category, '');
    quiz.questions = await QuizUtil.loadQuiz(category);
    updateQuestion();
  }
  void updateIndex(){
    if (index.value < quiz.questions.length - 1){
      index.value++;
      updateQuestion();
    }
  }
  void updateQuestion(){
    question.value = quiz.questions[index.value];
    choices = List<String>(question.value.answer.length);
    resetAnswerControllers();
  }
  String choicesAsString() {
    var result = '';
    for (var i = 0; i < question.value.answer.length; i++) {
      result += choices[i].toString().toUpperCase();
    }
    return result;
  }

  void resetAnswerControllers() {
    for (var i = 0; i < question.value.answer.length; i++) {
      choices[i] = QuizUtil.answerPlaceholder;
    }
  }
  bool validateAnswer(){
    return question.value.answer.toUpperCase() == choicesAsString();
  }


  String imageURL(String image){
    return 'quiz/resources/${quiz.category.category}/$image';
  }
}


/*

class QuizPage extends StatefulWidget {

  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage>
    with SingleTickerProviderStateMixin {
  QuizController _quizController = Get.put(QuizController());

  Question get context.watch<QuizModel>().question => context.watch<QuizModel>().question.value;

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    final Category category = ModalRoute.of(context).settings.arguments;
    print(category);

    //context.watch<QuizModel>().loadQuiz(Get.parameters['category']);
    */
/*context.watch<QuizModel>().loadQuiz(category.category);*/ /*

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack);

    _animationController.forward(from: 0.0);
  }

  Widget _quiz() {
    return Obx(() {
      if (context.watch<QuizModel>().question.value.question.isNotEmpty ||
          context.watch<QuizModel>().question.value.image.isNotEmpty) {
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
            context.watch<QuizModel>().progress,
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: fontSize),
          ),
        ),
        context.watch<QuizModel>().question.question.isNotEmpty
            ? Text(context.watch<QuizModel>().question.value.question, style: TextStyle(fontSize: fontSize),)
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
                  child: Image.asset(
                      context.watch<QuizModel>().imageURL(context.watch<QuizModel>().question.image)),
                ))
            : Container(),
      ],
    );
  }

  Padding _answerGroup() {
    List<Widget> widgets = List<Widget>();

    //answer's characters
    for (var i = 0; i < context.watch<QuizModel>().question.answer.length; i++) {
      widgets.add(SizedBox(
        width: 50,
        child: FlatButton(
          onPressed: () {
            //reset disable character and replace it in answer as well
            context.watch<QuizModel>().choices[i] = QuizUtil.answerPlaceholder;
            SystemSound.play(SystemSoundType.click);
            setState(() {});
          },
          child: Text(
            context.watch<QuizModel>().choices[i],
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
    if (context.watch<QuizModel>().index.value == context.watch<QuizModel>().quiz.questionCount - 1) {
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
                context.watch<QuizModel>().updateIndex();
                //play animation
                _animationController.forward(from: 0.0);
              },
            ),
          ]);
    }

    //choices
    for (var i = 0; i < context.watch<QuizModel>().question.randomChoices.length; i++) {
      String buttonValue = context.watch<QuizModel>().question.randomChoices[i];
      widgets.add(SizedBox(
        width: 50,
        child: OutlineButton(
          borderSide: BorderSide(color: AppConfig.textColor),
          onPressed: () {
            for (var i = 0; i < context.watch<QuizModel>().question.answer.length; i++) {
              if (context.watch<QuizModel>().choices[i] == QuizUtil.answerPlaceholder) {
                context.watch<QuizModel>().choices[i] = buttonValue;
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
              visible: context.watch<QuizModel>().validateAnswer(),
            ),
            Visibility(
              child: Wrap(
                children: widgets,
              ),
              visible: !context.watch<QuizModel>().validateAnswer(),
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
   */
/* SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: Get.parameters['category'] + ' ' + AppConfig.APP_NAME,
      primaryColor: Theme.of(context).primaryColor.value,
    ));*/ /*


    return Scaffold(
      appBar: MainAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text('aaa')//_quiz(),
        ),
      ),
    );
  }
}
*/
