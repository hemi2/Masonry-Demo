class CardModel {
  String? coverRatio;
  String? coverPhoto;
  String? title;

  CardModel({
    this.coverRatio,
    this.coverPhoto,
    this.title,
  });
  CardModel.fromJson(Map<String, dynamic> json) {
    coverRatio = json['coverRatio']?.toString();
    coverPhoto = json['coverPhoto']?.toString();
    title = json['title']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['coverRatio'] = coverRatio;
    data['coverPhoto'] = coverPhoto;
    data['title'] = title;
    return data;
  }
}