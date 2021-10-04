import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName= '/edit-profile';


  @override
  Widget build(BuildContext context) {
    var _isLoading = false;
    final _form = GlobalKey<FormState>();
    var _initValues = {
      'name' : Provider.of<Auth>(context).name,
      'country': Provider.of<Auth>(context).country,
    };

    Future<void> _saveProfile() async {
      _form.currentState.save();
      Provider.of<Auth>(context).updateProfile(_initValues['name'], _initValues['country']);
      Navigator.of(context).pop();

    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit profile'),
        ),
        body: _isLoading ? Center(child: CircularProgressIndicator(),)
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [ TextFormField(
                    initialValue: _initValues['name'],
                    decoration: InputDecoration(labelText: 'Name'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if(value.isEmpty)
                      {
                        return 'Please enter a new name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _initValues['name'] = value;
                    }
                  ),
                  TextFormField(
                    initialValue: _initValues['country'],
                    decoration: InputDecoration(labelText: 'Country'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if(value.isEmpty)
                      {
                        return 'Please enter a new country';
                      }
                      return null;
                    },
                    onSaved: (value) {
                     _initValues['country'] = value;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 120,
                        height: 135,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.grey
                            )
                        ),
                        child: Image.asset('images/nophoto.jpg', fit: BoxFit.cover,)
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Updating image is not available at this moment'),
                          textInputAction: TextInputAction.done,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: _saveProfile,
            child: Text(
              'Update profile',
              style: TextStyle(fontSize: 18,),
            ),
            color: Colors.cyan,
          )
        ],
      ),
    )
    );
  }
}
