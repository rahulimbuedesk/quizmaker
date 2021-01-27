import 'package:flutter/material.dart';
import 'package:quizmaker/helper/functions.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/create_quiz.dart';
import 'package:quizmaker/views/play_quiz.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:quizmaker/widgets/widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();
  AuthService authService = new AuthService();



logOut() async{

        await authService.signOut().then((val) => {

             HelperFunctions.saveUserLoggedInDetails(isLoggedin: false),

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) =>SignIn()
              ),
              )         

        });
    }



  Widget quizList(){
    return Container(
      
      margin: EdgeInsets.symmetric(horizontal:24),

      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot){
          return snapshot.data == null 
                ? Container() :
                ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return QuizTile(
                      desc: snapshot.data.documents[index].data["quizDescription"],
                      imgUrl: snapshot.data.documents[index].data["quizImageUrl"], 
                      title: snapshot.data.documents[index].data["quizTitle"],
                      quizId: snapshot.data.documents[index].data["quizId"],);
                });
        },
        ),
    );
  }

@override
  void initState() {
    // TODO: implement initState
    databaseService.getQuizesData().then((val){
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
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
         actions: <Widget>[
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
         onTap: (){
        logOut();     
      },
        child: Icon(
          Icons.logout,
          size: 26.0,
          color: Colors.black54,
        ),
      )
    ),
  ],


        ),
        body: quizList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreateQuiz()
              ));
          },

          ),
    );
  }
}


class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  QuizTile({@required this.desc,@required this.quizId, @required this.imgUrl,@required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayQuiz(
          quizId
        )
        ));
      },
          child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imgUrl,width: MediaQuery.of(context).size.width - 48, fit: BoxFit.cover,)),
            Container(

              decoration: BoxDecoration(
                borderRadius : BorderRadius.circular(8),
                color:Colors.black26,
              ),
              alignment: Alignment.center,
              child:Column(
                
                mainAxisAlignment : MainAxisAlignment.center,
 
                children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                SizedBox(height:6,),
                Text(desc , style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),)

              ],
              )
            )

        ],
        ),
      ),
    );
  }
}