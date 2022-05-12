import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'utils/Global.dart' as global;
import 'utils/AppData.dart' as appData;
import 'main.dart';
import 'models/dinos.dart';

loadDinos() {
  var dinoArr = [];
  var rand = Random();
  for (var i = 0; i < 6; i++){
    var r = 1 + rand.nextInt(28);
    if(!dinoArr.contains(r)){ dinoArr.add(r); }
    else{ i--; }
  }

  List<dynamic> dinoData = [
    {"dinos": [
        { "dino": dinoArr[0], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[1], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[2], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[3], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[4], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[5], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[0], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[1], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[2], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[3], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[4], 'selected':false, 'matched':false, 'show':false },
        { "dino": dinoArr[5], 'selected':false, 'matched':false, 'show':false }
      ]
    }
  ];

  String jsonData = json.encode(dinoData);
  List<dynamic> data = json.decode(jsonData)[0]['dinos'];
  List<dinos> dinoList = data.map((dynamic item) => dinos.fromJson(item)).toList();

  dinoList.shuffle();

  return dinoList;
}

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  List<dinos> data = loadDinos();
  int flipSpeed = 300;
  int flipBackDelay = 1000;
  List selected = [];
  bool paused = false;
  bool match = false;
  int matchCount = 0;
  int score = 0;
  int scoreBonus = 0;
  int gameTime = 0;
  bool gameOver = false;

  late Timer timer = new Timer.periodic(new Duration(seconds:1), (timer){
    if(mounted){ setState((){ gameTime++; }); }
    else{ timer.cancel(); }
  });

  checkForMatch(){
    if(selected[0] == selected[1]){
      setState((){
        match = true;
        matchCount++;
        score += 100;
      });
    }
    else{
      setState((){ score -= 10; });
    }

    setState((){
      data.forEach((element){
        if(element.selected){
          Timer(Duration(milliseconds:(flipBackDelay).toInt()),(){
            setState((){
              if(match){ element.matched = true; }
              else{
                element.selected = false;
                element.show = false;
              }
            });
          });
        }
      });

      Timer(Duration(milliseconds:(flipBackDelay).toInt()),(){
        setState((){
          match = false;
          paused = false;
        });
      });

      selected.clear();
    });

    if(matchCount == (data.length/2).toInt()){
      setState((){
        scoreBonus = (50000/gameTime).toInt();
        score+=scoreBonus;
        gameOver = true;

        DateTime _now = DateTime.now();
        String lastPlayed = _now.month.toString() + '/' + _now.day.toString() + '/' +  _now.year.toString() + ' @ ' + (_now.hour>12?_now.hour-12:_now.hour).toString() + ':' + (_now.minute<10?'0'+_now.minute.toString():_now.minute.toString()) + (_now.hour>=12?'pm':'am');

        global.lastPlayed = lastPlayed;
        global.score = score;

        appData.set('string', 'lastPlayed', lastPlayed);
        appData.set('int', 'score', score);

        if(score > global.topScore){
          global.topScore = score;
          appData.set('int', 'topScore', global.score);
        }
      });

      Timer(Duration(milliseconds:(flipBackDelay*1.25).toInt()),(){
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder:(context, animation1, animation2) => MyApp(),
                transitionsBuilder:(context, animation, secondaryAnimation, child) => FadeTransition(
                    opacity:animation,
                    child:child
                )
            )
        );
      });
    }
  }

  @override
  Widget build(BuildContext context){
    double cardSize = MediaQuery.of(context).size.width * .25;
    timer.tick;

    return Scaffold(
      body: Stack(
          children: [
            SizedBox.expand(
                child:FittedBox(
                    fit: BoxFit.fill,
                    child:SizedBox(
                        child: Image.asset('assets/images/bg.jpg')
                    )
                )
            ),
            Center(
              child:Container(
                //height:(cardSize * 4) + (cardSize - 10),
                child:GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left:30, right:30),
                    crossAxisSpacing:20,
                    mainAxisSpacing:0,
                    crossAxisCount:3,
                    shrinkWrap: true,
                    childAspectRatio: (MediaQuery.of(context).size.width / (MediaQuery.of(context).size.width * 1.2)),
                    children: //data.map<Material>( (data) => Material(child:
                        [...data.map((element) =>
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap:(){
                              if(!paused && !element.selected && !element.matched){
                                setState((){ selected.add(element.dino); });

                                setState(() {
                                  element.selected = true;
                                  Timer(Duration(milliseconds:(flipSpeed*.5).toInt()), (){
                                    setState(() {
                                      element.show = true;
                                    });
                                  });
                                });

                                if(selected.length == 2) {
                                  paused = true;
                                  checkForMatch();
                                }
                              }
                            },
                            child: element.matched ?
                              Text("") :
                              AnimatedSwitcher(
                                duration: Duration(milliseconds:flipSpeed),
                                transitionBuilder: __flipTransitionBuilder,
                                child: element.selected ? _cardBack(cardSize, element.dino, element.selected, element.show) : _cardFront(cardSize, element.dino, element.selected, element.show),
                              )
                        )
                    )]
                )
              )
            )
          ]
      ),
    );
  }

  Widget __buildCard({Key? key, double? cardSize, int? dino, bool isFlipped = false, bool show = false}){
    var dinoImage = isFlipped ? Transform(alignment: Alignment.center, transform: Matrix4.rotationY(pi), child: Image.asset("assets/images/dino" + dino.toString() + ".png")) : Image.asset("assets/images/dino" + dino.toString() + ".png");
    return Container(
      key:key,
      width:cardSize,
      height:cardSize,
      decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      padding:EdgeInsets.all(10),
      child: show ? dinoImage : Text(""),
    );
  }

  Widget _cardBack(cardSize, int dino, bool isFlipped, bool show){
    return __buildCard(
      key:ValueKey(true),
      cardSize:cardSize,
      dino:dino,
      isFlipped:isFlipped,
      show:show
    );
  }

  Widget _cardFront(cardSize, int dino, bool isFlipped, bool show){
    return __buildCard(
      key:ValueKey(false),
      cardSize:cardSize,
      dino:dino,
      isFlipped:isFlipped,
      show:show
    );
  }

  Widget __flipTransitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin:pi, end:0.0).animate(animation);
    return AnimatedBuilder(
      animation:rotateAnim,
      child:widget,
      builder:(context, widget) {
        return Transform(
          transform:Matrix4.rotationY(rotateAnim.value),
          child:widget,
          alignment:Alignment.center,
        );
      },
    );
  }
}