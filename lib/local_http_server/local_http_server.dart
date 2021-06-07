import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LocalHttpServer {
  HttpServer? _server;

  Future<void> start() async {
    if (_server != null) {
      print('Server already started on $uri');
      return;
    }

    await runZoned(() async {
      _server = await HttpServer.bind('localhost', 0);
      print(uri);
      _server!.listen((request) async {
        final path = request.requestedUri.path;
        print(path);

        request.response.headers.contentType = ContentType('application', 'json', charset: 'utf-8');

        const json = {'name': 'こんぶ'};

        request.response.add(utf8.encode(jsonEncode(json)));

        await request.response.close();
      });
    });
  }

  int get port => _server!.port;

  InternetAddress? get address => _server?.address;

  Uri get uri => Uri.http('${address!.host}:$port', '');
}
