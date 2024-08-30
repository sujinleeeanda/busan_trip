import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart' as bp;
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:busan_trip/screen/item_detail_screen2.dart';
import 'package:busan_trip/vo/item.dart';
import 'package:busan_trip/vo/option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'item_detail_screen.dart';

class PayScreen extends StatefulWidget {

  final Item item;
  final String selectedDate;
  final List<Map<String, dynamic>> selectedOptions;

  const PayScreen({
    Key? key,
    required this.item,
    required this.selectedDate,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  // 예시 애플리케이션 ID를 설정하세요.
  final String webApplicationId = '5b8f6a4d396fa665fdc2b5e7';
  final String androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  final String iosApplicationId = '5b8f6a4d396fa665fdc2b5e9';

  // 총 결제 금액을 계산하는 메서드
  double get totalAmount {
    return widget.selectedOptions.fold(
      0.0,
          (sum, option) => sum + (option['op_price'] * option['quantity']),
    );
  }

  void bootpayTest(BuildContext context) {
    Payload payload = getPayload();
    if (kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context);
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Payload getPayload() {
    Payload payload = Payload();
    bp.Item item = bp.Item();
    item.name = widget.item.i_name;
    item.qty = 1;
    item.id = "ITEM_CODE_${widget.item.i_idx}";
    item.price = totalAmount;

    payload.webApplicationId = webApplicationId;
    payload.androidApplicationId = androidApplicationId;
    payload.iosApplicationId = iosApplicationId;

    payload.pg = '나이스페이';
    payload.orderName = widget.item.i_name;
    payload.price = totalAmount;
    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();

    payload.metadata = {
      "callbackParam1": "value12",
      "callbackParam2": "value34",
      "callbackParam3": "value56",
      "callbackParam4": "value78",
    };
    payload.items = [item];

    User user = User();
    user.username = _nameController.text;
    user.email = _emailController.text;
    // user.area = "서울";
    user.phone = _phoneController.text;
    // user.addr = '서울시 동작구 상도로 222';

    Extra extra = Extra();
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';

    payload.user = user;
    payload.extra = extra;
    return payload;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isNameEntered = false;
  bool _isEmailEntered = false;
  bool _isPhoneEntered = false;
  bool _isBirthdayEntered = false;
  bool _isAgreeToCollect = false;
  bool _isAgreeToProvide = false;

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();

  bool _isAllFieldsEntered() {
    return _isNameEntered &&
        _isEmailEntered &&
        _isPhoneEntered &&
        _isBirthdayEntered &&
        _isAgreeToCollect &&
        _isAgreeToProvide;
  }

  void _onFieldChanged() {
    setState(() {
      _isNameEntered = _nameController.text.isNotEmpty;
      _isEmailEntered = _emailController.text.isNotEmpty;
      _isPhoneEntered = _phoneController.text.isNotEmpty;
    });
  }
  void _formatPhoneNumber() {
    String text = _phoneController.text;
    String formattedText = _formatPhoneNumberString(text);

    if (_phoneController.text != formattedText) {
      _phoneController.value = _phoneController.value.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
        composing: TextRange.empty,
      );
    }
  }

  String _formatPhoneNumberString(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-numeric characters

    if (phoneNumber.length >= 11) {
      phoneNumber = phoneNumber.substring(0, 11); // Limit to 11 digits
    }

    if (phoneNumber.length >= 8) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
    } else if (phoneNumber.length >= 4) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3)}';
    } else {
      return phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '결제',
          style: TextStyle(
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w500,
              fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: FavoriteCard(item: widget.item, selectedDate: widget.selectedDate),
                ),
                SizedBox(height: 15),
                Divider(color: Colors.grey[200], thickness: 7.0,),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      ItemDetail(selectedOptions: widget.selectedOptions),
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 상품 금액',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            '${NumberFormat("#,###").format(totalAmount)}원',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: Colors.grey[200], thickness: 7.0,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '예약자',
                      style: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300], thickness: 1.0,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '이름',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildCustomTextField(
                              '', _nameController, _isNameEntered),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '이메일',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildCustomTextField(
                              '', _emailController, _isEmailEntered),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '생년월일',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          BirthdayText(false),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '전화번호',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                height: 1.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildCustomPhoneField(
                              '', _phoneController, _isPhoneEntered),
                        ],
                      )
                  ),
                ),
                Divider(color: Colors.grey[200], thickness: 7.0,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '결제 정보',
                      style: TextStyle(
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Divider(color: Colors.grey[300], thickness: 1.0,),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '주문 금액',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            '${NumberFormat("#,###").format(totalAmount)}원',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '총 결제 금액',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${NumberFormat("#,###").format(totalAmount)}원',
                            style: TextStyle(
                              fontFamily: 'NotoSansKR',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: Colors.grey[200], thickness: 7.0,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isAgreeToCollect,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isAgreeToCollect = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  '개인정보 수집 및 이용 동의(필수)',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isAgreeToProvide,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isAgreeToProvide = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  '개인정보 제공 동의(필수)',
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                  child: Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '예약 취소 규정',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              '- 유효기간 내 취소 시 미사용 티켓 100% 환불가능',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '- 사용한 티켓 환불 불가',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '- 부분 환불 불가',
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _isAllFieldsEntered() ? () => bootpayTest(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAllFieldsEntered() ? Color(0xff0e4194) : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  '결제하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(bool isEntered) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      labelStyle: TextStyle(color: isEntered ? Colors.green : Colors.grey),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      suffixIcon: isEntered ? Icon(Icons.check_circle, color: Colors.green, size: 24,) : null,
    );
  }

  Widget BirthdayText(bool isEntered) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _selectDate();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: AbsorbPointer(  // TextField 비활성화
              child: TextField(
                controller: _birthdayController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),  // 텍스트와 입력란의 간격 조정
                  border: InputBorder.none,  // 기본 border 제거
                  focusedBorder: OutlineInputBorder (
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),  // 포커스 시 border 제거
                  enabledBorder: OutlineInputBorder (
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),  // 활성화 시 border 제거
                  suffixIcon: _isBirthdayEntered
                      ? Icon(Icons.check_circle, color: Colors.green, size: 24,)
                      : null,
                ),
                style: TextStyle(fontSize: 16, color: _isBirthdayEntered ? Colors.black : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    CupertinoButton(
                      child: Text('완료'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _birthdayController.text = convertDateTimeDisplay(pickedDate);
        _isBirthdayEntered = true;
      });
    }
  }

  String convertDateTimeDisplay(DateTime date) {
    final DateFormat serverFormatter = DateFormat('yyyy-MM-dd');
    return serverFormatter.format(date);
  }

  Widget _buildCustomTextField(String labelText, TextEditingController controller, bool isEntered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: (text) {
            _onFieldChanged();
          },
          decoration: _buildInputDecoration(isEntered).copyWith(labelText: labelText),
          cursorColor: Color(0xff0e4194),
        ),
      ],
    );
  }

  Widget _buildCustomPhoneField(String labelText, TextEditingController controller, bool isEntered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: (text) {
            _formatPhoneNumber();
            _onFieldChanged();
          },
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration(isEntered).copyWith(labelText: labelText),
          cursorColor: Color(0xff0e4194),
        ),
      ],
    );
  }
}

class FavoriteCard extends StatelessWidget {

  final Item item;
  final String selectedDate;

  const FavoriteCard({Key? key, required this.item, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final String imageUrl = item.i_image;
    final String itemName = item.i_name;

    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              itemName,
                              style: TextStyle(
                                fontFamily: 'NotoSansKR',
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                height: 1.0,
                              ), overflow: TextOverflow.ellipsis
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '사용일자',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
                Text(
                  selectedDate,
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                    height: 1.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemDetail extends StatelessWidget {
  final List<Map<String, dynamic>> selectedOptions;

  const ItemDetail({Key? key, required this.selectedOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...selectedOptions.map((option) => Container(
            color: Colors.grey[100],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Row(
                children: [
                  Text(
                    '${option['op_name']} ',
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'X ${option['quantity']}',
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${NumberFormat("#,###").format(option['op_price'] * option['quantity'])}원',
                    style: TextStyle(
                      fontFamily: 'NotoSansKR',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}