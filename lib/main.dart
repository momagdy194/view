import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import './lunchurl.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

String selectedUrl = 'https://sevenplusclinics.com/en';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter WebView',
      home:MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Instance of WebView plugin
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  StreamSubscription<double> _onProgressChanged;

  StreamSubscription<double> _onScrollYChanged;

  StreamSubscription<double> _onScrollXChanged;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
    Future.delayed(Duration(seconds: 0), () {
      Navigator.of(context).pushNamed('/widget');
    });

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: const Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed

    _onProgressChanged = _onScrollYChanged = _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {});
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
//        key: _scaffoldKey,
        bottomNavigationBar: Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(icon: FaIcon(
                  FontAwesomeIcons.whatsapp, color: Colors.green, size: 40,),
                    onPressed: Lunch.lunchwatsApp)
                , IconButton(icon: FaIcon(
                    FontAwesomeIcons.facebook, color: Colors.blueAccent,
                    size: 40), onPressed: Lunch.lunchFaceBook)
                , IconButton(icon: FaIcon(
                    FontAwesomeIcons.instagram, color: Colors.blueGrey,
                    size: 40), onPressed: Lunch.lunchInsta)
              ],),
          ),
        ),
        body: WebviewScaffold(

          url: selectedUrl,
          javascriptChannels: jsChannels,
          mediaPlaybackRequiresUserGesture: false,
          withZoom: true,
          withLocalStorage: true,
          hidden: true,
          initialChild: Container(
            color: Color(0XFFdddddb),
            child: const Center(
              child: Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/initScreen.png')),
            ),
          ),
        ),
      ),
    );
  }
}
