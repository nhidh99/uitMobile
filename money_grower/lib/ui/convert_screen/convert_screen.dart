import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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

  Function setName() {}

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
                                          page: CategoryPage(
                                              categoryList, setName)));
                                })),
                        Spacer(),
                        FlatButton(
                          color: Colors.green,
                          shape: CircleBorder(),
                          onPressed: () => {},
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                        Spacer(),
                        Container(
                            width: 100,
                            child: TextField(
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
                                          page: CategoryPage(
                                              categoryList, setName)));
                                })),
                        Spacer(),
                      ]),
                      SizedBox(height: 30),
                      TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        //onChanged: (text) => setPrice(text),
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          labelText: 'Số tiền',
                          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 30),
                      TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        //onChanged: (text) => setPrice(text),
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          labelText: 'Giá đổi',
                          contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ]))),
            inAsyncCall: _saving));
  }
}
