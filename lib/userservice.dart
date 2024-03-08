import 'dart:convert';

import 'package:listview_test/users.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<User>> getUsers() async {
    const String url = 'https://jsonplaceholder.typicode.com/users';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception(
          'Impossibile caricare gli utenti, errore: ${response.statusCode}');
    }
  }
}
