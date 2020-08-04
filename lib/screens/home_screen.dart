import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:quiz/constants/app.dart';
import 'package:quiz/models/quiz.dart';
import 'package:quiz/utils/quiz_utils.dart';
import 'package:quiz/widgets/appbar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  FutureBuilder _grid(int gridCount) {
    return FutureBuilder<List<Category>>(
        initialData: [],
        future: QuizUtil.loadQuizzes(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (!snapshot.hasData) return new Text("Loading....");

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return SafeArea(
                  child: Card(
                    color: AppConfig.primaryColor,
                    child: FlatButton(
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 5.0,
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('${snapshot.data[index].description}',
                              style: TextStyle(color: AppConfig.textColor, fontSize: 24)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: AppConfig.textColor,
                              ),
                              SizedBox(width: 10),
                              Text('START',
                                  style: TextStyle(color: AppConfig.textColor))
                            ],
                          )
                        ],
                      ),
                      onPressed: () {
                        Get.toNamed('/quiz/${snapshot.data[index].category}');
                      },
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final int gridCount = queryData.size.width > 729 ? 4 : 2;

    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: AppConfig.APP_NAME,
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    return Scaffold(
        appBar: MainAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: _grid(gridCount),
            ),
          ),
        ));
  }
}
