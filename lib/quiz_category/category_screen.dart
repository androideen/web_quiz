import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz/common/app.dart';
import 'package:quiz/common/appbar.dart';
import 'package:quiz/common/data.dart';
import 'package:quiz/quiz/quiz_screen.dart';
import 'package:quiz/quiz_category/category_repository.dart';

class CategoryPage extends StatefulWidget {
  static const routeName = '/';

  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  CategoryRepository _categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
  }

  Widget _card(BuildContext context, AsyncSnapshot<List<Category>> snapshot,
      int gridCount, int index) {
    Widget parent = gridCount == 1
        ? Container(color: AppConfig.containerColor)
        : Card(color: AppConfig.containerColor);
    return Container(
      width: double.infinity,
      color: AppConfig.containerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${snapshot.data[index].description}',
              style: TextStyle(
                  color: AppConfig.textColorInContainer, fontSize: 36)),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('START',
                style: TextStyle(
                    color: AppConfig.textColorInContainer, fontSize: 18)),
            onPressed: () {
              Navigator.pushNamed(context, QuizPage.routeName,
                  arguments: Category(snapshot.data[index].category,
                      snapshot.data[index].description));
            },
          )
        ],
      ),
    );
  }

  FutureBuilder _grid(int gridCount) {
    return FutureBuilder<List<Category>>(
        initialData: [],
        future: _categoryRepository.categories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: Text("There is no quiz categories...."));

          //display one card at the center if there is only one category
          if (snapshot.data.length == 1) {
            return Center(child: _card(context, snapshot, gridCount, 0));
          } else {
            //display as grid if there is more than one category
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _card(context, snapshot, gridCount, index);
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    //grid count based on screen size
    final int gridCount = queryData.size.width > 729 ? 4 : 2;

    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: AppConfig.APP_NAME,
      primaryColor: Theme.of(context).primaryColor.value,
    ));

    return Scaffold(
        appBar: MainAppBar(),
        body: SafeArea(
          child: _grid(gridCount),
        ));
  }
}
