import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizmaker/model/question_model.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/result.dart';
import 'package:quizmaker/widgets/quiz_play_widgets.dart';
import 'package:quizmaker/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  
  final String quizId;
  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

	/// Stream	
Stream infoStream;

class _PlayQuizState extends State<PlayQuiz> {

  DatabaseService databaseService = new DatabaseService();
  QuerySnapshot questionSnapshot;
  bool isLoading = true;


  QuestionModel getQuestionModelFromDatasnapshot(DocumentSnapshot questionSnapshot){

      QuestionModel questionModel = new QuestionModel();

      questionModel.question = questionSnapshot.data["question"];

      List<String> options = [

          questionSnapshot.data["option1"],
          questionSnapshot.data["option2"],
          questionSnapshot.data["option3"],
          questionSnapshot.data["option4"],
      ];

      options.shuffle();

      questionModel.option1 = options[0];
      questionModel.option2 = options[1];
      
      questionModel.option3 = options[2];
      
      questionModel.option4 = options[3];
      
      questionModel.correctoption =  questionSnapshot.data["option1"];
      questionModel.answered = false;

      return questionModel;

  }

  @override
  void initState() {
    // TODO: implement initState
    
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId).then((value){
        questionSnapshot = value;
        _notAttempted = questionSnapshot.documents.length;
        _correct = 0;
        _incorrect = 0;
        isLoading = false;

        total = questionSnapshot.documents.length;

        setState(() {
          
        });
    });

     if(infoStream == null){	
      infoStream = Stream<List<int>>.periodic(	
        Duration(milliseconds: 100), (x){	
         // print("this is x $x");	
          return [_correct, _incorrect] ;	
      });	
    }

    super.initState() ;

  }

  @override	
  void dispose() {	
    infoStream = null;	
    super.dispose();	
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
            child: Container(
                child: Column(
                  children: [
                    InfoHeader(
                      length: questionSnapshot.documents.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questionSnapshot.documents == null
                        ? Container(
                      child: Center(child: Text("No Data"),),
                    )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal:24),
                            itemCount: questionSnapshot.documents.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return QuizPlayTile(
                                questionModel: getQuestionModelFromDatasnapshot(
                                    questionSnapshot.documents[index]),
                                index: index,
                              );
                            })
                  ],
                ),
              ),
          ),
                  floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
           onPressed: (){
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Results(
               correct : _correct, 
               incorrect: _incorrect, 
               total: total)
             
             ));
           },
        ),
        

    );
  }
}


class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({@required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot){
        return snapshot.hasData ? Container(
          height: 40,
          //margin: EdgeInsets.only(left: 14),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              NoOfQuestionTile(
                text: "Total",
                number: widget.length,
              ),
              NoOfQuestionTile(
                text: "Correct",
                number: _correct,
              ),
              NoOfQuestionTile(
                text: "Incorrect",
                number: _incorrect,
              ),
              NoOfQuestionTile(
                text: "NotAttempted",
                number: _notAttempted,
              ),
            ],
          ),
        ) : Container();
      }
    );
  }
}


class QuizPlayTile extends StatefulWidget {


  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  
  String optionSelected = "";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
            Text("Q${widget.index + 1}. ${widget.questionModel.question}" , style: TextStyle(fontSize : 17,color: Colors.black87 ),),
            SizedBox(height: 12,),
            GestureDetector(
                onTap: (){
                  if(!widget.questionModel.answered){
                    if(widget.questionModel.option1 == 
                    widget.questionModel.correctoption){
                      optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });

                    }

                    else{

                      optionSelected = widget.questionModel.option1;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });


                    }
                  }

                },
                child: OptionTile(
                correctAnswer: widget.questionModel.correctoption,
                description: widget.questionModel.option1,
                option: "A",
                optionSelected: optionSelected,

              ),
            ),


             SizedBox(height: 4,),
            GestureDetector(

                              onTap: (){
                  if(!widget.questionModel.answered){
                    if(widget.questionModel.option2 == 
                    widget.questionModel.correctoption){
                      optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });

                    }

                    else{

                      optionSelected = widget.questionModel.option2;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });


                    }
                  }

                },


               child: OptionTile(
                correctAnswer: widget.questionModel.correctoption,
                description: widget.questionModel.option2,
                option: "B",
                optionSelected: optionSelected,

              ),
            ),


             SizedBox(height: 4,),
            GestureDetector(
                              onTap: (){
                  if(!widget.questionModel.answered){
                    if(widget.questionModel.option3 == 
                    widget.questionModel.correctoption){
                      optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });

                    }

                    else{

                      optionSelected = widget.questionModel.option3;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });


                    }
                  }

                },
                child: OptionTile(
                correctAnswer: widget.questionModel.correctoption,
                description: widget.questionModel.option3,
                option: "C",
                optionSelected: optionSelected,

              ),
            ),


             SizedBox(height: 4,),
            GestureDetector(
                              onTap: (){
                  if(!widget.questionModel.answered){
                    if(widget.questionModel.option4 == 
                    widget.questionModel.correctoption){
                      optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered = true;
                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });

                    }

                    else{

                      optionSelected = widget.questionModel.option4;
                      widget.questionModel.answered = true;
                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                        setState(() {
                          
                        });


                    }
                  }

                },
                child: OptionTile(
                correctAnswer: widget.questionModel.correctoption,
                description: widget.questionModel.option4,
                option: "D",
                optionSelected: optionSelected,

              ),
            ),
              SizedBox(height:20,),
        ],
      ),
    );
  }
}