import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'result_screen.dart';
import '../providers/auth.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _form = GlobalKey<FormState>();
  var unsavedUserData = User();
  final _focusAge = FocusNode();
  final _focussex = FocusNode();
  final _focusweight = FocusNode();
  final _focusheight = FocusNode();
  final _focuslifestyle = FocusNode();
  int _lifestyle;
  String _name;
  int _age;
  double _weight;
  int _height;
  String _sex = 'male';
  String _lifestyleSrting = 'Sleepy';
  var isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    Provider.of<UserProvider>(context, listen: false).getData().then((_) {
      
      Provider.of<UserProvider>(context, listen: false).user.then((value) {
        final userData =
            Provider.of<UserProvider>(context, listen: false).data();
        print('...............................hi');
        print(userData.name);
        setState(() {
          _name = userData.name;
          _sex = userData.sex;
          _age = userData.age;
          _height = userData.height;
          _lifestyle = userData.lifestyle;
          _weight = userData.weight;
        });
        isInit = false;
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
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusAge.dispose();
    _focussex.dispose();
    _focusweight.dispose();
    _focusheight.dispose();
    _focuslifestyle.dispose();
    super.dispose();
  }

  void _saveForm() {
    var valid = _form.currentState.validate();
    if (!valid) {
      return;
    }
    _form.currentState.save();
    Provider.of<UserProvider>(context, listen: false)
        .saveForm(_name, _age, _sex, _weight, _height, _lifestyle);
    Navigator.of(context).pushNamed(ResultPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Update your form'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new), onPressed: () {
            Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushNamed('/');
          })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      key: _form,
                      child: Container(
                        // decoration: BoxDecoration(border: ),
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                                initialValue: _name,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: 'your name',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Enter your name';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_focusAge);
                                },
                                onSaved: (val) {
                                  _name = val;
                                }),
                            TextFormField(
                                initialValue:
                                    _age == null ? null : _age.toString(),
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'age',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return 'Enter your age';
                                  }
                                  return null;
                                },
                                focusNode: _focusAge,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_focussex);
                                },
                                onSaved: (val) {
                                  _age = int.parse(val);
                                }),
                            DropdownButtonFormField<String>(
                              value: _sex,
                              isExpanded: true,
                              validator: (val) {
                                if (val == null) {
                                  return 'choose your sex';
                                }
                                return null;
                              },
                              hint: Text('choose your sex'),
                              focusNode: _focussex,
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('male'),
                                  value: 'male',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('female'),
                                  value: 'female',
                                )
                              ],
                              onChanged: (String val) {
                                setState(() {
                                  _sex = val;
                                });
                                // setState(() {

                                // });
                                FocusScope.of(context)
                                    .requestFocus(_focusweight);
                              },
                              // value: _sex,
                            ),
                            TextFormField(
                              initialValue:
                                  _weight == null ? null : _weight.toString(),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(suffix: Text('kg')),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Enter your weight';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _focusweight,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_focusheight);
                              },
                              onSaved: (val) {
                                _weight = double.parse(val);
                              },
                            ),
                            // SizedBox(height:20),
                            TextFormField(
                              initialValue:
                                  _height == null ? null : _height.toString(),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(suffix: Text('cm')),
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Enter your height';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _focusheight,
                              onSaved: (val) {
                                _height = int.parse(val);
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_focuslifestyle);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            DropdownButtonFormField(
                              isExpanded: true,
                              value: _lifestyle,
                              validator: (val) {
                                if (val == null) {
                                  return 'choose your lifestyle';
                                }
                                return null;
                              },
                              hint: Text('Choose your lifestyle'),
                              items: [
                                DropdownMenuItem<int>(
                                  child: Text('Sleepy'),
                                  value: 1,
                                ),
                                DropdownMenuItem<int>(
                                  child: Text('Regular'),
                                  value: 2,
                                ),
                                DropdownMenuItem<int>(
                                  child: Text('Active'),
                                  value: 3,
                                ),
                                DropdownMenuItem<int>(
                                  child: Text('Highly  active'),
                                  value: 4,
                                ),
                              ],
                              focusNode: _focuslifestyle,
                              onChanged: (val) {
                                setState(() {
                                  _lifestyle = val as int;
                                });
                                // print(_lifestyle.toString());
                                FocusScope.of(context)
                                    .requestFocus(_focuslifestyle);
                              },
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      ))),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveForm,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
