import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.transparent,
      ),
      drawer: NavigationDrawer(),
    );
  }
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/pic1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // CircleAvatar(
                //   radius: 52,
                //   backgroundImage: NetworkImage(
                //       'https://th.bing.com/th/id/OIP.zmKvgu3ZluHavumdJ9V_5gHaHa?pid=ImgDet&rs=1'),
                // ),
                SizedBox(height: 12),
                Text(
                  user.email!,
                  style: TextStyle(
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
              leading: const Icon(Icons.home_outlined),
              title: const Text('Menu'),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage())),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
                //Colocar aqui um Navigator.of(context).push(MaterialPageRoute(
                //builder: (context) => const Pagina()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.done_all_outlined),
              title: const Text('Feitos'),
              onTap: () {
                Navigator.pop(context);
                //Colocar aqui um Navigator.of(context).push(MaterialPageRoute(
                //builder: (context) => const Pagina()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmarks_sharp),
              title: const Text('Tags'),
              onTap: () {
                Navigator.pop(context);
                //Colocar aqui um Navigator.of(context).push(MaterialPageRoute(
                //builder: (context) => const Pagina()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                //Colocar aqui um Navigator.of(context).push(MaterialPageRoute(
                //builder: (context) => const Pagina()));
              },
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair da Conta'),
              onTap: signUserOut,
            ),
          ],
        ),
      );
}
