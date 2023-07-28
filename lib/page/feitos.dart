import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tarefas/page/perfil.dart';
import 'package:tarefas/page/tags.dart';

import '../config/custom_colors.dart';
import 'favoritos.dart';
import 'home_page.dart';

class FeitosPage extends StatelessWidget {
  const FeitosPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Feitos'),
          backgroundColor: Colors.transparent,
        ),
      );
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.grey,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/pic1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Menu'),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage())),
            ),
            ListTile(
              leading: Icon(
                Icons.favorite_border,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FavoritosPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.done_all_outlined,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Feitos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FeitosPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmarks_sharp,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Tags'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TagsPage(
                          title: '',
                        )));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PerfilPage()));
              },
            ),
            Divider(
              thickness: 1,
              color: CustomColors.customContrastColor,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Sair da Conta'),
              onTap: signUserOut,
            ),
          ],
        ),
      );
}
