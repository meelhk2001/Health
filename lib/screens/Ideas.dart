import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import './loading.dart';
import '../models/issue_model.dart';

class Ideas extends StatefulWidget {
  static const routeName = '/ideas';
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {
  var _isInit = true;
  var _isLoading = false;
  String _name;
  var userData;
  int j = 0;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProvider>(context, listen: false).getIssueList();
    Provider.of<UserProvider>(context, listen: false).getData().then((_) {
      Provider.of<UserProvider>(context, listen: false).user.then((value) {
        final userData =
            Provider.of<UserProvider>(context, listen: false).data();
        print(userData.name);
        _name = userData.name;
        // _renergy = userData.renergy;
        // _score = userData.score;
        _isInit = false;
        setState(() {
          _isLoading = false;
        });
      });
    }).catchError((onError) {
      print(' .... ...  ap to galata h yr ');
      setState(() {
        _isLoading = false;
      });
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var issueList = Provider.of<UserProvider>(context).issueList;
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
                child: Container(
                  height: 93,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top),
                          Row(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'Hi  ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                '$_name'.toUpperCase(),
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                'Thanks for taking our services',
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                preferredSize: Size(double.infinity, 80)),
            body: issueList.length < 1
                ? Center(
                    child: Text('Add some issues'),
                  )
                : Container(
                    padding: EdgeInsets.fromLTRB(15, 20, 0, 35),
                    child: ListView.builder(
                        itemCount: issueList.length,
                        itemBuilder: (BuildContext context, int i) =>
                            issueList[i]),
                  ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  j = issueList.length;
                  //for(int i =0; i<issueList.length;i++){print(issueList[i].value);}
                  setState(() {
                    Provider.of<UserProvider>(context, listen: false).issueList.add(IssueModel(j.toString(), 'ram'));
                  });
                  Provider.of<UserProvider>(context, listen: false)
                      .saveIssueList();
                }),
            persistentFooterButtons: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Home'))
            ],
          );
  }
}
