import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/network/client/dio_api_client.dart';
import '../../../common/network/http_options.dart';
import '../../../common/network/network_config.dart';
import '../../../common/network/parser.dart';
import '../../../common/network/request/http_request.dart';

/// A demo page showcasing all request patterns.
final class NetworkDemoPage extends ConsumerWidget {
  const NetworkDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Network Demo'),
        ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DemoSection(
            title: '1. Initialize',
            code: '''
final client = DioApiClient(
  config: NetworkConfig(
    baseUrl: 'https://api.example.com',
  ),
);
''',
          ),
          _DemoSection(
            title: '2. GET request',
            code: '''
final response = await client.request<User>(
  HttpRequest.get('/user/profile'),
  decoder: (json) => Parser.object(json, User.fromJson),
);

print(response.data); // User
''',
          ),
          _DemoSection(
            title: '3. POST with body',
            code: '''
final response = await client.request<LoginResponse>(
  HttpRequest.post(
    '/auth/login',
    body: {'phone': '138xxxx', 'password': '***'},
  ),
  decoder: (json) => Parser.object(json, LoginResponse.fromJson),
);
''',
          ),
          _DemoSection(
            title: '4. GET with query & cancel',
            code: '''
final cancelToken = CancelToken();

final response = await client.request<List<User>>(
  HttpRequest.get(
    '/user/search',
    query: {'keyword': 'alice'},
    cancelToken: cancelToken,
  ),
  decoder: (json) => Parser.list(json, User.fromJson),
);

// later: cancelToken.cancel();
''',
          ),
          _DemoSection(
            title: '5. Upload progress',
            code: '''
final response = await client.request<UploadResult>(
  HttpRequest.post(
    '/file/upload',
    body: formData,
    onSendProgress: (sent, total) {
      print('Upload: \$sent/\$total');
    },
  ),
);
''',
          ),
          _DemoSection(
            title: '6. Paginated list',
            code: '''
// Server returns { "code":0, "data": [...] }
final response = await client.request<List<Post>>(
  HttpRequest.get('/feed/list', query: {'page': '1'}),
  decoder: (json) => Parser.list(json, Post.fromJson),
);

print(response.data?.length ?? 0);
''',
          ),
          _DemoSection(
            title: '7. Decode a primitive',
            code: '''
final response = await client.request<String>(
  HttpRequest.get('/version'),
  decoder: Parser.value,
);
// response.data is String
''',
          ),
        ],
      ),
    );
  }
}

final class _DemoSection extends StatelessWidget {
  const _DemoSection({required this.title, required this.code});
  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

