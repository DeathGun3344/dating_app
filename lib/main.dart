import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0xFFF1F4F3),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Color(0xFF464D76)),
            suffixStyle: TextStyle(color: Color(0xFF464D76)),
            filled: true,
            fillColor: Colors.white,
          ),
          appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              textTheme: TextTheme(subtitle1: TextStyle(color: Color(0xFF464D76))),
              iconTheme: IconThemeData(color: Color(0xFF464D76)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final double padG = 30;
  final double heigthS = 40;
  final double sizeBtnA = 50;
  final double padBtnA = 5;

  DragStartDetails startDetails;
  DragUpdateDetails updateDetails;

  bool up = false;
  bool op = false;

  AnimationController _controllerScale;
  Animation<double> _animationScale;

  final List<String> images = [
    'https://image.freepik.com/photos-gratuite/jeune-femme-assise-pres-falaise-exterieur-nature-jolie-fille-robe-blanche-posant-plein-air-modele-feminin-posant-dans-champ-journee-ete-ensoleillee_186202-7474.jpg',
    'https://image.freepik.com/photos-gratuite/jeune-femme-assise-pres-falaise-exterieur-nature-jolie-fille-robe-blanche-posant-plein-air-modele-feminin-posant-dans-champ-journee-ete-ensoleillee_186202-7470.jpg',
    'https://image.freepik.com/photos-gratuite/jolie-femme-noire-regarde-spectacle-ecouteurs-ordinateur-portable-beneficie-volume-eleve-ecoute-livre-audio-se-prepare-pour-cours-se-promene-pendant-journee-ete-ensoleillee-porte-combinaison-jean-navigue-internet_273609-29649.jpg',
    'https://image.freepik.com/photos-gratuite/femme-africaine-romantique-coiffure-mode-assise-son-lieu-travail-analyse-donnees-portrait-interieur-etudiante-noire-travaillant-ordinateur-portable-avant-examen_197531-3782.jpg'
  ];

  initState() {
    super.initState();
    _controllerScale = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animationScale = Tween<double>(begin: 0.85, end: .7).animate(_controllerScale);
    _controllerScale.addListener(() {
      if (_controllerScale.status == AnimationStatus.completed) {
        op = true;
      } else if (_controllerScale.status == AnimationStatus.dismissed || _controllerScale.status == AnimationStatus.reverse) {
        op = false;
      }
      if (!mounted) return;
      setState(() => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => null,
        ),
        title: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: up
                ? Text(
                    'Discover',
                    style: Theme.of(context).appBarTheme.textTheme.subtitle1,
                  )
                : Text(
                    'Discover',
                    style: Theme.of(context).appBarTheme.textTheme.subtitle1,
                  )),
        actions: [IconButton(icon: Icon(Icons.notification_important), onPressed: () => null)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * .8,
                child: Stack(
                  children: [
                    Container(
                      height: heigthS,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: padG + 10),
                      child: searchBar(),
                    ),
                    AnimatedPadding(
                      padding: up ? EdgeInsets.zero : EdgeInsets.only(top: heigthS * 1.5),
                      duration: Duration(milliseconds: 500),
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: op ? 1 : 0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: .3,
                                child: Container(
                                  height: double.infinity,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: images
                                        .map((e) => Container(
                                              margin: EdgeInsets.only(left: padG, top: 10, bottom: 10),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  image: DecorationImage(image: NetworkImage(e), fit: BoxFit.cover)),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: FractionallySizedBox(
                                heightFactor: _animationScale.value,
                                child: GestureDetector(
                                    onVerticalDragStart: (drag) {
                                      startDetails = drag;
                                    },
                                    onVerticalDragUpdate: (drag) {
                                      updateDetails = drag;
                                    },
                                    onVerticalDragEnd: (drag) {
                                      double dx = updateDetails.globalPosition.dx - startDetails.globalPosition.dx;
                                      double dy = updateDetails.globalPosition.dy - updateDetails.globalPosition.dy;

                                      double velocity = drag.primaryVelocity;

                                      if (dx < 0) dx = -dx;
                                      if (dy < 0) dy = -dy;

                                      if (velocity < 0) {
                                        print('up');
                                        up = true;
                                        _controllerScale.forward();
                                      } else {
                                        print('down');
                                        up = false;
                                        _controllerScale.reverse();
                                      }
                                      setState(() => null);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: padG),
                                      child: genImage(),
                                    ))),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                                heightFactor: 0.3,
                                child: Column(
                                  children: [
                                    Expanded(child: Container()),
                                    Expanded(
                                        flex: 2,
                                        child: AnimatedOpacity(
                                          duration: Duration(milliseconds: 250),
                                          opacity: up ? 0 : 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              actionBtn(icon: FontAwesomeIcons.times, color: Color(0xFFF4CB4C), label: 'Nope'),
                                              SizedBox(
                                                width: padBtnA,
                                              ),
                                              actionBtn(
                                                  icon: FontAwesomeIcons.angleDoubleUp,
                                                  color: Color(0xFF68B9A6),
                                                  label: 'Profile'),
                                              SizedBox(
                                                width: padBtnA,
                                              ),
                                              actionBtn(
                                                  icon: FontAwesomeIcons.solidHeart, color: Color(0xFFEC5757), label: 'Like'),
                                            ],
                                          ),
                                        )),
                                    Expanded(child: Container()),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            if (op) desc()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: 0,
        showElevation: false,
        backgroundColor: Colors.white,
        onItemSelected: (index) => setState(() => null),
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.insert_drive_file,
              color: Colors.red,
            ),
            title: Text(
              'Discover',
              style: TextStyle(color: Color(0xFF60627B)),
            ),
            activeColor: Colors.grey,
          ),
          BottomNavyBarItem(icon: FaIcon(FontAwesomeIcons.solidComments), title: Text('Chat'), inactiveColor: Colors.grey),
          BottomNavyBarItem(icon: FaIcon(FontAwesomeIcons.solidHeart), title: Text('Like'), inactiveColor: Colors.grey),
          BottomNavyBarItem(icon: FaIcon(FontAwesomeIcons.solidUserCircle), title: Text('Profile'), inactiveColor: Colors.grey),
        ],
      ),
    );
  }

  Widget desc() {
    return Container(
      margin: EdgeInsets.all(padG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Color(0xFF4D4B78),
                    fontSize: 25
                ),
                children: [
                  TextSpan(text: 'Devon Laila ', style: TextStyle(fontWeight: FontWeight.bold,)),
                  TextSpan(text: '(22) '),
                ]
              )
          ),
          ...[
            {
              'icon': FontAwesomeIcons.mapMarkerAlt,
              'label': '2.6 km of you'
            },
            {
              'icon': FontAwesomeIcons.userGraduate,
              'label': 'Kumudini Govt. Women College'
            },
          ].map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                            alignment: Alignment.centerLeft,
                            child: Icon(e['icon'], size: 16, color: Color(0xFF9CA0A9),)),
                        Text(e['label'], style: TextStyle(color: Color(0xFF9CA0A9)),)
                      ],
                    ),
                  )
          ).toList(),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('About:', style: TextStyle(color: Color(0xFF4D4B78), fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          Text(
              'Hello! I am Devon Laila from Canada. I\'m single & interested to man for building friendship. Usually, I love to listen to songs, reading books, watching TV, and treveling to the reserve side.\n\n'
                  'Completely transform low-risk high-yield scenario and prospective collaboration and  idea-sharing.', style: TextStyle(color: Color(0xFF9B9FA9)),),
          Divider(),
          Text('Report Devon Laila', style: TextStyle(color: Color(0xFF9B9FA9), fontSize: 25),),
          Divider(),
          Container(
            height: sizeBtnA,
            child: Row(
              children: [
                Expanded(
                    child: actionBtn(
                      icon: FontAwesomeIcons.times,
                      color: Color(0xFFF19E49),
                      label: ''
                    )
                ),
                Expanded(
                  flex: 3,
                    child: RaisedButton(
                        onPressed: () => null,
                      color: Color(0xFF43C09A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Container(
                        height: sizeBtnA,
                        alignment: Alignment.center,
                        child: Text('Invite Devon', style: TextStyle(color: Colors.white),),
                      ),
                    )
                ),
                Expanded(
                    child: actionBtn(
                        icon: FontAwesomeIcons.solidHeart,
                        color: Color(0xFFEA5555),
                        label: ''
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget actionBtn({@required IconData icon, @required Color color, @required String label}) {
    return Container(
      width: sizeBtnA,
      child: Column(
        children: [
          Expanded(child: Container()),
          Container(
            width: sizeBtnA,
            height: sizeBtnA,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(sizeBtnA), color: Colors.white),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          Expanded(
              child: Text(
            label,
            style: TextStyle(color: Color(0xFF51536B), fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }

  Widget genImage() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://image.freepik.com/photos-gratuite/modele-posant-journee-ensoleillee-grand-paysage-ensoleille-autour-elle-jeune-femme-debout-pres-falaise-belle-vue-derriere-dos-jolie-fille-robe-blanche-posant-exterieur_186202-7477.jpg'))),
        child: imageStack());
  }

  Widget imageStack() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 250),
      opacity: up ? 0 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(style: TextStyle(fontSize: 25), children: [
              TextSpan(text: 'Devon Laila ', style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '(22)'),
            ])),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white.withOpacity(.3)),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '2.6 km of you',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white.withOpacity(.3)),
                    child: Text(
                      'Dhanmondi',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'See More',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return TextField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
          hintText: 'Search',
          suffixIcon: Icon(Icons.search)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controllerScale?.dispose();
  }
}
