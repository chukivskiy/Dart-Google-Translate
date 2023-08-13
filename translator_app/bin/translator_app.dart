import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:ansicolor/ansicolor.dart';

Future<void> main() async {
  print('Welcome to Translation App!');
  var pen = AnsiPen()..green(bold: true);
  while (true) {
    print(pen('Enter a command (translate, detect, or end):'));
    String? command = stdin.readLineSync();

    if (command == 'end') {
      print('Goodbye!');
      break;
    } else if (command == 'translate') {
      print('Enter a word to translate:');
      String? word = stdin.readLineSync();
      print('Target language for translation of the word:');
      String? lang = stdin.readLineSync();
      await translateWord(word, lang);
    } else if (command == 'detect') {
      print('Enter a text to detect its language:');
      String? text = stdin.readLineSync();
      await detectLanguage(text);
    } else {
      print('Invalid command. Please enter translate, detect, or end.');
    }
  }
}

Future<void> detectLanguage(String? word) async {
  var apiKey = "c9db842bbfmsh045408514bbe19fp1873d7jsn0821679dbe8e";
  var url = Uri.parse(
      "https://google-translate1.p.rapidapi.com/language/translate/v2/detect");

  var headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept-Encoding": "application/gzip",
    "X-RapidAPI-Host": "google-translate1.p.rapidapi.com",
    "X-RapidAPI-Key": "c9db842bbfmsh045408514bbe19fp1873d7jsn0821679dbe8e",
  };

  String text = word!;

  try {
    final dio = Dio();
    final response = await dio.post(
      url.toString(),
      options: Options(headers: headers),
      data: {"q": text},
    );

    if (response.statusCode == 200) {
      var jsonResponse = response.data;
      var language = jsonResponse['data']['detections'][0][0]['language'];
      print('Detected language: $language');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<void> translateWord(String? word, String? lang) async {
  var apiKey = "c9db842bbfmsh045408514bbe19fp1873d7jsn0821679dbe8e";
  var url = Uri.parse(
      "https://google-translate1.p.rapidapi.com/language/translate/v2");

  var headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept-Encoding": "application/gzip",
    "X-RapidAPI-Host": "google-translate1.p.rapidapi.com",
    "X-RapidAPI-Key": "c9db842bbfmsh045408514bbe19fp1873d7jsn0821679dbe8e",
  };

  String text = word!;
  String language = lang!;

  try {
    final dio = Dio();
    final response = await dio.post(
      url.toString(),
      options: Options(headers: headers),
      data: {"q": text, "target": language},
    );

    if (response.statusCode == 200) {
      var jsonResponse = response.data;
      var translation =
          jsonResponse['data']['translations'][0]['translatedText'];
      print('Translation: $translation');
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

