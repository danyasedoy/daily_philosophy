import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nirs/settings/settings.dart';
import 'package:provider/provider.dart';

class _ArticleEntity{
  final String _articleTitle;
  final String _articleContent;

  get articleTitle => _articleTitle;
  get articleContent => _articleContent;

  _ArticleEntity(this._articleTitle, this._articleContent);
}

class _MainTabStorageProvider{
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> getId() async {
    String? id = await _secureStorage.read(key: 'id');
    if (id == null) return null;
    if (id.isNotEmpty) {
      return id;
    }
    return null;
  }
}

class _MainTabApiProvider{
  Future<dynamic> getArticleResponse(String id) async {
    var response = await http.read(
        Uri.parse(Settings.articleOfTheDayLink),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        }
    );
    return response;
  }
}

class _MainTabService {
  final _storageProvider = _MainTabStorageProvider();
  final _apiProvider = _MainTabApiProvider();

  Future<_ArticleEntity?> loadArticle() async {
    String? id = await _storageProvider.getId();
    if (id != null) {
      var response = await _apiProvider.getArticleResponse(id);
      Map<String, dynamic> responseDecode = jsonDecode(utf8.decode(response.codeUnits));
      String articleTitle = responseDecode['name'];
      String articleContent = responseDecode['content'];

      if (articleTitle.isNotEmpty && articleContent.isNotEmpty) {
        return _ArticleEntity(articleTitle, articleContent);
      }
    }
    return null;
  }
}

class _MainTabState {
  final String _articleTitle;
  String get articleTitle => _articleTitle;

  final String _articleContent;
  String get articleContent => _articleContent;

  //TODO
  // метод для определения добавлена статья или нет
  bool isAddButtonEnable() => false;

  _MainTabState(this._articleTitle, this._articleContent);

  _MainTabState copyWith(
      String? articleTitle,
      String? articleContent
      )
  {
    return _MainTabState(
        articleTitle ?? _articleTitle,
        articleContent ?? _articleContent
    );
  }

}

class _MainTabViewModel extends ChangeNotifier{
  var state = _MainTabState('_articleTitle', '_articleContent');
  var service = _MainTabService();

  _MainTabViewModel(){
    setArticle();
  }

  setArticle() async{
    var articleEntity = await service.loadArticle();
    if (articleEntity == null) {
      state = state.copyWith('Произошла ошибка загрузки', 'Нам очень жаль :( ');
      notifyListeners();
      return;
    }
    state = state.copyWith(articleEntity.articleTitle, articleEntity.articleContent);
    notifyListeners();
  }

  onAddToFavoriteButtonPressed() {
    //TODO
  }

}

class MainTabWidget extends StatefulWidget {
  const MainTabWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MainTabWidget> createState() => _MainTabWidgetState();
}

class _MainTabWidgetState extends State<MainTabWidget> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MainTabViewModel(),
      child: Container(
        alignment: Alignment.center,
        width: 100,
        constraints: const BoxConstraints.tightFor(width: 410),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: const [
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Сегодня, для Вас...',
                  style: TextStyle(
                      fontSize: 36,
                      fontFamily: 'MontserratAlternates'
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.yellow,
              thickness: 5,
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(height: 50,),
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/philo.png'),
                    fit: BoxFit.contain
                ),
              ),
              child: SizedBox(
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 30,),
            _MainTabArticleTitleWidget(),
            SizedBox(height: 30,),
            _MainTabArticleContentWidget(),
            SizedBox(height: 30,),
            _MainTabAddToFavButtonWidget(),
          ],
        ),
      ),
    );
  }
}

class _MainTabAddToFavButtonWidget extends StatelessWidget {
  const _MainTabAddToFavButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isEnable = context.select((_MainTabViewModel viewModel) => viewModel.state.isAddButtonEnable());
    var viewModel = context.read<_MainTabViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: MaterialButton(
        color: Colors.orangeAccent,
        minWidth: 100,
        onPressed: isEnable ? viewModel.onAddToFavoriteButtonPressed : null,
        child: const Text(
          'Добавить в избранное',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'MontserratAlternates',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MainTabArticleContentWidget extends StatelessWidget {
  const _MainTabArticleContentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content = context.select((_MainTabViewModel viewModel) => viewModel.state.articleContent);

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          content,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'MontserratAlternates',
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

class _MainTabArticleTitleWidget extends StatelessWidget {
  const _MainTabArticleTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = context.select((_MainTabViewModel viewModel) => viewModel.state.articleTitle);

    return  Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 30,
            fontFamily: 'MontserratAlternates',
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.yellowAccent,
            color: Colors.black
        ),
      ),
    );
  }
}