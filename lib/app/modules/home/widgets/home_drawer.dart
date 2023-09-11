import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) {
                    return authProvider.user?.photoURL ??
                        'https://e7.pngegg.com/pngimages/786/680/png-clipart-computer-icons-user-profile-avatar-heroes-black.png';
                  },
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) {
                        return authProvider.user?.displayName ??
                            'Nome não informado';
                      },
                      builder: (_, value, __) {
                        return Text(
                          value,
                          style: context.textTheme.bodyLarge,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Alterar Nome'),
                      content: TextField(
                        onChanged: (value) => nameVN.value = value,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError('Nome obrigatório');
                              } else {
                                Loader.show(context);
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(nameValue);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Alterar')),
                      ],
                    );
                  });
            },
            title: const Text('Alterar Nome'),
          ),
          ListTile(
            onTap: () => context.read<AuthProvider>().logout(),
            title: const Text('Sair'),
          )
        ],
      ),
    );
  }
}
