import 'package:flutter/cupertino.dart';
import 'package:untitled/model/card_model.dart';
import 'package:untitled/service/net_service.dart';


class MyGridViewProvider extends ChangeNotifier {
  List<CardModel> list = [];

  Future<void> getData() async {
    list = await TGNetService.getCardList(pageSize: 300);
    notifyListeners();
  }
}