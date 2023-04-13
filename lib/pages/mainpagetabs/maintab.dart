import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nirs/settings/settings.dart';
import 'package:provider/provider.dart';

class _ArticleEntity{
  final String _articleId;
  final String _articleTitle;
  final String _articleContent;
  final bool _isLiked;
  final String _imageUrl;

  String get articleId => _articleId;
  String get articleTitle => _articleTitle;
  String get articleContent => _articleContent;
  bool get isLiked => _isLiked;
  String get imageUrl => _imageUrl;

  _ArticleEntity(this._articleTitle, this._articleContent, this._isLiked, this._articleId, this._imageUrl);
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
  
  Future<dynamic> likeArticleResponse(String articleId, String id) async {
    var response = await http.post(
        Uri.parse(Settings.likeArticleLink + articleId),
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

class _MainTabService {
  final _storageProvider = _MainTabStorageProvider();
  final _apiProvider = _MainTabApiProvider();

  Future<_ArticleEntity?> loadArticle() async {
    String? id = await _storageProvider.getId();
    if (id != null) {
      var response = await _apiProvider.getArticleResponse(id);
      Map<String, dynamic> responseDecode = jsonDecode(utf8.decode(response.codeUnits));
      Map<String, dynamic> articleResponse = responseDecode['article'];
      String articleId = articleResponse['id'].toString();
      String articleTitle = articleResponse['name'];
      String articleContent = articleResponse['content'];
      bool isLiked = responseDecode['liked'].toString().toLowerCase() == 'true';
      String imageUrl = articleResponse['image_path'];

      if (articleTitle.isNotEmpty && articleContent.isNotEmpty) {
        return _ArticleEntity(articleTitle, articleContent, isLiked, articleId, imageUrl);
      }
    }
    return null;
  }

  Future<_ArticleEntity?> likeArticle() async {
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var currentArticle = await loadArticle();
    if (currentArticle == null) return null;
    if (currentArticle.isLiked) return null;
    await _apiProvider.likeArticleResponse(currentArticle.articleId, id);
    return await loadArticle();
  }

  Future<_ArticleEntity?> deleteArticleFromFav() async {
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var currentArticle = await loadArticle();
    if (currentArticle == null) return null;
    if (currentArticle.isLiked == false) return null;
    await _apiProvider.deleteArticleFromFavResponse(currentArticle.articleId, id);
    return await loadArticle();
  }
}

class _MainTabState {
  final String _articleTitle;
  String get articleTitle => _articleTitle;

  final String _articleContent;
  String get articleContent => _articleContent;

  final bool _isLiked;
  bool get isLiked => _isLiked;

  final String _imageUrl;
  String get imageUrl => _imageUrl;

  _MainTabState(this._articleTitle, this._articleContent, this._isLiked, this._imageUrl);

  _MainTabState copyWith(
      String? articleTitle,
      String? articleContent,
      bool? isAddButtonEnable,
      String? imageUrl
      )
  {
    return _MainTabState(
        articleTitle ?? _articleTitle,
        articleContent ?? _articleContent,
        isAddButtonEnable ?? _isLiked,
        imageUrl ?? _imageUrl
    );
  }

}

class _MainTabViewModel extends ChangeNotifier{
  var state = _MainTabState('Загрузка...', 'Загрузка...', false, '');
  var service = _MainTabService();

  _MainTabViewModel(){
    setArticle();
  }

  setArticle() async{
    var articleEntity = await service.loadArticle();
    if (articleEntity == null) {
      state = state.copyWith('Произошла ошибка загрузки', 'Нам очень жаль :( ', false, null);
      notifyListeners();
      return;
    }
    state = state.copyWith(articleEntity.articleTitle, articleEntity.articleContent, articleEntity.isLiked, articleEntity.imageUrl);
    notifyListeners();
  }

  onAddToFavoriteButtonPressed() async{
    var articleEntity = await service.likeArticle();
    if (articleEntity == null) return;
    state = state.copyWith(articleEntity.articleTitle, articleEntity.articleContent, articleEntity.isLiked, null);
    notifyListeners();
  }

  onDeleteFromFavoriteButtonPressed() async{
    var articleEntity = await service.deleteArticleFromFav();
    if (articleEntity == null) return;
    state = state.copyWith(articleEntity.articleTitle, articleEntity.articleContent, articleEntity.isLiked, null);
    notifyListeners();
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
            MainTabImageWidget(),
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

class MainTabImageWidget extends StatelessWidget {
  const MainTabImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = context.select((_MainTabViewModel viewModel) => viewModel.state.imageUrl);

    imageUrl ??= '';

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage('http://${Settings.ipAddress}$imageUrl'),
            fit: BoxFit.contain
        ),
      ),
      child: const SizedBox(
        width: 200,
        height: 200,
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
    var isLiked = context.select((_MainTabViewModel viewModel) => viewModel.state.isLiked);
    var viewModel = context.read<_MainTabViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: MaterialButton(
        color: Colors.orangeAccent,
        minWidth: 100,
        onPressed: isLiked ? viewModel.onDeleteFromFavoriteButtonPressed : viewModel.onAddToFavoriteButtonPressed,
        child: Text(
          isLiked ? 'Удалить из избранного' : 'Добавить в избранное',
          style: const TextStyle(
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

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 30,
              fontFamily: 'MontserratAlternates',
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.yellowAccent,
              color: Colors.black,

          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}