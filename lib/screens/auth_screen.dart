import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chat/screens/chats_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  static const route = '/Auth-Screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _username;
  String _password;
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus)
        setState(() {
          _obscurePassword = true;
        });
    });
    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus)
        setState(() {
          _obscureConfirmPassword = true;
        });
    });
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                _isLogin ? 'Login' : 'Sign Up',
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(
                height: 110,
              ),
              _isLogin ? buildLoginForm() : buildSignUpForm()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpForm() {
    return Column(children: [
      Form(
          key: _signUpKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 15,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Username',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2)),
                ),
                onSaved: (value) => _username = value,
                validator: (value) {
                  if (value.length < 4)
                    return 'Must be at least 4 characters long';
                  return null;
                },
              ),
              SizedBox(
                height: 17,
              ),
              TextFormField(
                focusNode: _passwordFocusNode,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2)),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 8),
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: _togglePassword,
                    color: Colors.grey,
                  ),
                ),
                onSaved: (value) => {_password = value},
                validator: (value) {
                  print(value);
                  if (value.length < 8)
                    return 'Must be at least 8 characters long';
                  else if (!value.contains(RegExp(r'[a-z]')) ||
                      !value.contains(RegExp(r'[0-9]')))
                    return 'Must contain at least one number and one letter';
                  return null;
                },
              ),
              SizedBox(
                height: 17,
              ),
              TextFormField(
                focusNode: _confirmPasswordFocusNode,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 8),
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: _toggleConfirmPassword,
                    color: Colors.grey,
                  ),
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2)),
                ),
                validator: (value) {
                  if (value != _password) return 'Does not match the password';
                  return null;
                },
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                color: Theme.of(context).primaryColor,
                onPressed: () => _validateSignUpForm(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: TextStyle(color: Colors.grey),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  _isLogin = true;
                });
              },
              child: Text(
                'Sign in',
                style: TextStyle(color: Colors.blue),
              ))
        ],
      ),
    ]);
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(width: 2)),
                  ),
                  onSaved: (value) => _username = value),
              SizedBox(
                height: 17,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(width: 2)),
                ),
                obscureText: true,
                onSaved: (value) => _password = value,
              ),
              SizedBox(height: 40),
              RaisedButton(
                padding: const EdgeInsets.fromLTRB(60, 20, 60, 20),
                color: Theme.of(context).primaryColor,
                onPressed: _login,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Not a member yet? ',
              style: TextStyle(color: Colors.grey),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    _isLogin = false;
                  });
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ],
    );
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _validateSignUpForm() {
    _signUpKey.currentState.save();
    bool isValid = _signUpKey.currentState.validate();

    if (isValid) {
      createAccount();
    }
  }

  void _login() async {
    _loginFormKey.currentState.save();
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: '$_username@firechat.com', password: _password);
      Navigator.of(context).pushReplacementNamed(ChatsScreen.route, arguments: {'user': credential.user,});
    } catch (err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Username or password incorrect'),
      ));
      print(err);
    }
  }

  void createAccount() async {
    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: '$_username@firechat.com', password: _password);
      await FirebaseFirestore.instance.collection('users').doc(credential.user.uid).set({'username' : _username}); 
      Navigator.of(context).pushReplacementNamed(ChatsScreen.route, arguments: {'user': credential.user,});
    } 
    catch (err) {
      print(err);
      if (err.toString().contains('network-request-failed')) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text(
                      'Please check your internet connection and try again'),
                  actions: [
                    FlatButton(
                        onPressed: Navigator.of(context).pop, child: Text('OK'))
                  ],
                ));
      }

      if (err.toString().contains('email-already-in-use')) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Username already in use')));
      }
      return;
    }
  }
}
