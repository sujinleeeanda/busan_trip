// lib/screen/heart_list_screen.dart
import 'package:busan_trip/model/heart_list_model.dart';
import 'package:busan_trip/vo/heart_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartListScreen extends StatelessWidget {
  final int userId;

  HeartListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HeartListModel()..setHeartLists(userId),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              )
          ),
          elevation: 0,
          title: Text(
            '마음함',
            style: TextStyle(
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내가 마음에 담은 상품 목록',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey[700], // 회색
                  ),
                ),
                SizedBox(height: 15), // 제목과 카드 사이에 여백 추가
                Expanded(
                  child: Consumer<HeartListModel>(
                    builder: (context, heartListModel, child) {
                      if (heartListModel.heartLists.isNotEmpty) {
                        return ListView.builder(
                          itemCount: heartListModel.heartLists.length,
                          itemBuilder: (context, index) {
                            final item = heartListModel.heartLists[index];
                            return Column(
                              children: [
                                FavoriteCard(
                                  item: item,
                                  heartListModel: heartListModel,
                                  userId: userId, // 추가된 부분
                                ),
                                SizedBox(height: 15),
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('마음에 담은 상품이 없습니다.'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class FavoriteCard extends StatefulWidget {
  final HeartList item;
  final HeartListModel heartListModel;
  final int userId;

  const FavoriteCard({
    super.key,
    required this.item,
    required this.heartListModel,
    required this.userId,
  });

  @override
  _FavoriteCardState createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  Future<void> _initializeFavoriteStatus() async {
    // 서버에서 현재 찜 상태를 가져와야 합니다.
    setState(() {
      _isFavorited = true; // 실제 서버 응답에 따라 이 값을 설정해야 합니다.
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorited) {
      try {
        await widget.heartListModel.deleteHeart(widget.item.i_idx);
        setState(() {
          _isFavorited = false;
        });
      } catch (e) {
        print('Error toggling favorite: $e');
        // 에러 처리: 삭제 실패 시 사용자에게 알림을 추가할 수 있습니다.
      }
    } else {
      try {
        await widget.heartListModel.addHeart(widget.userId, widget.item.i_idx);
        setState(() {
          _isFavorited = true;
        });
      } catch (e) {
        print('Error adding favorite: $e');
        // 에러 처리: 추가 실패 시 사용자에게 알림을 추가할 수 있습니다.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // 여기에 클릭 처리 추가 가능
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.item.i_image,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.i_name,
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                height: 1.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Column(
                              children: [
                                Icon(
                                  _isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  size: 25,
                                  color: _isFavorited
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7),
                      Text(
                        '${widget.item.modified_date} · ${widget.item.i_price}원',
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${widget.item.i_price}원~',
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


