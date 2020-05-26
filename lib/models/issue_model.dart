import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
class IssueModel extends StatefulWidget {
  String id;
  String value;

  IssueModel(this.id,this.value);

  @override
  _IssueModelState createState() => _IssueModelState();
}

class _IssueModelState extends State<IssueModel> {
  

  @override
  Widget build(BuildContext context) {
    
    return Container(
      key: ObjectKey(widget.id),
      child: Row(
                      //key: ObjectKey(i),
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            
                            hint: Text('   ${widget.id} Choose your Issue'),

                            items: <String>[
                              'ram',
                              'shyam',
                              'ghanshyam',
                              'radheshyam'
                            ]
                                .map<DropdownMenuItem<String>>((e) =>
                                    DropdownMenuItem<String>(
                                        child: Text(e), value: e))
                                .toList(),

                            onChanged: (String val) {
                              setState(() {
                                widget.value = val;
                              });
                              setState(() {

                              });
                            },
                             value: widget.value,
                          ),
                        ),
                        IconButton(
                          //key: ObjectKey(i),
                            icon: Icon(Icons.delete_forever),
                            onPressed: () {
                              print(widget.id);
                               Provider.of<UserProvider>(context, listen: false).deleteIssue(widget.id);
                            })
                      ],
                    ),
      
    );
  }
}