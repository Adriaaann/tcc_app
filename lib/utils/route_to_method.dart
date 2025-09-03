import 'package:flutter/material.dart';

void RouteToMethod(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
