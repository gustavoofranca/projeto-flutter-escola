import 'package:flutter/material.dart';
import 'package:prime_edu/services/api_service.dart';
import 'package:prime_edu/components/atoms/custom_button.dart';
import 'package:prime_edu/components/atoms/custom_text_field.dart';
import 'package:prime_edu/components/atoms/custom_typography.dart';
import 'books_api_test.dart';

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  final _searchController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _testApiCall() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final users = await ApiService.getUsers();
      final posts = await ApiService.getPosts();
      final comments = await ApiService.getPostComments(1);

      setState(() {
        _result =
            'API Test Results:\n'
            'Users: ${users.length}\n'
            'Posts: ${posts.length}\n'
            'Comments for post 1: ${comments.length}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo'),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTypography.h4(
              text: 'API Demo Tests',
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            CustomButton(
              text: 'Test JSONPlaceholder API',
              onPressed: _isLoading ? null : _testApiCall,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 24),

            CustomTextField(
              controller: _searchController,
              label: 'Search Books',
              hint: 'Enter search term',
              prefixIcon: Icons.search,
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: 'Test Google Books API',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BooksApiTestScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _result,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
