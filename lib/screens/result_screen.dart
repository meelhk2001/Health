import 'package:flutter/material.dart';
import 'package:health/models/user.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'Ideas.dart';
import 'loading.dart';

class ResultPage extends StatefulWidget {
  static const routeName = '/result_page';

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  var _isInit = true;
  String _name;
  double _renergy;
  double _score;

  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProvider>(context, listen: false).getData().then((_) {
      Provider.of<UserProvider>(context, listen: false).user.then((value) {
        final userData =
            Provider.of<UserProvider>(context, listen: false).data();
        print(userData.name);
        _name = userData.name;
        _renergy = userData.renergy;
        _score = userData.score;
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
   // var name = ModalRoute.of(context).settings.arguments;
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
            //appBar: AppBar(title:Text('Hi ${userData.name}')),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    80,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Stack(alignment: Alignment.center, children: [
                        Opacity(
                          opacity: 0.67,
                          child: Image(
                            image: AssetImage('assets/images/result.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              'Your Score is ${_score.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Your Renergy is ${_renergy.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Click send to send data on E-Mail'),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text('Send'),
                      color: Colors.red,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Ideas.routeName);
                },
                child: Icon(Icons.arrow_forward)),
          );
  }
}
