import 'package:flutter/material.dart';
import 'package:quizmaker/helper/functions.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:quizmaker/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

   final _formKey = GlobalKey<FormState>();
  String name,email,password;
   AuthService authService = new AuthService();
  
    bool _isLoading = false;

  signUp() async{
    if(_formKey.currentState.validate()){


      setState(() {
        _isLoading = true;
      });

        await authService.signUpEmailAndPass(email, password).then((val) => {
          if(val != null){

          setState(() {
            _isLoading = false;
          }),

      HelperFunctions.saveUserLoggedInDetails(isLoggedin: true),


      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>Home()
        ),
        )
            
          }
        });

    
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true, // this is all you need
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),),
      )  : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal:24),
                child: Column(
                  children: [
                    Spacer(),

                                        
                   
                    TextFormField(
                      validator: (val){
                         return val.isEmpty ? "Enter Name" : null;
                      },
                      decoration: InputDecoration(
                        hintText: "Name"
                      ),
                      onChanged: (val){
                          name=val;
                      },

                    ),
                   
                   
                   
                    TextFormField(
                      validator: (val) => validateEmail(email)
                                ? null
                                : "Enter correct email",
                      decoration: InputDecoration(
                        hintText: "Email"
                      ),
                      onChanged: (val){
                          email=val;
                      },
                      keyboardType: TextInputType.emailAddress,

                    ),
                    
                    SizedBox(height:6), 

                     TextFormField(
                      obscureText: true,
                      validator: (val) => val.length < 6
                                ? "Password must be 6+ characters"
                                : null,
                      decoration: InputDecoration(
                        hintText: "Password"
                      ),
                      onChanged: (val){
                          password=val;
                      },

                    ), 

                     SizedBox(height:24),
                     GestureDetector(
                       onTap: (){
                         signUp();
                       },
                        child: blueButton(context : context , label : "Sign Up"),
                     ), 

                    SizedBox(height:18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ?",style: TextStyle(fontSize: 15.5),),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => SignIn()
                              )
                              );
                          },
                          child: Text("Sign In",style: TextStyle(fontSize: 15.5,decoration: TextDecoration.underline),
                          ),
                          ),
                          
                        
                    ],
                    ),
                    SizedBox(height:50),

                ],
                ),
        ),
      ),

    );
  }
}



bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
