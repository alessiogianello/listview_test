import 'package:flutter/material.dart';
import 'package:listview_test/details.dart';
import 'package:listview_test/users.dart';
import 'package:listview_test/userservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<Future<int>> lengthProvider =
    Provider((ref) => UserService.getUsersLength());

userProvider(int index) {
  final Provider<Future<User>> userProvider =
      Provider((ref) => UserService.getUser(index));
  return userProvider;
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lengthFuture = ref.watch(lengthProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Users"),
        ),
        body: FutureBuilder<int>(
          future: lengthFuture,
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

class UserTile extends ConsumerWidget {
  final int index;
  UserTile({required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<User> userFuture = ref.watch(userProvider(index + 1));
    return FutureBuilder(
        future: userFuture,
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
