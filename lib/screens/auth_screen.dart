import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  @override
  void initState() {
    _passwordFocusNode.addListener(() {
        if(!_passwordFocusNode.hasFocus) 
          setState(() {
            _obscurePassword = true;
          });
    });
    _confirmPasswordFocusNode.addListener(() {
      if(!_confirmPasswordFocusNode.hasFocus) 
       setState(() {
         _obscureConfirmPassword = true;
       });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Column(
                
                
                children: [
                  SizedBox(height: 60,),
                   Text(
                     
                     _isLogin ? 'Login' : 'Sign Up',
                     
                     style: Theme.of(context).textTheme.headline2,
                     ),
                     SizedBox(height: 110,),
                     _isLogin ? buildLoginForm() : buildSignUpForm()



                   
                   

                ],
              ),
            ),
      ),
        
      
    );
  }

  Widget buildSignUpForm() {
    return Column(
      children: [
        
         Form(
        
        child: Column(
          
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2)),
              )
            ),

            SizedBox(height: 17,),

            TextFormField(
              focusNode: _passwordFocusNode,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2)),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: _togglePassword,
                  ),
              ),
            ),

            SizedBox(height: 17,),

            TextFormField(
              focusNode: _confirmPasswordFocusNode,
              onFieldSubmitted: (_) => _toggleConfirmPassword,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: _toggleConfirmPassword,
                  ),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2)),
              )
            ),

            SizedBox(height: 40,),

            RaisedButton(
              
              padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
              color: Theme.of(context).primaryColor,
               onPressed: () {},
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30),
               ),
               child: Text('CREATE ACCOUNT', style: TextStyle(color: Colors.white),),
            )
          ],
        ) 
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text('Already have an account? ', style: TextStyle(color: Colors.grey),),
        InkWell(
          onTap: (){
            setState(() {
              _isLogin = true;
            });
          }, 
          child: Text('Sign in', style: TextStyle(color: Colors.blue),)
          )
        ],
        ),
      
      ]);
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        Form(
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2)),
              ),
            ),

            SizedBox(height: 17,),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),  
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(width: 2)),
              ),
              
            ),
            SizedBox(height: 40),
            RaisedButton(
              
              padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
              color: Theme.of(context).primaryColor,
               onPressed: () {},
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(30),
               ),
               child: Text('LOGIN', 
               style: TextStyle(color: Colors.white,),
              
               ),
            )
            
          ],
          ),
        ),
        SizedBox(height: 20,),
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text('Not a member yet? ', style: TextStyle(color: Colors.grey),),
        InkWell(
          onTap: (){
            setState(() {
              _isLogin = false;
            });
          }, 
          child: Text('Sign up', style: TextStyle(color: Colors.blue),)
          )
        ],
        ),
      ],

    );
  }

  void _togglePassword(){
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }
}
