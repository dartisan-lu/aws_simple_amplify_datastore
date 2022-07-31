import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';
import 'models/CounterModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS Amplify Datastore',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'AWS Amplify Datastore'),
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
  final _dataStorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  int _counter = 0;

  @override
  void initState() {
    _initializeApp();
    super.initState();
  }

  Future<void> _initializeApp() async {
    await _configureAmplify();
    var last = await _getLastCounter();
    setState(() {
      _counter = last;
    });
  }

  Future<void> _configureAmplify() async {
    try {

      // add Amplify plugins
      await Amplify.addPlugins([_dataStorePlugin]);

      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);

    } catch (e) {

      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }
  }

  Future<int> _getLastCounter() async {
    final request  = await Amplify.DataStore.query(CounterModel.classType, where: CounterModel.ID.eq('MAIN'));

    if (request.isEmpty) {
      final counter = CounterModel(
        id: 'MAIN',
        counter: 0,
      );
      await Amplify.DataStore.save(counter);
      print('Initialize DB with [0]');
      return 0;
    } else {
      print('Retrieve from DB [${request.first.counter}]');
      return request.first.counter??0;
    }
  }

  Future<void> _incrementCounter() async {
    var next = _counter + 1;
    var newCounter = CounterModel(id: 'MAIN', counter: next);
    print('Store new value [$next]');
    await Amplify.DataStore.save(newCounter);
    setState(() {
      _counter = next;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(context).textTheme.headline4,
            ),
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
