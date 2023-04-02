import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nirs/settings/settings.dart';
import 'package:provider/provider.dart';

class TestTabWidget extends StatefulWidget {
  const TestTabWidget({Key? key}) : super(key: key);

  @override
  State<TestTabWidget> createState() => _TestTabWidgetState();
}

class _ResultEntity {
  final String _userAnswer;
  final String _correctAnswer;

  _ResultEntity(this._userAnswer, this._correctAnswer);

  String get userAnswer => _userAnswer;
  String get correctAnswer => _correctAnswer;
}

class _UserEntity {
  final String _id;
  final String _login;
  final bool _isAnsweredToday;

  _UserEntity(this._id, this._login, this._isAnsweredToday);

  String get id => _id;
  String get login => _login;
  bool get isAnsweredToday => _isAnsweredToday;
}

class _AnswerEntity {
  final String _answerId;
  final String _answerText;

  _AnswerEntity(this._answerId, this._answerText);

  String get answerId => _answerId;
  String get answerText => _answerText;
}

class _QuestionEntity {
  final String _questionId;
  final String _questionText;
  final List<_AnswerEntity> _answers;

  _QuestionEntity(this._questionId, this._questionText, this._answers);

  String get questionId => _questionId;
  String get questionText => _questionText;
  List<_AnswerEntity> get answers => _answers;
}

class _TestTabStorageProvider {
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

class _TestTabApiProvider {
  Future<dynamic> getQuestionOfTheDay(String id) async{
    var response = await http.read(
        Uri.parse(Settings.questionOfTheDay),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        });
    return response;
  }

  Future<dynamic> getAnswerCheck(String id, String answerId) async{
    var response = await http.read(
        Uri.parse(Settings.answer+answerId+'/check'),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        });
    return response;
  }

  Future<dynamic> getUserInfo(String id) async{
    var response = await http.read(
        Uri.parse(Settings.userInfo),
        headers: <String, String>{
          'Authorization': 'Bearer $id'
        });
    return response;
  }
}

class _TestTabService {
  final _storageProvider = _TestTabStorageProvider();
  final _apiProvider = _TestTabApiProvider();

  Future<_UserEntity?> getUserEntity() async{
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var response = await _apiProvider.getUserInfo(id);
    var responseDecoded = jsonDecode(utf8.decode(response.codeUnits));
    _UserEntity user = _UserEntity(
      responseDecoded['id'].toString(),
      responseDecoded['login'],
      responseDecoded['isAnsweredToday'].toString() == 'true'
    );
    return user;
  }

  Future<_QuestionEntity?> getQuestionEntity() async{
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var response = await _apiProvider.getQuestionOfTheDay(id);
    var responseDecoded = jsonDecode(utf8.decode(response.codeUnits));
    _QuestionEntity question;
    List<_AnswerEntity> answers = <_AnswerEntity>[];
    var responseList = responseDecoded['answers'];
    for(var element in responseList) {
      answers.add(_AnswerEntity(
        element['id'].toString(),
        element['text']
      ));
    }
    question = _QuestionEntity(responseDecoded['id'].toString(), responseDecoded['text'], answers);
    return question;
  }

  Future<_ResultEntity?> getResultEntity(String answerId) async {
    String? id = await _storageProvider.getId();
    if (id == null) return null;
    var response = await _apiProvider.getAnswerCheck(id, answerId);
    var responseDecoded = jsonDecode(utf8.decode(response.codeUnits));

    var userAnswer = responseDecoded['userAnswer'];
    var correctAnswer = responseDecoded['correctAnswer'];

    _ResultEntity resultEntity = _ResultEntity(userAnswer['text'], correctAnswer['text']);
    return resultEntity;
  }
}

class _TestTabState {
  final _UserEntity? _userEntity;
  final _QuestionEntity? _questionEntity;
  final _AnswerEntity? _selectedAnswer;
  final _ResultEntity? _resultEntity;

  _UserEntity? get userEntity => _userEntity;
  _QuestionEntity? get questionEntity => _questionEntity;
  _AnswerEntity? get selectedAnswer => _selectedAnswer;
  _ResultEntity? get resultEntity => _resultEntity;

  _TestTabState copyWith(
      _UserEntity? userEntity,
      _QuestionEntity? questionEntity,
      _AnswerEntity? selectedAnswer,
      _ResultEntity? resultEntity
      )
  {
    return _TestTabState(
        userEntity ?? _userEntity,
      questionEntity ?? _questionEntity,
        selectedAnswer ?? _selectedAnswer,
      resultEntity ?? _resultEntity
    );
  }

  _TestTabState(this._userEntity, this._questionEntity, this._selectedAnswer, this._resultEntity);
}

class _TestTabViewModel extends ChangeNotifier{
  var state = _TestTabState(null, null, null, null);
  var service = _TestTabService();

  _TestTabViewModel() {
    getQuestionOfTheDay();
  }

  getQuestionOfTheDay() async{
    var question = await service.getQuestionEntity();
    var user = await service.getUserEntity();
    state = state.copyWith(user, question, null, null);
    notifyListeners();
  }

  onSendAnswerButtonPressed(String answerText) async{
    String answerId = '-1';
    for (var answer in state.questionEntity!.answers) {
      if (answer.answerText == answerText) {
        answerId = answer.answerId;
      }
    }
    _ResultEntity? result;
    if (answerId == '-1') {
      result = _ResultEntity('Ответ не найден', 'Ошибка');
      state = state.copyWith(null, null, null, result);
      notifyListeners();
    }
    result = await service.getResultEntity(answerId);
    var user = await service.getUserEntity();
    state = state.copyWith(user, null, null, result);

    notifyListeners();
  }
}

class _TestTabWidgetState extends State<TestTabWidget> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _TestTabViewModel(),
      child: Container(
        alignment: Alignment.center,
        width: 100,
        constraints: const BoxConstraints.tightFor(width: 410),
        child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Опрос',
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
                  _TestTitleWidget(),
                  _TestAnswersWidget(),
                ]
            )]
        ),
      ),
    );
  }
}

class _TestTitleWidget extends StatefulWidget {
  const _TestTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<_TestTitleWidget> createState() => _TestTitleWidgetState();
}

class _TestTitleWidgetState extends State<_TestTitleWidget> {
  @override
  Widget build(BuildContext context) {
    String? testTitle = context.select((_TestTabViewModel viewModel) => viewModel.state.questionEntity?.questionText);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Text(
          testTitle ?? 'Загрузка опроса',
          style: const TextStyle(
              fontSize: 26,
              fontFamily: 'MontserratAlternates'
          ),
        ),
      ),
    );
  }
}

class _TestAnswersWidget extends StatefulWidget {
  const _TestAnswersWidget({Key? key}) : super(key: key);

  @override
  State<_TestAnswersWidget> createState() => _TestAnswersWidgetState();
}

class _TestAnswersWidgetState extends State<_TestAnswersWidget> {
  _AnswerEntity? currentAnswer = _AnswerEntity('-1', 'curAnsError');
  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<_TestTabViewModel>();
    List<_AnswerEntity>? answersList = context.select((_TestTabViewModel viewModel) => viewModel.state.questionEntity?.answers);
    bool isAnswered = context.select((_TestTabViewModel viewModel) => viewModel.state.userEntity == null ? false : viewModel.state.userEntity!.isAnsweredToday);
    _ResultEntity? resultEntity = context.select((_TestTabViewModel viewModel) => viewModel.state.resultEntity);

    return Column(
      children: [
        RadioListTile<_AnswerEntity>(
          activeColor: Colors.yellow,
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(answersList == null  || answersList.isEmpty ? 'Загрузка' : answersList.elementAt(0).answerText, style: const TextStyle(
              fontSize: 26,
              fontFamily: 'MontserratAlternates'
          ),),
          groupValue: currentAnswer,
          selected: answersList == null ?
          true :
          currentAnswer!.answerText == answersList.elementAt(0).answerText,
          value: answersList == null ? _AnswerEntity('-1', 'LoadingError') : answersList.elementAt(0),
          onChanged:(_AnswerEntity? value)  {
            setState(() {
            currentAnswer = value ;
          });},
        ),
        RadioListTile<_AnswerEntity>(
          activeColor: Colors.yellow,
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(answersList == null  || answersList.isEmpty ? 'Загрузка' : answersList.elementAt(1).answerText, style: const TextStyle(
              fontSize: 26,
              fontFamily: 'MontserratAlternates'
          ),),
          groupValue: currentAnswer,
          selected: answersList == null ? false : answersList.elementAt(1).answerText.endsWith(currentAnswer!.answerText),
          value: answersList == null ? _AnswerEntity('-1', 'LoadingError') : answersList.elementAt(1),
          onChanged:(_AnswerEntity? value)  { setState(() {
            currentAnswer = value ;
          });},
        ),
        RadioListTile<_AnswerEntity>(
          activeColor: Colors.yellow,
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(answersList == null  || answersList.isEmpty ? 'Загрузка' : answersList.elementAt(2).answerText, style: const TextStyle(
              fontSize: 26,
              fontFamily: 'MontserratAlternates'
          ),),
          groupValue: currentAnswer,
          selected: answersList == null ? false : answersList.elementAt(2).answerText.endsWith(currentAnswer!.answerText),
          value: answersList == null ? _AnswerEntity('-1', 'LoadingError') : answersList.elementAt(2),
          onChanged:(_AnswerEntity? value)  { setState(() {
            currentAnswer = value ;
          });},
        ),
        RadioListTile<_AnswerEntity>(
          activeColor: Colors.yellow,
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(answersList == null  || answersList.isEmpty ? 'Загрузка' : answersList.elementAt(3).answerText, style: const TextStyle(
              fontSize: 26,
              fontFamily: 'MontserratAlternates'
          ),),
          groupValue: currentAnswer,
          selected: answersList == null ? false : answersList.elementAt(3).answerText.endsWith(currentAnswer!.answerText),
          value: answersList == null ? _AnswerEntity('-1', 'LoadingError') : answersList.elementAt(3),
          onChanged:(_AnswerEntity? value)  { setState(() {
            currentAnswer = value ;
          });},
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              resultEntity == null ? '' : 'Ваш ответ: ${resultEntity.userAnswer}. \nПравильный ответ: ${resultEntity.correctAnswer}',
              style: const TextStyle(
                fontSize: 26,
                fontFamily: 'MontserratAlternates',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: MaterialButton(
            color: Colors.orangeAccent,
            minWidth: 100,
            onPressed: isAnswered || currentAnswer!.answerId == '-1' || currentAnswer == null ? null : (){
              viewModel.onSendAnswerButtonPressed(currentAnswer!.answerText);
            },
            child: Text(
              isAnswered ? 'Ответ отправлен' : 'Отправить',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'MontserratAlternates',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}

