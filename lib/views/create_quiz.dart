import 'package:flutter/material.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/addquestion.dart';
import 'package:quizmaker/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  
  final _formKey = GlobalKey<FormState>();

  String quizImageURl = "https://images.unsplash.com/photo-1611182748487-091038c844a2?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0MHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60";

   
  String quizTitle, quizDescription, quizId;
  
  

  DatabaseService databaseService = new DatabaseService();

  bool _isLoading = false;

  createQuizOnline() async {
    if(_formKey.currentState.validate()){
        
         setState(() {
        _isLoading = true;
      });

        quizId = randomAlphaNumeric(16);

        Map<String, String> quizMap = {
          "quizId" : quizId,
          "quizImageUrl" : quizImageURl,
           "quizTitle" : quizTitle,
           "quizDescription":quizDescription

        };

        await databaseService.addQuizData(quizMap,quizId)
        .then((value) => {
          setState((){
            _isLoading = false;
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => AddQuestion(quizId)
              ));

          })

        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
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
            padding: EdgeInsets.symmetric(horizontal:24),  
            child: Column(children:[
                TextFormField(
//                  validator: (val) => val.isEmpty ? (quizImageURl = imageUrl) : null,
                  decoration:InputDecoration(
                    hintText: "Quiz Image Url (Optional)"),
                    onChanged: (val){
                      quizImageURl = val;
                },

                ),
                SizedBox(height:6,),


                  TextFormField(
                  validator: (val) => val.isEmpty ? "Enter quiz title" : null,
                  decoration:InputDecoration(
                    hintText: "Quiz Title"),
                    onChanged: (val){
                      quizTitle= val;
                },

                ),
                SizedBox(height:6,),


                TextFormField(
                  validator: (val) => val.isEmpty ? "Enter Quiz Desciption" : null,
                  decoration:InputDecoration(
                    hintText: "Quiz Description"),
                    onChanged: (val){
                      quizDescription= val;
                },

                ),
                Spacer(),
                GestureDetector(
                  onTap: (){
                    createQuizOnline();
                  },
                  child: blueButton(context : context , label : "Create quiz")),
                SizedBox(height:60,),
            ]),
          ),
        )
      
    );
  }
}