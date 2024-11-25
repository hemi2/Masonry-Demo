import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/page/fold_tap_flow/tag_flow_widget.dart';


class FlowTapDemo extends StatefulWidget {
  const FlowTapDemo({Key? key}) : super(key: key);
  static List<String> data = [
    '测试',
    '隔热膜',
    '🔥',
    '贝多芬',
    '超长超长超长超长超长超长超长超长超长超长超长超长超长超长超长',
    '阿斯顿马丁',
    '持续不断',
    '恶趣味',
    '电饭锅怕热',
    '歌舞厅'
  ];

  @override
  _FlowTapDemoState createState() => _FlowTapDemoState();
}

class _FlowTapDemoState extends State<FlowTapDemo> {
  List<String> list = List.from(FlowTapDemo.data);
  final Random _random = Random.secure();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(title: const Text('可折叠流式布局')),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final randomIndex = _random.nextInt(FlowTapDemo.data.length);
                  final String temp = FlowTapDemo.data[randomIndex];
                  list.add(temp);
                });
              },
              child: const Center(child: Text('添加最后')),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final randomIndex = _random.nextInt(FlowTapDemo.data.length);
                  final String temp = FlowTapDemo.data[randomIndex];
                  list.insert(0, temp);
                });
              },
              child: const Center(child: Text('添加前面')),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (list.isNotEmpty) list.removeAt(list.length - 1);
                });
              },
              child: const Center(child: Text('删除最后')),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (list.isNotEmpty) list.removeAt(0);
                });
              },
              child: const Center(child: Text('删除前面')),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TagFlowWidget(
              items: list,
              foldedRowsNum: 3,
              itemHeight: 30,
              spaceHorizontal: 8,
              spaceVertical: 8,
              itemBgColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              horizontalPadding: 8,
              itemStyle: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 12,
              )),
        ),
        InkWell(
          onTap:()=>setState(() {
             setState(() {});
            list = [];
          }),
          child: Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey,
            child: const Center(
              child: Text('Clear',style: TextStyle(color: Colors.white)),
            ))

        )
      ]),
    );
  }
}
