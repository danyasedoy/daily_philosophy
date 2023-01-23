import 'package:flutter/material.dart';

class _RegistrationPageState {
  final String _login;
  get login => _login;

  final String _password;
  get password => _password;

  final bool _regButtonEnable;

  _RegistrationPageState(this._login, this._password, this._regButtonEnable);

  _RegistrationPageState copyWith(
      String? login,
      String? password,
      bool? regButtonEnable
      )
  {
    return _RegistrationPageState(
        login ?? _login,
        password ?? _password,
        regButtonEnable ?? _regButtonEnable
    );
  }
}

class _RegistrationPageViewModel {
  var state = _RegistrationPageState('', '', false);


}

class RegistrationPageWidget extends StatelessWidget {
  const RegistrationPageWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: const [
                _WelcomeTextWidget(),
                _RegistrationTextFieldsWithBackground(),
                _RegistrationButton(),
                _AlreadyHaveAccountButton(),
              ],
            ),
          ],
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
    return const Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          style:  TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          textInputAction: TextInputAction.next,
          decoration:  InputDecoration(
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
    return const Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          style:  TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration:  InputDecoration(
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        child: ElevatedButton(
          onPressed: (){},
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

class _AlreadyHaveAccountButton extends StatelessWidget {
  const _AlreadyHaveAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 300, height: 50),
        child: ElevatedButton(
          onPressed: (){},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          child: const Text(
            "Уже есть аккаунт",
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
              "Пройдите регистрацию",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ]
      ),
    );
  }
}




