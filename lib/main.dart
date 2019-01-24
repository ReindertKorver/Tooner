import 'package:flutter/material.dart';
import 'package:toon_app/Tabs/Energy.dart';
import 'package:toon_app/Tabs/Gas.dart';
import 'package:toon_app/Tabs/Temperature.dart';
import 'package:toon_app/WebViewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Color currentColor = Colors.deepOrange;
  Color currentColorAccent = Colors.amberAccent;
  Color colorDisabled = Colors.grey[350];
  bool isDarkMode = true;

  TabController tabController;
  int currentIndex = 0;

  _launchURL() async {
    const url =
        'https://api.toon.eu/authorize?response_type=code&redirect_uri=(redirect_url)&client_id=m8QLpABwUoADA5QddvWgX58IQIgxwgUy&tenant_id=eneco';
    if (await canLaunch(url)) {
      var result = await launch(
        url,
        forceWebView: true,
        forceSafariVC: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      if (mounted) {
        setState(() {
          currentIndex = tabController.index;
        });
      }
      switch (currentIndex) {
        case 0:
          currentColor = Colors.deepOrange[800];
          currentColorAccent = Colors.amberAccent;
          colorDisabled = Colors.white;
          break;
        case 1:
          currentColor = Colors.green[900];
          currentColorAccent = Colors.orange;
          colorDisabled = Colors.white;
          break;
        case 2:
          currentColor = Color(0xFF082c61);
          currentColorAccent = Colors.red;
          colorDisabled = Colors.white;
          break;
      }
      print(tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          color: (isDarkMode) ? Colors.black : currentColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewer(
                                  url:
                                      "https://api.toon.eu/authorize?response_type=code&redirect_uri=localhost&client_id={clientid}&tenant_id=eneco",
                              currentColor: (isDarkMode)?Colors.black:currentColor,
                                )),
                      ).then((result) {
                        if (result != null) {
                          //get the code from the url
                          if (!result.contains('error=true')) {
                            String callBackURL = result;
                            int pFrom =
                                callBackURL.indexOf("?code=") + "?code=".length;
                            int pTo = callBackURL.indexOf("&scope=");
                            String resultCode =
                                callBackURL.substring(pFrom, pTo);

                          } else {
                            //fout bij inloggen
                          }
                        } else {
                          //fout bij het inloggen
                        }
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Tooner",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      (!isDarkMode)
                          ? Icons.invert_colors
                          : Icons.invert_colors_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (isDarkMode) {
                        setState(() {
                          isDarkMode = false;
                        });
                      } else {
                        setState(() {
                          isDarkMode = true;
                        });
                      }
                    },
                  ),
                ]),
              ),
              Container(
                height: 60.0,
                child: TabBar(
                  indicatorColor: currentColorAccent,
                  controller: tabController,
                  tabs: [
                    Tab(
                        icon: Icon(Icons.flash_on,
                            color: (currentIndex == 0)
                                ? currentColorAccent
                                : colorDisabled)),
                    Tab(
                        icon: Image.asset(
                      "assets/gas.png",
                      color: (currentIndex == 1)
                          ? currentColorAccent
                          : colorDisabled,
                      height: 25.0,
                    )),
                    Tab(
                        icon: Image.asset(
                      "assets/temp.png",
                      color: (currentIndex == 2)
                          ? currentColorAccent
                          : colorDisabled,
                      height: 25.0,
                    )),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    Energy(),
                    Gas(),
                    Temperature(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
