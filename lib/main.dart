import 'package:flutter/material.dart';
import 'utils/Global.dart' as global;
import 'utils/AppData.dart' as appData;
import 'game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //required for AppData to function correctly

  global.score = await appData.getInt('score');
  global.topScore = await appData.getInt('topScore');
  global.lastPlayed = await appData.getString('lastPlayed');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Dino Match!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double playImageSize = MediaQuery.of(context).size.width*.35;
    double scoreWidth = playImageSize*2;
    double borderOpacity = .65;

    return Scaffold(
      body: Stack(
          children:[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            if(global.lastPlayed!="")
              Positioned(
                  top:MediaQuery.of(context).size.height*.15,
                  left:((MediaQuery.of(context).size.width - scoreWidth) * .5) - 10,
                  width:scoreWidth+20,
                  height:(scoreWidth*.25)+20,
                  child:Stack(
                      children:[
                        Container(
                          width:scoreWidth+20,
                          height:(scoreWidth*.25)+20,
                          decoration:BoxDecoration(
                              border:Border.all(color:Colors.white, width:5 ),
                              borderRadius:BorderRadius.circular(10)
                          ),
                        ),

                        Center(child:Opacity(
                            opacity:borderOpacity,
                            child:Container(
                              width:scoreWidth+10,
                              height:(scoreWidth*.25)+10,
                              decoration:BoxDecoration(
                                border:Border.all(color:Colors.white, width:15 )
                              ),
                            )
                        )),

                        Center(child:Container(
                            width:scoreWidth,
                            height:(scoreWidth*.25),
                            decoration:BoxDecoration(
                              border:Border.all(color:Color.fromRGBO(83, 162, 207, 1), width:0 ),
                              borderRadius:BorderRadius.circular(5),
                              color:Color.fromRGBO(83, 162, 207, 1),
                            )
                        )),

                        Center(child:Text('LAST SCORE:\n' + global.score.toString(), textAlign:TextAlign.center, style:TextStyle(fontSize:(scoreWidth*.08), fontWeight:FontWeight.bold, color:Colors.white)))
                      ]
                  )
              ),


            GestureDetector(
                onTap:(){
                  //setState((){ global.score = 0; });
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          pageBuilder:(context, animation1, animation2) => Game(),
                          transitionsBuilder:(context, animation, secondaryAnimation, child) => FadeTransition(
                              opacity:animation,
                              child:child
                          )
                      )
                  );
                },
                child:Center(child:Stack(
                    children: [
                      Center(
                          child:Container(
                            width:playImageSize+20,
                            height:playImageSize+20,
                            decoration:BoxDecoration(
                                border:Border.all(color:Colors.white, width:5 ),
                                borderRadius:BorderRadius.circular(playImageSize+20)
                            ),
                          )
                      ),
                      Center(
                          child:Opacity(
                              opacity:borderOpacity,
                              child:Container(
                                width:playImageSize+10,
                                height:playImageSize+10,
                                decoration: BoxDecoration(
                                    border:Border.all(color:Colors.white, width:20),
                                    borderRadius:BorderRadius.circular(playImageSize+10)
                                ),
                              )
                          )
                      ),
                      Center(
                          child:Image.asset("assets/images/play.png", width:playImageSize)
                      )
                    ]
                )
                )
            ),

            if(global.lastPlayed!="")
              Positioned(
                bottom:0,
                left:0,
                child:Container(
                  color:Colors.blue.withOpacity(0.75),
                  padding:EdgeInsets.all(10),
                  child:Row(
                    children: <Widget>[
                      SizedBox(width:(MediaQuery.of(context).size.width*.5)-10, child:Text("Last Played:\n" + global.lastPlayed.toString(), style:TextStyle(color: Colors.white, fontSize:14, fontWeight:FontWeight.bold))),
                      SizedBox(width:(MediaQuery.of(context).size.width*.5)-10, child:Text("Top Score:\n" + global.topScore.toString(), textAlign:TextAlign.right, style:TextStyle(color: Colors.white, fontSize:14, fontWeight:FontWeight.bold)))
                    ],
                  )
                )
              )
        ]
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

