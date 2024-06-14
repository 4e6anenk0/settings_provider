import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:settings_provider/settings_provider.dart';

const String envHost = 'HOST';
const String envKey = 'API_KEY';
const String envBaseUrl = 'BASE_URL';

class RemoteSettingsStorage implements ISettingsStorage {
  RemoteSettingsStorage();

  final String baseURL = dotenv.get(envBaseUrl);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-RapidAPI-Key': dotenv.get(envKey),
    'x-rapidapi-host': dotenv.get(envHost),
  };

  @override
  Future<void> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  FutureOr<T?> getSetting<T>(String id, Object defaultValue) async {
    final responce =
        await http.get(Uri.parse("$baseURL/settings/$id"), headers: headers);

    if (responce.statusCode == 200) {
      final data = jsonDecode(responce.body);
      return data['value'] as T;
    } else {
      return null;
    }
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isContains(String id) {
    // TODO: implement isContains
    throw UnimplementedError();
  }

  @override
  Future<bool> removeSetting(String id) {
    // TODO: implement removeSetting
    throw UnimplementedError();
  }

  @override
  Future<bool> setSetting(String id, Object value) async {
    final responce = await http.post(Uri.parse('$baseURL/settings'),
        headers: headers,
        body: jsonEncode({
          'id': id,
          'value': value,
        }));

    if (responce.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
