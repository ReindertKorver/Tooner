import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewer extends StatefulWidget {
  WebViewer({@required this.url,@required this.currentColor});

  final String url;
final Color currentColor;
  @override
  _WebViewerState createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  String loaderText = "De inlogpagina wordt opgehaald";
  String currentPageURL;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((currentUrl) {
      print('url changed to ' + currentUrl);
      if (currentUrl != widget.url && !currentUrl.contains('error=true')) {
        setState(() {
          loaderText = "U wordt terug gestuurd naar de app";
          currentPageURL = currentUrl;
        });
        Navigator.pop(context, currentUrl);
      }
    });
  }

  Future<bool> _onWillPop() {
    if (currentPageURL != widget.url) {
      setState(() {
        loaderText = "U wordt terug gestuurd naar de app";
      });
      Navigator.pop(context, currentPageURL);
    } else {
      setState(() {
        loaderText = "U wordt terug gestuurd naar de app";
      });
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => new WebviewScaffold(
              url: widget.url,
              withZoom: false,
              withLocalStorage: true,
              hidden: true,
              appBar: AppBar(
                backgroundColor: widget.currentColor,
                title: Text("Login pagina",style: TextStyle(color: Colors.white),),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _onWillPop();
                  },
                ),
              ),
              initialChild: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFd21242),
                    Color(0xFFe67e22),
                  ]),
                ),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          loaderText,
                          style: TextStyle(color: Colors.white),
                        ),
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ]),
                ),
              ),
            ),
      },
    );
  }
}
