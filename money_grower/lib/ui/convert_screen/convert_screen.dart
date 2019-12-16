import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/ui/custom_control/category_page.dart';
import 'package:money_grower/ui/custom_control/faded_transition.dart';

class ConvertScreen extends StatefulWidget {
  @override
  State<ConvertScreen> createState() => ConvertScreenState();
}

class ConvertScreenState extends State<ConvertScreen> {
  bool _saving = false;
  final categoryList = [
    'AED (UAE Dirham)',
    'ARS (Argentine Peso)',
    'AUD (Australian Dollar)',
    'BGN (Bulgarian Lev)',
    'BRL (Brazilian Real)',
    'BSD (Bahamian Dollar)',
    'CAD (Canadian Dollar)',
    'CHF (Swiss Franc)',
    'CLP (Chilean Peso)',
    'CNY (Chinese Renminbi)',
    'COP (Colombian Peso)',
    'CZK (Czech Koruna)',
    'DKK (Danish Krone)',
    'DOP (Dominican Peso)',
    'EGP (Egyptian Pound)',
    'EUR (Euro)',
    'FJD (Fiji Dollar)',
    'GBP (Pound Sterling)',
    'GTQ (Guatemalan Quetzal)',
    'HKD (Hong Kong Dollar)',
    'HRK (Croatian Kuna)',
    'HUF (Hungarian Forint)',
    'IDR (Indonesian Rupiah)',
    'ILS (Israeli Shekel)',
    'INR (Indian Rupee)',
    'ISK (Icelandic Krona)',
    'JPY (Japanese Yen)',
    'KRW (South Korean Won)',
    'KZT (Kazakhstani Tenge)',
    'MXN (Mexican Peso)',
    'MYR (Malaysian Ringgit)',
    'NOK (Norwegian Krone)',
    'NZD (New Zealand Dollar)',
    'PAB (Panamanian Balboa)',
    'PEN (Peruvian Nuevo Sol)',
    'PHP (Philippine Peso)',
    'PKR (Pakistani Rupee)',
    'PLN (Polish Zloty)',
    'PYG (Paraguayan Guarani)',
    'RON (Romanian Leu)',
    'RUB (Russian Ruble)',
    'SAR (Saudi Riyal)',
    'SEK (Swedish Krona)',
    'SGD (Singapore Dollar)',
    'THB (Thai Baht)',
    'TRY (Turkish Lira)',
    'TWD (New Taiwan Dollar)',
    'UAH (Ukrainian Hryvnia)',
    'USD (US Dollar)',
    'UYU (Uruguayan Peso)',
    'VND (Vietnamese Dong)',
    'ZAR (South African Rand)'
  ];

  final srcTextController = TextEditingController();
  final desTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final resultTextController = TextEditingController();

  var srcText = "VND";
  var desText = "USD";
  var priceHintText = "Số tiền (VND)";
  var resultHintText = "Kết quả (USD)";

  // ignore: missing_return
  Function setSrcName(String name) {
    final unit = name.substring(0, 3);
    setState(() {
      srcText = unit;
      priceHintText = "Số tiền (" + unit + ")";
      srcTextController.text = srcText;
      resultTextController.text = "";
    });
  }

  // ignore: missing_return
  Function setDesName(String name) {
    final unit = name.substring(0, 3);
    setState(() {
      desText = unit;
      resultHintText = "Kết quả (" + unit + ")";
      desTextController.text = desText;
      resultTextController.text = "";
    });
  }

  Future convert(String srcCurrency, String desCurrency) async {
    final price = priceTextController.text.split(',').join();
    if (price.isEmpty) return;
    setState(() => _saving = true);
    String uri = "https://api.exchangerate-api.com/v4/latest/$srcCurrency";
    final response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    final responseBody = json.decode(response.body);
    final result = (double.parse(price) * (responseBody["rates"][desCurrency]));
    resultTextController.text = FormatHelper().formatMoney(result);
    setState(() => _saving = false);
  }

  void setPrice(String price) {
    final parseText = price.split(',').join('');
    final formattedText = FormatHelper().formatMoney(int.parse(parseText));
    priceTextController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    resultTextController.text = "";
  }

  @override
  void initState() {
    super.initState();
    srcTextController.text = srcText;
    desTextController.text = desText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Đổi tỉ giá")),
        body: ModalProgressHUD(
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Spacer(),
                        Container(
                            width: 100,
                            child: TextField(
                                controller: srcTextController,
                                decoration: InputDecoration(
                                  labelText: 'Nguồn',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 30, 20, 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                style: TextStyle(fontSize: 20),
                                readOnly: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: CategoryPage("Chọn mã tiền tệ",
                                              categoryList, setSrcName)));
                                })),
                        Spacer(),
                        FlatButton(
                          color: Colors.green,
                          shape: CircleBorder(),
                          onPressed: () {
                            // swap currency unit
                            final tempUnit = srcTextController.text;
                            setSrcName(desTextController.text);
                            setDesName(tempUnit);
                          },
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                        Spacer(),
                        Container(
                            width: 100,
                            child: TextField(
                                controller: desTextController,
                                decoration: InputDecoration(
                                  labelText: 'Đích',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 30, 20, 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                style: TextStyle(fontSize: 20),
                                readOnly: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      FadeRoute(
                                          page: CategoryPage("Chọn mã tiền tệ",
                                              categoryList, setDesName)));
                                })),
                        Spacer(),
                      ]),
                      SizedBox(height: 30),
                      TextField(
                        controller: priceTextController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        onChanged: (text) => setPrice(text),
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          labelText: priceHintText,
                          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        readOnly: true,
                        style: TextStyle(fontSize: 24),
                        controller: resultTextController,
                        decoration: InputDecoration(
                          labelText: resultHintText,
                          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            padding: EdgeInsets.all(15),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () async {
                              final srcCurrency = srcText;
                              final desCurrency = desText;
                              await convert(srcCurrency, desCurrency);
                            },
                            child: Text("Đổi tỉ giá",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          )),
                    ]))),
            inAsyncCall: _saving));
  }
}
