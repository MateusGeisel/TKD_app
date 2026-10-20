import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../utils/constants.dart';

class PessoaRepository {
  final url = '$baseURLApi/users';

  Future<List<UserModel>> getPessoas() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List users = data['users'];
      return users.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar usuários');
    }
  }
}
