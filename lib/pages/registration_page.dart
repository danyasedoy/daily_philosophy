import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nirs/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// Делаем сервис, сущность и провайдеры

class _AuthEntity {
  final String _id;
  String get id => _id;

  _AuthEntity(this._id);
}

class _AuthStorageDataProvider {
  final _storage = const FlutterSecureStorage();

  Future<_AuthEntity?> getEntity() async {
    var id = await _storage.read(key: 'id');
    if (id == null) return null;
    return _AuthEntity(id);
  }

  Future<void> saveEntity(_AuthEntity entity) async {
    await _storage.write(key: 'id', value: entity.id);
  }

  write(String key, String value) async => await _storage.write(key: key, value: value);
  delete(String key) async => await _storage.delete(key: key);
}

class _AuthApiProvider {
  Future<String?> auth(String login, String password) async {
    if (login.isEmpty || password.isEmpty) return null;
    var response = await http.post(
      Uri.parse(Settings.authQueryLink),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "login": login,
        "password": password
      }),
    );

    if (response.statusCode != 200) {
      throw response.body;
    } else {
      return response.body;
    }
  }

  Future<String?> register(String login, String password) async {
    if (login.isEmpty || password.isEmpty) return null;
    var response = await http.post(
      Uri.parse(Settings.registerQueryLink),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "login": login,
        "password": password
      }),
    );
    if (response.statusCode != 200) {
      return null;
    } else {
      return '1';
    }
  }
}

class _AuthService {
  final _storageDataProvider = _AuthStorageDataProvider();
  final _apiProvider = _AuthApiProvider();

  Future<_AuthEntity?> findSavedUser() async{
    // TODO
    // needs to be changed ! ! !
    return await _storageDataProvider.getEntity();
  }

  Future<_AuthEntity?> auth(String login, String password) async{
    String? apiResponse = await _apiProvider.auth(login, password);
    if (apiResponse == null || apiResponse.isEmpty) {
      throw 'Некорректные данные';
    }
    final entity = _AuthEntity(apiResponse);
    await _storageDataProvider.saveEntity(entity);
    return entity;
  }

  Future<_AuthEntity?> register(String login, String password) async{
    String? apiResponse = await _apiProvider.register(login, password);
    if (apiResponse == null) {
      throw 'Произошла ошибка';
    }
    final entity = _AuthEntity(apiResponse);
    await _storageDataProvider.saveEntity(entity);
    return entity;
  }

}

class _RegistrationPageState {
  final String _login;
  String get login => _login;

  final String _password;
  String get password => _password;

  bool get isRegButtonEnable => login.isNotEmpty && password.length >= 8 ? true : false;

  String errorMessage = '';
  String notificationMessage='Ошибка при регистрации';

  String get notMessage => notificationMessage;

  _RegistrationPageState(this._login, this._password);

  _RegistrationPageState copyWith(
      String? login,
      String? password
      )
  {
    return _RegistrationPageState(
        login ?? _login,
        password ?? _password
    );
  }
}

class _RegistrationPageViewModel extends ChangeNotifier{
  final BuildContext context;
  _RegistrationPageViewModel(this.context);

  var state = _RegistrationPageState('', '');
  var authService = _AuthService();

  void loginChanged(String login) {
    state = state.copyWith(login, null);
    notifyListeners();
  }

  void passwordChanged(String password) {
    state = state.copyWith(null, password);
    notifyListeners();
  }

  Future<bool> onRegButtonPressed() async{
    try {
      var entity = await authService.register(state.login, state.password);
      if (entity == null) {
        state.errorMessage = 'Неизвестная ошибка';
        notifyListeners();
        return false;
      }
      notifyListeners();
      return true;
    }
    catch (errorMessage) {
      state.errorMessage = errorMessage.toString();
      notifyListeners();
      return false;
    }
  }

  void onAuthButtonPressed() async{
    try {
      var entity = await authService.auth(state.login, state.password);
      if (entity == null) {
        state.errorMessage = 'Неизвестная ошибка';
        notifyListeners();
        return;
      }
      if (await authService.findSavedUser() != null) {
        Navigator.of(context).pushNamed('/main');
        notifyListeners();
      }
    }
    catch (errorMessage) {
      state.errorMessage = errorMessage.toString();
      notifyListeners();
    }
  }
}

class RegistrationPageWidget extends StatefulWidget {
  const RegistrationPageWidget ({Key? key}) : super(key: key);

  @override
  State<RegistrationPageWidget> createState() => _RegistrationPageWidgetState();
}

class _RegistrationPageWidgetState extends State<RegistrationPageWidget> {
  @override
  void initState() {
    //_checkForSavedUser();
    super.initState();
  }

  _checkForSavedUser() async {
    final viewModel = _RegistrationPageViewModel(context);
    if (await viewModel.authService.findSavedUser() != null) {
      // TODO
      // описать логику при сценарии, когда
      // пользователь уже сохранен в кэше
      // переход на основной экран
      Navigator.of(context).pushNamed('/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _RegistrationPageViewModel(context),
      child: Scaffold(
          body : ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: const [
                  _WelcomeTextWidget(),
                  _RegistrationTextFieldsWithBackground(),
                  _RegistrationButton(),
                  _AuthButton(),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

class _RegistrationTextFieldsWithBackground extends StatelessWidget {
  const _RegistrationTextFieldsWithBackground({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 400,
          ),
          height: MediaQuery.of(context).size.width,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).canvasColor,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0, 1],
            ),
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/registration_bg_image.jpg"),
            ),
          ),
        ),
        Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              _LoginTextFieldWidget(),
              SizedBox(height: 20),
              _PasswordTextFieldWidget(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ]
    );
  }
}

class _RegPageTextFieldBorder extends OutlineInputBorder {
  static const OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.yellow,
        width: 4,
        style: BorderStyle.solid,
      ),
  );
}

class _LoginTextFieldWidget extends StatelessWidget {
  const _LoginTextFieldWidget({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<_RegistrationPageViewModel>();
    String errorText = context.select((_RegistrationPageViewModel model) => model.state.errorMessage);

    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          ],
          onChanged: viewModel.loginChanged,
          maxLength: 20,
          style:  const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          textInputAction: TextInputAction.next,
          decoration:  InputDecoration(
            counterText: "",
            errorText: errorText.isEmpty ? null : errorText,
            labelText: 'Логин',
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            fillColor: Colors.black45,
            filled: true,
            enabledBorder: _RegPageTextFieldBorder.border,
            focusedBorder: _RegPageTextFieldBorder.border,
            errorBorder: _RegPageTextFieldBorder.border,
            focusedErrorBorder: _RegPageTextFieldBorder.border,
          ),
        ),
      ),
    );
  }
}

class _PasswordTextFieldWidget extends StatelessWidget {
  const _PasswordTextFieldWidget({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<_RegistrationPageViewModel>();

    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
          ],
          maxLength: 20,
          onChanged: viewModel.passwordChanged,
          style:  const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration:  const InputDecoration(
            counterText: "Минимум 8 символов",
            labelText: 'Пароль',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            fillColor: Colors.black45,
            filled: true,
            enabledBorder: _RegPageTextFieldBorder.border,
            focusedBorder: _RegPageTextFieldBorder.border,
          ),
        ),
      ),
    );
  }
}

class _RegistrationButton extends StatelessWidget {
  const _RegistrationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isEnable = context.select((_RegistrationPageViewModel viewModel) => viewModel.state.isRegButtonEnable);
    var viewModel = context.read<_RegistrationPageViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        child: ElevatedButton(
          onPressed: isEnable ? () async{
            if (await viewModel.onRegButtonPressed()) {
              final snackBar = SnackBar(
                content: const Text('Успех! Необходима авторизация.'),
                action: SnackBarAction(
                  label: 'Закрыть',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow,
          ),
          child: const Text(
            "Регистрация",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isEnable = context.select((_RegistrationPageViewModel viewModel) => viewModel.state.isRegButtonEnable);
    var viewModel = context.read<_RegistrationPageViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        child: ElevatedButton(
          onPressed: isEnable ? viewModel.onAuthButtonPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          child: const Text(
            "Войти",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeTextWidget extends StatelessWidget {
  const _WelcomeTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          children: [
            Text(
              "Добро пожаловать!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Пожалуйста, авторизуйтесь",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]
      ),
    );
  }
}




