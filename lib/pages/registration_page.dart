import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Делаем сервис, сущность и провайдеры

class _AuthService {

}

class _RegistrationPageState {
  final String _login;
  String get login => _login;

  final String _password;
  String get password => _password;

  bool get isRegButtonEnable => login.isNotEmpty && password.length >= 8 ? true : false;

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
  var state = _RegistrationPageState('', '');

  void loginChanged(String login) {
    state = state.copyWith(login, null);
    notifyListeners();
  }

  void passwordChanged(String password) {
    state = state.copyWith(null, password);
    notifyListeners();
  }

  void onRegButtonPressed(){}
  void onAuthButtonPressed(){}
}

class RegistrationPageWidget extends StatelessWidget {
  const RegistrationPageWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _RegistrationPageViewModel(),
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
          decoration:  const InputDecoration(
            counterText: "",
            labelText: 'Логин',
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
            counterText: "",
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
          onPressed: isEnable ? viewModel.onRegButtonPressed : null,
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




