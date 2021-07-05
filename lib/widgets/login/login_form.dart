import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _form = GlobalKey<FormState>();

  String email;
  String password;
  bool isLoading = false;

  void tryLogin(BuildContext context) async {
    bool isValid = _form.currentState.validate();

    if (!isValid) return;
    setState(() {
      isLoading = true;
    });
    _form.currentState.save();
    final result = await Provider.of<Auth>(context).login(email, password);
    if (result != null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
        backgroundColor: Colors.red,
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        child: Form(
          key: _form,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Kullanıcı Adı",
                //   style: TextStyle(fontSize: 30),
                // ),

                Text(
                  "Tekrar Hoşgeldin",
                  style: TextStyle(fontSize: 30),
                ),
                SizedBox(height: 25),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Kullanıcı adınızı girin";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "kullanıcı adı",
                    hintText: "kullanıcı adınızı girin",
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  onSaved: (newValue) {
                    print(newValue);
                    email = newValue.trim();
                  },
                ),
                SizedBox(height: 20),
                // Text(
                //   "Şifre",
                //   style: TextStyle(fontSize: 30),
                // ),
                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Şifrenizi girin";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "şifre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: TextStyle(fontSize: 15),
                    hintText: "şifrenizi girin",
                  ),
                  onFieldSubmitted: (v) {
                    tryLogin(context);
                  },
                  onSaved: (newValue) {
                    password = newValue;
                  },
                ),
                SizedBox(height: 30),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              tryLogin(context);
                            },
                            child: Text("Giriş"),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
