import 'package:flutter/material.dart';

void routeToMethod(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
