import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  bool _loading = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      });
    }
  }

  Future<void> _sendMagicLink() async {
    setState(() {
      _loading = true;
      _status = null;
    });
    try {
      await Supabase.instance.client.auth
          .signInWithOtp(email: _emailController.text.trim());
      setState(() {
        _status = 'Письмо отправлено';
      });
    } catch (e) {
      setState(() {
        _status = 'Ошибка: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _openTelegram() async {
    const token = 'some_token';
    final url = Uri.parse('https://t.me/your_bot?start=$token');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    handleTelegramCallback(token);
  }

  void handleTelegramCallback(String token) {
    // TODO: связать с Supabase
    // ignore: avoid_print
    print('Token received: $token');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Авторизация'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Войти по Email'),
              Tab(text: 'Войти через Telegram'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmailTab(),
            _buildTelegramTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _sendMagicLink,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text('Отправить Magic Link'),
          ),
          if (_status != null) ...[
            const SizedBox(height: 16),
            Text(_status!),
          ],
        ],
      ),
    );
  }

  Widget _buildTelegramTab() {
    return Center(
      child: ElevatedButton(
        onPressed: _openTelegram,
        child: const Text('Открыть Telegram'),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Главная')),
      body: const Center(child: Text('Вы вошли!')),
    );
  }
}
