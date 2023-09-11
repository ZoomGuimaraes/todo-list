import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/widget/todo_list_fild.dart';
import 'package:todo_list/app/core/widget/todo_list_logo.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _paswordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      succesCallback: (notifier, listenerInstance) {
        print('Login efetuado com sucesso');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const TodoListLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TodoListFild(
                            label: 'E-mail',
                            controller: _emailEC,
                            focusNode: _emailFocus,
                            validator: Validatorless.multiple([
                              Validatorless.required('E-mail obrogatório'),
                              Validatorless.email('E-mail inválido')
                            ]),
                          ),
                          const SizedBox(height: 20),
                          TodoListFild(
                            label: 'Senha',
                            obscureText: true,
                            controller: _paswordEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrogatória'),
                              Validatorless.min(6,
                                  'Senha deve conter pelo menos 6 caracteres')
                            ]),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  if (_emailEC.text.isNotEmpty) {
                                    //Recuperar senha
                                    context
                                        .read<LoginController>()
                                        .forgotPassword(_emailEC.text);
                                  } else {
                                    _emailFocus.requestFocus();
                                    Messages.of(context).showError(
                                        'Digite um e-mail para recuperar a senha');
                                  }
                                },
                                child: const Text('Esqueceu sua senha?'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final formValid =
                                      _formKey.currentState?.validate() ??
                                          false;
                                  final email = _emailEC.text;
                                  final password = _paswordEC.text;
                                  if (formValid) {
                                    context
                                        .read<LoginController>()
                                        .login(email, password);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Login'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF0F3F7),
                        border: Border(
                          top: BorderSide(
                            width: 2,
                            color: Colors.grey.withAlpha(50),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          SignInButton(
                            Buttons.Google,
                            text: 'Continue com o Google',
                            padding: const EdgeInsets.all(5),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                            onPressed: () {
                              context.read<LoginController>().googleLogin();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Não tem conta?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  child: const Text('Cadastre-se'))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
