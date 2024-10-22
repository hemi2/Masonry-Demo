import 'dart:math';

import 'package:untitled/model/card_model.dart';

class TGNetService {
    static Future<List<CardModel>> getCardList({required int pageSize}) async {
    final List<CardModel> res = [];
    final ratio = {
      0: '1,1',
      1: '4,3',
      2: '3,4',
      3: '3,5',
    };
    await Future.delayed(const Duration(seconds: 1), () {
      for (int i = 0; i < pageSize; i++) {
        // 随机1-100
        final random = Random().nextInt(5) + 1;
        res.add(CardModel(
            title: '图片比例${ratio[random % 4]}',
            coverPhoto: 'https://picsum.photos/id/$random/200/300',
            coverRatio: ratio[random % 4]));
      }
    });

    return res;
  }
}