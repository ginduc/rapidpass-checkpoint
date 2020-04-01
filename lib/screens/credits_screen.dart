import 'package:flutter/material.dart';

class CreditsScreen extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _screenContent(context),
      ),
    );
  }

  Widget _screenContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xff222321),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10),
            alignment: Alignment.centerRight,
            child: InkWell(
              child: Icon(
                Icons.close,
                color: const Color(0xffff7042),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ),
          Text(
            'Credits',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.10,
                  vertical: MediaQuery.of(context).size.width * 0.10),
              child: ListView.builder(
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      _developers[index]['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
                itemCount: _developers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _developers = [
    {
      'name': 'Alistair Israel',
      'email': 'aisrael@gmail.com',
    },
    {
      'name': 'Joshua Maiquez de Guzman',
      'email': 'joshua.maiquez.deguzman@gmail.com',
    },
    {
      'name': 'Jonathan Mayol',
      'email': 'mayoljonathan@rocketmail.com',
    },
    {
      'name': 'Jan Salvador Sebastian',
      'email': 'sebastian@mclinica.com',
    },
    {
      'name': 'Josef Solon',
      'email': 'josefsolon@gmail.com',
    },
    {
      'name': 'Atik',
      'email': 'atik@live.com.ph',
    },
    {
      'name': 'Ned Palacios',
      'email': 'npdoesmc@gmail.com',
    },
    {
      'name': 'Ryan Jan Borja',
      'email': 'ryanjan18@outlook.ph',
    },
    {
      'name': 'Vince Ramces Oliveros',
      'email': 'blusea231@gmail.com',
    },
    {
      'name': 'Jan Salvador Sebastian',
      'email': 'jansalvadorsebastian@gmail.com',
    },
    {
      'name': 'Jonel Dominic Tapang',
      'email': 'dneljo@yahoo.com',
    },
  ];
}
