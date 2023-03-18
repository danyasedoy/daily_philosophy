import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nirs/settings/settings.dart';
import 'package:provider/provider.dart';

class _ArticleEntity {
  final String _articleId;
  final String _articleTitle;
  final String _articleContent;
  final bool _isLiked;

  String get articleId => _articleId;
  String get articleTitle => _articleTitle;
  String get articleContent => _articleContent;
  bool get isLiked => _isLiked;

  _ArticleEntity(this._articleId, this._articleTitle, this._articleContent, this._isLiked);
}

/*class _ArticleListEntity {
  final List<_ArticleEntity> _articlesList;

  List get articlesList => _articlesList;
  int get count => articlesList.length;

  _ArticleListEntity(this._articlesList);
}*/

class _FavoriteListStorageProvider{
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

class _FavoriteListApiProvider{
  Future<dynamic> getFavArticlesResponse(String id) async {
    var response = await http.read(
        Uri.parse(Settings.favArticlesListLink),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        }
    );
    return response;
  }
  Future<dynamic> deleteArticleFromFavResponse(String articleId, String id) async {
    var response = await http.post(
        Uri.parse(Settings.deleteArticleFromFavLink + articleId),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        }
    );
    return response;
  }
}

class _FavoriteListService{
  final _storageProvider = _FavoriteListStorageProvider();
  final _apiProvider = _FavoriteListApiProvider();

  Future<List<_ArticleEntity>?> getFavArticles() async{
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var response = await _apiProvider.getFavArticlesResponse(id);
    List<dynamic> responseDecode = jsonDecode(utf8.decode(response.codeUnits));
    List<_ArticleEntity> articlesList = <_ArticleEntity>[];
    for (var article in responseDecode) {
      articlesList.add(_ArticleEntity(article['id'].toString(), article['name'], article['content'], true));
    }
    return articlesList;
  }

  Future<void> deleteArticleFromFavList(String articleId) async{
    String? id = await _storageProvider.getId();
    if (id == null) return;
    await _apiProvider.deleteArticleFromFavResponse(articleId, id);
  }
}

class _FavoriteListState {
  final List<_ArticleEntity>? _favArticles;
  List<_ArticleEntity>? get favArticles => _favArticles;

  _FavoriteListState(this._favArticles);

  _FavoriteListState copyWith(
      List<_ArticleEntity>? favArticles
      )
  {
    return _FavoriteListState(
        favArticles ?? _favArticles
    );
  }
}

class _FavoriteListViewModel extends ChangeNotifier{
  var state = _FavoriteListState(null);
  var service = _FavoriteListService();
  final context;

  _FavoriteListViewModel(this.context) {
    getFavArticlesList();
  }

  getFavArticlesList() async{
    var articles = await service.getFavArticles();
    state = _FavoriteListState(articles);
    notifyListeners();
  }

  onTapArticle(int index) {
    var article = state.favArticles![index];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _FavoriteArticleWidget(article: article)),
    );
  }

  onTapDeleteArticle(int index) async {
    // set up the buttons
    MaterialButton cancelButton = MaterialButton(
      child: const Text("Отмена"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    MaterialButton continueButton = MaterialButton(
      child: const Text("Удалить"),
      onPressed:  () async{
        // удаление
        var article = state.favArticles![index];
        await service.deleteArticleFromFavList(article.articleId);
        await getFavArticlesList();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Удаление"),
      content: const Text("Вы действительно хотите удалить запись из избранного?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

class FavoriteListTabWidget extends StatefulWidget {
  const FavoriteListTabWidget({Key? key}) : super(key: key);

  @override
  State<FavoriteListTabWidget> createState() => _FavoriteListTabWidgetState();
}

class _FavoriteListTabWidgetState extends State<FavoriteListTabWidget> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _FavoriteListViewModel(context),
      child: Container(
        alignment: Alignment.center,
        width: 100,
        constraints: const BoxConstraints.tightFor(width: 410),
        child: Column(
          children: const [
            SizedBox(
              height: 44,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Избранное',
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
            SizedBox(height: 24,),
            Expanded(child: FavArticlesListWidget()),
          ],
        ),
      ),
    );
  }
}

class FavArticlesListWidget extends StatelessWidget {
  const FavArticlesListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<_FavoriteListViewModel>();
    var articlesList = context.select((_FavoriteListViewModel viewModel) => viewModel.state.favArticles);
    if (articlesList == null || articlesList.isEmpty) {
      return const Text(
        'Вы еще ничего не добавили в избранное',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'MontserratAlternates'
      ),);
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: articlesList.length,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.orangeAccent,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: InkWell(
                  onTap: (){ viewModel.onTapArticle(index); },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                        articlesList[index].articleTitle,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'MontserratAlternates',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: (){
                  viewModel.onTapDeleteArticle(index);
                },
                icon: const Icon(Icons.cancel),
                iconSize: 38,
              ),
            ]
          ),
        );
      },
    );
  }
}


class _FavoriteArticleWidget extends StatelessWidget {
  const _FavoriteArticleWidget({Key? key, required this.article}) : super(key: key);

  final _ArticleEntity article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          width: 100,
          constraints: const BoxConstraints.tightFor(width: 410),
          child: ListView(
              physics: const BouncingScrollPhysics(),
              children:  [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Избранное',
                      style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'MontserratAlternates'
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                  thickness: 5,
                  indent: 30,
                  endIndent: 30,
                ),
                const SizedBox(height: 50,),
                const DecoratedBox(
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
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Center(
                    child: Text(
                      article.articleTitle,
                      style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'MontserratAlternates',
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.yellowAccent,
                          color: Colors.black
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      article.articleContent,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'MontserratAlternates',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: MaterialButton(
                    color: Colors.orangeAccent,
                    minWidth: 100,
                    onPressed: (){Navigator.pop(context);},
                    child: const Text(
                      'Назад',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'MontserratAlternates',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]
          )
      ),
    );
  }
}