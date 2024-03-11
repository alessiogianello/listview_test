import 'package:flutter/material.dart';
import 'package:listview_test/details.dart';
import 'package:listview_test/users.dart';
import 'package:listview_test/userservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<int>? _usersLengthFuture;

  @override
  void initState() {
    super.initState();
    _usersLengthFuture = UserService.getUsersLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: FutureBuilder<int>(
          future: _usersLengthFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Errore di caricamento: ${snapshot.error}");
            }

            final length = snapshot.data ?? 0;

            return ListView.builder(
              itemCount: length,
              itemBuilder: (context, index) {
                return UserTile(index: index);
              }, // This trailing comma makes auto-formatting nicer for build methods.
            );
          },
        ));
  }
}

class UserTile extends StatefulWidget {
  const UserTile({super.key, required this.index});

  final int index;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  Future<User>? _userFuture;
  @override
  void initState() {
    super.initState();
    _userFuture = UserService.getUser(widget.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("impossibile caricare utente ${snapshot.error}");
          }

          final user = snapshot.data ??
              User(id: 0, name: "Name", userName: "Username", email: "email");

          return ListTile(
              title: Row(
            children: [
              Text(user.name),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Details_page(user: user)));
                  },
                  child: const Text("Dettagli"))
            ],
          ));
        });
  }
}
