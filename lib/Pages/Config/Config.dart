import 'package:flutter/material.dart';
import 'package:rastrear/Pages/Config/FAQ.dart';
import 'package:url_launcher/url_launcher.dart';

class Config extends StatefulWidget
{
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config>
{
  Widget WidgetConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Icon(Icons.account_box, size: 92, color: Colors.pink),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Seu perfil",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Minha Fonte",
                      color: Colors.black87
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Precisa de ajuda?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Minha Fonte",
                      color: Colors.grey
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            )
          ],
        ),
        Divider(height: 10, color: Colors.black87),
        SizedBox(height: 10),
        Text(
          "SUAS PREFERÊNCIAS",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: "Minha Fonte",
              color: Colors.grey
          ),
          textAlign: TextAlign.left,
        ),
        FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).push(_createRoute(FAQ()));
          },
          child: Row(
            children: <Widget>[
              Icon(Icons.help, size: 30, color: Colors.black54),
              SizedBox(width: 10),
              Text(
                "FAQ",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Minha Fonte",
                    color: Colors.grey
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            const url = 'https://play.google.com/store/apps/details?id=br.dexter.rastrear';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Impossível abrir: $url';
            }
          },
          child: Row(
            children: <Widget>[
              Icon(Icons.star, size: 30, color: Colors.black54),
              SizedBox(width: 10),
              Text(
                "Avaliar aplicativo",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Minha Fonte",
                    color: Colors.grey
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
        child: WidgetConfig()
    );
  }

  Route _createRoute(Page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
