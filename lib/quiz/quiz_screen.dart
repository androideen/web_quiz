import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/appbar.dart';
import 'package:quiz/common/data.dart';
import 'package:quiz/quiz/quiz_model.dart';
import 'package:quiz/quiz/quiz_views.dart';
import 'package:quiz/quiz_category/category_screen.dart';

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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [QuestionCard(), ChoiceCard()],
      ),
    );
  }
}
