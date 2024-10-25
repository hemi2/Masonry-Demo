import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/card_model.dart';
import 'package:untitled/provider/my_grid_view_provider.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  final MyGridViewProvider _provider = MyGridViewProvider();
  @override
  void initState() {
    super.initState();
    _provider.getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('瀑布流'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => _provider,
        child: Consumer<MyGridViewProvider>(
          builder: (context, provider, child) {
            return MasonryGridView.count(
              padding: const EdgeInsets.all(8),
              crossAxisCount: 8,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              itemCount: provider.list.length,
              itemBuilder: (context, index) {
                return _cardItem(provider.list[index]);
              },
            );
            // return WaterfallFlow.builder(
            //   padding: const EdgeInsets.all(8),
            //   gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 8,
            //     crossAxisSpacing: 0,
            //     mainAxisSpacing: 0,
            //   ),
            //   itemCount: provider.list.length,
            //   itemBuilder: (context, index) {
            //    return _cardItem(provider.list[index]);
            //   }
            // );
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
            child: model.coverPhoto != null ? Image.network(
              model.coverPhoto!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(),
            ): Container()
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