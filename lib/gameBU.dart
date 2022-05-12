import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'utils/Global.dart' as global;
import 'main.dart';


class dinos {
  final String dino;
  final bool selected;

  dinos ({
    required this.dino,
    required this.selected
  });

  factory dinos.fromJson(Map<String, dynamic> json) {
    return dinos(
        dino: json['dino'],
        selected: json['selected']
    );
  }
}

loadDinos() {
  List<dynamic> dinoData = [
    {"dinos": [
      {"dino": "dino1", "selected": false},
      {"dino": "dino2", "selected": false},
      {"dino": "dino3", "selected": false},
      {"dino": "dino4", "selected": false},
      {"dino": "dino5", "selected": false},
      {"dino": "dino6", "selected": false}
    ]
    }
  ];

  String jsonData = json.encode(dinoData);
  List<dynamic> data = json.decode(jsonData)[0]['dinos'];
  List<dinos> dinoList = data.map((dynamic item) => dinos.fromJson(item)).toList();
}

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _Game createState() => _Game();
}

//bool isFlipped = true;
bool showDino = false;
int cardSpeed = 300;

class _Game extends State<Game> {

  @override
  Widget build(BuildContext context){
    loadDinos();

    double cardSize = MediaQuery.of(context).size.width * .2;

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
                    height: cardSize * 8,
                    child:GridView.count(
                        crossAxisCount:3,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(12, (index) {
                          return Center(
                              child: GestureDetector(
                                  onTap:(){
                                    print(index);
                                    setState((){
                                      Timer(Duration(milliseconds:(cardSpeed*.5).toInt()), (){
                                        setState(() {
                                          showDino = !showDino;
                                        });
                                      });
                                    });
                                  },
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds:cardSpeed),
                                    transitionBuilder: __flipTransitionBuilder,
                                    //child: isBack ? Container() : Container(child:Image.asset("assets/images/dino1.png")),
                                    child: Image.asset("assets/images/dino1.png"),
                                  )
                              )
                          );
                        })
                    )
                )
            )
          ]
      ),
    );
  }

  _card(cardSize, index, isFlipped){
    return GestureDetector(
        onTap:(){
          print(index);
          setState((){
            isFlipped = !isFlipped;
            Timer(Duration(milliseconds:(cardSpeed*.5).toInt()), (){
              setState(() {
                showDino = !showDino;
              });
            });
          });
        },
        child: AnimatedSwitcher(
          duration: Duration(milliseconds:cardSpeed),
          transitionBuilder: __flipTransitionBuilder,
          //child: isBack ? Container() : Container(child:Image.asset("assets/images/dino1.png")),
          child: isFlipped ? _cardBack(cardSize, "dino1", isFlipped) : _cardFront(cardSize, "dino1", isFlipped),
        )
    );
  }

  Widget __buildCard({Key? key, double? cardSize, String? dino, bool isFlipped = false}) {
    var dinoImage = isFlipped ? Transform(alignment: Alignment.center, transform: Matrix4.rotationY(pi), child: Image.asset("assets/images/" + dino! + ".png")) : Image.asset("assets/images/" + dino! + ".png");
    return Container(
      key: key,
      width:cardSize,
      height:cardSize,
      decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      padding:EdgeInsets.all(10),
      child: showDino ? dinoImage : Text(""),
    );
  }

  Widget _cardBack(cardSize, String dino, bool isFlipped){
    return __buildCard(
        key:ValueKey(true),
        cardSize:cardSize,
        dino:dino,
        isFlipped:isFlipped
    );
  }

  Widget _cardFront(cardSize, String dino, bool isFlipped){
    return __buildCard(
        key:ValueKey(false),
        cardSize:cardSize,
        dino:dino,
        isFlipped:isFlipped
    );
  }

  Widget __flipTransitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin:pi, end:0.0).animate(animation);
    return AnimatedBuilder(
      animation:rotateAnim,
      child:widget,
      builder:(context, widget) {
        //print(rotateAnim.value);
        return Transform(
          transform:Matrix4.rotationY(rotateAnim.value),
          child:widget,
          alignment:Alignment.center,
        );
      },
    );
  }
}