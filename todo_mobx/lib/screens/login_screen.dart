import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginStore loginStore = LoginStore();

  late ReactionDisposer disposer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //a reaction diferente do autorun não pega o valor inicial, espera uma mudança no valor
    //a reaction fica rodando sempre, então ela vai ver sempre que tiver uma alteração na loggedIn, por isso usamos disposer para não ficar consumindo recursos de forma desnecessária
    disposer = reaction(
      (_) => loginStore.loggedIn,
      (loggedIn) {
        if (loggedIn != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ListScreen()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Observer(builder: (_) {
                      return CustomTextField(
                        hint: 'E-mail',
                        prefix: Icon(Icons.account_circle),
                        textInputType: TextInputType.emailAddress,
                        onChanged: loginStore.setEmail,
                        enabled: !loginStore.loading,
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    Observer(builder: (_) {
                      return CustomTextField(
                        hint: 'Senha',
                        prefix: Icon(Icons.lock),
                        obscure: !loginStore.passwordVisible,
                        //passando aqui as actions eu já terei os respectivos campos observables alterados
                        onChanged: loginStore.setPassword,
                        enabled: !loginStore.loading,
                        suffix: CustomIconButton(
                          radius: 32,
                          iconData: loginStore.passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onTap: loginStore.togglePasswordVisibility,
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 44,
                        child: Observer(builder: (_) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                onSurface: Theme.of(context)
                                    .primaryColor
                                    .withAlpha(100),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32)),
                              ),
                              child: loginStore.loading
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                    ),
                              onPressed: loginStore.loginPressed);
                        }))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposer();
    super.dispose();
  }
}
