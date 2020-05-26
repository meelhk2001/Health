import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> sendPasswordResetEmail(String email) async{
    final resetUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDMAKAcWDOZwDcBXtte1SIc1OMQ_nI2TyQ';
    try{
      await http.post(resetUrl,
          body: json.encode({
            'email': email,
            'requestType': "PASSWORD_RESET",
          }));
    }
    catch(error){
      print(email);
      throw error;
    }
  }

  Future<void> verifyPassword(String oobCode) async{
    final verifyUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=AIzaSyDMAKAcWDOZwDcBXtte1SIc1OMQ_nI2TyQ';
    try{
      await http.post(verifyUrl,
          body: json.encode({
            'oobCode': oobCode,
          }));
    }
    catch(error){
      print(oobCode);
      throw error;
    }
  }
  Future<void> cnfResetPassword(String oobCode, String newPassword) async{
    final cnfResetUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=AIzaSyDMAKAcWDOZwDcBXtte1SIc1OMQ_nI2TyQ';
    try{
      await http.post(cnfResetUrl,
          body: json.encode({
            'oobCode': oobCode,
            'newPassword':newPassword
          }));
    }
    catch(error){
      print(oobCode);
      throw error;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDMAKAcWDOZwDcBXtte1SIc1OMQ_nI2TyQ';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = jsonDecode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autologout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
        'userId': _userId
      });
      pref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        jsonDecode(pref.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    _userId = extractedUserData['userId'];
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    //pref.remove('userData');
    pref.clear();
  }

  void autologout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final _remainingTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _remainingTime), logout);
  }
}
