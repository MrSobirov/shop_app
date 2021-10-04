import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _userMail;
  String _name;
  String _country;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }
    return null;
  }

  String get userId{
    if(_userId != null)
      {
        return _userId;
      }
    return null;
  }

  String get userMail{
    if(_userMail != null)
    {
      return _userMail;
    }
    return null;
  }

  String get name{
    if(_name != null)
    {
      return _name;
    }
    return null;
  }

  String get country{
    if(_country != null)
    {
      return _country;
    }
    return null;
  }

  Future<void> _authentication (
      String eMail, String passWord, String urlSegment, String name, String country) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCn4uL6JA6cESnwb7I5wpYH-3db1nlTM9Y';
    try {
      final response = await http.post(url, body: json.encode({
            'email': eMail,
            'password': passWord,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
      _userMail = eMail;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      if(urlSegment == 'signUp'){
        final Userurl = 'https://shopapp-50487-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
        await http.post(Userurl, body: json.encode({
          'name': name,
          'country': country,
        }));
        _name = name;
        _country = country;
      }
      else {
        final Userurl = 'https://shopapp-50487-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
        final response = await http.get(Userurl);
        final UserDataFire = json.decode(response.body) as Map<String, dynamic>;
        UserDataFire.forEach((key, value) {
          _name = value['name'];
          _country = value['country'];
        });
      }
      _autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'userMail': _userMail,
        'name': _name,
        'country': _country,
      });
      prefs.setString('userData', userData);
    } catch(error) {
      throw error;
    }
    }

  Future<void> updateProfile(String new_name, String new_country)  async {
    final userurl = 'https://shopapp-50487-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    await http.patch(userurl, body: json.encode({
      'name': new_name,
      'country': new_country,
      }));
    _name = new_name;
    _country = new_country;
    notifyListeners();
  }

    Future<void> signup(String eMail, String passWord, String name, String country) async {
      return _authentication(eMail, passWord, 'signUp', name, country);
    }

    Future<void> login(String eMail, String passWord) async {
      return _authentication(eMail, passWord, 'signInWithPassword', '', '');
    }

    Future<void> tryAutoLogIn() async{
      final prefs = await SharedPreferences.getInstance();
      if(!prefs.containsKey('userData'))
        {
          return false;
        }
      final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      if(expiryDate.isBefore(DateTime.now()))
        {
          return false;
        }
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _userMail = extractedUserData['userMail'];
      _name = extractedUserData['name'];
      _country = extractedUserData['country'];
      _expiryDate = expiryDate;
      notifyListeners();
      _autologout();
      return true;
    }

    Future<void> logout() async{
      _token = null;
      _userId = null;
      _expiryDate = null;
      if(_authTimer != null){
        _authTimer.cancel();
        _authTimer = null;
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      //prefs.remove('userData');
      prefs.clear();
    }

    void _autologout() {
      if(_authTimer != null){
        _authTimer.cancel();
      }
      final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
      print(_expiryDate);
      print(timeToExpiry);
    }

  }



