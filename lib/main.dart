import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String supabaseUrl;
  String supabaseKey;

  try {
    await dotenv.load();
    supabaseUrl = dotenv.env['SUPABASE_URL']!;
    supabaseKey = dotenv.env['SUPABASE_ANON_KEY']!;
  } catch (e) {
    print('Could not load .env: $e');
    supabaseUrl = 'https://xhbuzgwkgwbparyajauu.supabase.co';
    supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhoYnV6Z3drZ3dicGFyeWFqYXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEyMDYxMjQsImV4cCI6MjA2Njc4MjEyNH0.VDeE4kRbgFo8vvkws33ZTJOFuN1HhBI8lsB5u2pOg9E';
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Приложение запущено и Supabase подключён!')),
      ),
    );
  }
}
