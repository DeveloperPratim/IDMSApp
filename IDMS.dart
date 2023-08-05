import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';

class IDM extends StatefulWidget {
  @override
  _IDMState createState() => _IDMState();
}

class _IDMState extends State<IDM> {
  final String url = 'https://idmsystem.buzz/WEB/Home?mobile=true';
  bool isLoading = true;
  WebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IDMSystem'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 112, 174, 250),
                Color.fromARGB(255, 218, 229, 244)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 0.7], // Optional, add color stops for more control
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            debuggingEnabled: true,
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            javascriptChannels: <JavascriptChannel>[
              _getFileSelectedChannel(),
            ].toSet(),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  JavascriptChannel _getFileSelectedChannel() {
    return JavascriptChannel(
      name: 'FileSelectedChannel',
      onMessageReceived: (JavascriptMessage message) {
        // Handle file selected message from WebView
        String fileUrl = message.message;
        // Do whatever you want with the file URL, for example, send it to your server
      },
    );
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String fileUrl = result.files.single.path!;
      if (_webViewController != null) {
        _webViewController!.evaluateJavascript('''
          var fileUrl = '$fileUrl';
          window.FileSelectedChannel.postMessage(fileUrl);
        ''');
      }
    }
  }
}
