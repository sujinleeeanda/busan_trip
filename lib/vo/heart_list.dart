// lib/vo/heart_list.dart
class HeartList {
  int wish_idx;
  int u_idx;
  int i_idx;
  String modified_date;
  String created_date;
  String i_name;
  String i_image;
  int i_price;

  HeartList({
    this.wish_idx = 0,
    this.u_idx = 0,
    this.i_idx = 0,
    this.modified_date = '',
    this.created_date = '',
    this.i_name = '',
    this.i_image = '',
    this.i_price = 0
  });

  factory HeartList.fromJson(Map<String, dynamic> json) {
    return HeartList(
        wish_idx: json['wish_idx'],
        u_idx: json['u_idx'],
        i_idx: json['i_idx'],
        modified_date: json['modified_date'],
        created_date: json['created_date'],
        i_name: json['i_name'],
        i_image: json['i_image'],
        i_price: json['i_price']
    );
  }
}
