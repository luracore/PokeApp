import 'package:flutter/material.dart';

import 'package:pokeapp/ui/pokedex.dart';

// flutter pub add http

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Pokedex(),
  ));
}
