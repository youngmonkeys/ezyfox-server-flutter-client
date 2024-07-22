import 'package:flutter/material.dart';
import 'socket_proxy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String socketState = 'Socket has not connected yet';
  String sslMessage = '';

  Future<void> setup() async {
    SocketProxy socketProxy = SocketProxy.getInstance();
    socketProxy.onDisconnected(() => {
          setState(() {
            socketState = "Disconnected, retry ...";
            sslMessage = "";
          })
        });
    socketProxy.onConnectionFailed(() => {
          setState(() {
            socketState = "Can not connect to server";
            sslMessage = "";
          })
        });
    socketProxy.onGreet((message) => {
          setState(() {
            socketState = message;
          })
        });
    socketProxy.onSecureChat((message) => {
          setState(() {
            sslMessage = message;
          })
        });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    SocketProxy.getInstance().connectToServer("flutter", "123456");
  }

  @override
  Widget build(BuildContext context) {
    setup();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Socket message: ',
            ),
            Text(
              '$socketState',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'SSL message: ',
            ),
            Text(
              '$sslMessage',
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
