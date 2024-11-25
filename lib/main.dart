import 'package:flutter/material.dart';
import 'package:untitled/page/fold_tap_flow/flow_tap_demo.dart';
import 'package:untitled/page/water_fall/my_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _item(pageName: '瀑布流 Demo',page: const MyGridView()),
            _item(pageName: '可折叠流布局 Demo',page: const FlowTapDemo()),
           
          ],
        ),
      ),
    );
  }

  Widget _item({required String pageName,required Widget page}) {
    return OutlinedButton(
      onPressed: () {
         Navigator.push(context,MaterialPageRoute(builder: (context) => page));
      },
      child: Text(pageName, style: const TextStyle(fontSize: 21))
    );
  }
}
