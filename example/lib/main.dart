import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:io_dldb_sdk/io_dldb_sdk.dart';

import 'package:cron/cron.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await IoDldbSdk.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      await IoDldbSdk.init('1688e135-f5b1-4659-b84a-96ff15c07f57', '{"button" : "t"}');
    } on PlatformException {
      platformVersion = 'Failed to init dldb';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _message = 'Running on: $platformVersion\n';
    });

    var cron = new Cron();
    cron.schedule(new Schedule.parse('*/3 * * * *'), () async {
      print('every three minutes');
      try {
        await IoDldbSdk.heartbeat();
        setState(() {
          _message = 'heartbeat called\n';
        });
      } on PlatformException {
      }
    });
    cron.schedule(new Schedule.parse('15-16 * * * *'), () async {
      print('between every 15 and 16 minutes');
      try {
        await IoDldbSdk.runQueriesIfAny();
        setState(() {
          _message = 'runQueriesIfAny called\n';
        });
      } on PlatformException {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [ 
            Text(_message, textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () async { 
                try {
                  await IoDldbSdk.addEvents('{"button" : "Click Me"}');
                } on PlatformException {
                }
                setState(() {
                  _message = 'button Click Me pressed ! => event logged\n';
                });
              },
              child: const Text('Click Me'),
            ),
            ElevatedButton(
              onPressed: () async { 
                try {
                  await IoDldbSdk.addEvents('{"button" : "Run queries"}');
                  await IoDldbSdk.runQueriesIfAny();
                } on PlatformException {
                }
                setState(() {
                  _message = 'button Run queries pressed ! => event logged\n';
                });
              },
              child: const Text('Run queries'),
            ),
            ElevatedButton(
              onPressed: () async { 
                String? queriesLog;
                try {
                  queriesLog = await IoDldbSdk.queriesLog(10);
                } on PlatformException {
                }
                setState(() {
                  _message = 'Queries Log ! => $queriesLog\n';
                });
              },
              child: const Text('Queries Log'),
            ),
            ElevatedButton(
              onPressed: () async { 
                String? locationsLog;
                try {
                  locationsLog = await IoDldbSdk.locationsLog(3600,10,7);
                } on PlatformException {
                }
                setState(() {
                  _message = 'Locations Log ! => $locationsLog\n';
                });
              },
              child: const Text('Locations Log'),
            )

          ]
        ),
      ),
    );
  }
}
