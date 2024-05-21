import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_list_provider.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookListProvider(),
      child: MaterialApp(
        title: 'Book Scanner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
