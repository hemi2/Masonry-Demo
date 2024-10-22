import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/card_model.dart';
import 'package:untitled/provider/my_grid_view_provider.dart';

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
  final MyGridViewProvider _provider = MyGridViewProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider(
        create: (context) => _provider,
        child: Consumer<MyGridViewProvider>(
          builder: (context, provider, child) {
            return MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                return _cardItem(provider.list[index]);
              },
            );
          }
        ),
      ),
    );
  }
  Widget _cardItem(CardModel model) {
    final String coverRatio = model.coverRatio ?? '1,1';
    final List<String> ratioParts = coverRatio.split(',');
    // 解析宽高比例，默认为 "1,1"
    final int widthRatio = int.tryParse(ratioParts[0]) ?? 1;
    final int heightRatio = int.tryParse(ratioParts[1]) ?? 1;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: widthRatio / heightRatio,
            child: Image.network(
              model.coverPhoto!,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${model.title}'),
          )
        ],
      )
    );
  }
}
