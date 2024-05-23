import 'package:flutter/material.dart';
import 'services/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.initialize();
  runApp(const MyApp());
}
