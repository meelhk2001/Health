import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/issue_model.dart';

class UserProvider with ChangeNotifier {
  String authToken;
  String userId;

  List<IssueModel> issueList = [];
  UserProvider(this.authToken, this.userId, this.issueList);
  //final mappedData = {"${issueList[0].id}" : "${issueList[0].value}"};
  Future<void> saveIssueList() async {
    final prefr = await SharedPreferences.getInstance();
    final mappedData = {"${issueList[0].id}": "${issueList[0].value}"};
    //print(issueList.length.toString());
    for (int i = 0; i < issueList.length; i++) {
      if (i != -1) {
        print(i.toString() + ' ${issueList[i].value}  to print huaa.....');
        mappedData["${issueList[i].id}"] = "${issueList[i].value}";
        print(mappedData["${issueList[i].id}"]);
      }
    }
    var userData = json.encode(mappedData);
    if(prefr.containsKey('issueList')){prefr.clear();}
    prefr.setString('issueList', userData);
    notifyListeners();
  }

  Future<void> getIssueList() async {
    final prefr = await SharedPreferences.getInstance();
    if (!prefr.containsKey('issueList')) {
      return;
    }
    final extractedData =
        jsonDecode(prefr.getString('issueList')) as Map<String, dynamic>;
        issueList.removeRange(0, issueList.length);
    extractedData.forEach((key, value) {
      
      issueList.add(IssueModel(key, value));
    });
    notifyListeners();
  }

  var userData = User();
  double _renergy;
  double _score;

  void deleteIssue(String id) {
    issueList.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> saveForm(String name, int age, String sex, double weight,
      int height, int lifestyle) async {
    _renergy = ((weight / 5) + (height / 4)) * lifestyle;
    _score = (weight + height + age) * lifestyle;

    var url =
        'https://health-meelhk.firebaseio.com/healthData/$userId/${userData.id}.json?auth=$authToken';
    if (userData.id == null) {
      url =
          'https://health-meelhk.firebaseio.com/healthData/$userId.json?auth=$authToken';
      try {
        final response = await http.post(url,
            body: json.encode({
              'name': '$name',
              'age': '$age',
              'sex': '$sex',
              'weight': '$weight',
              'height': '$height',
              'lifestyle': '$lifestyle',
              'renergy': '$_renergy',
              'score': '$_score',
            }));
        userData = User(
          id: jsonDecode(response.body)['name'],
          name: name,
          age: age,
          sex: sex,
          weight: weight,
          height: height,
          lifestyle: lifestyle,
          renergy: _renergy,
          score: _score,
        );
      } catch (e) {
        print(e.toString());
      }

      notifyListeners();
    } else {
      try {
        final response = await http.put(url,
            body: json.encode({
              'name': '$name',
              'age': '$age',
              'sex': '$sex',
              'weight': '$weight',
              'height': '$height',
              'lifestyle': '$lifestyle',
              'renergy': '$_renergy',
              'score': '$_score',
            }));
        userData = User(
          id: jsonDecode(response.body)['name'],
          name: name,
          age: age,
          sex: sex,
          weight: weight,
          height: height,
          lifestyle: lifestyle,
          renergy: _renergy,
          score: _score,
        );
      } catch (e) {
        print(e.toString());
      }

      notifyListeners();
    }
  }

  Future<void> getData() async {
    final url =
        'https://health-meelhk.firebaseio.com/healthData/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      extractedData.forEach((id, data) {
        userData = User(
          id: id,
          name: data['name'],
          age: int.parse(data['age']),
          sex: data['sex'],
          weight: double.parse(data['weight']),
          height: int.parse(data['height']),
          lifestyle: int.parse(data['lifestyle']),
          renergy: double.parse(data['renergy']),
          score: double.parse(data['score']),
        );
        notifyListeners();
        //print(userData.name.toString());
      });
    } catch (error) {
      throw error;
    }
  }

  User data() {
    return userData;
  }

  Future<void> get user async {
    await getData();
    data();
  }
}
