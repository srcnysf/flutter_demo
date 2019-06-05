import 'dart:async';
import 'package:flutter_web/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

void main() {
  runApp(new MaterialApp(home: new HomePage()));
}
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

List data;
List<User> userlist = new List();
List<User> usersavedlist = new List();
int rowNumber;

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UserList Flutter',
      home: new Scaffold(
        // drawer: new Drawer(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(8,8,8,8),
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           child: listView(),
        //         ),
        //         Container(
        //           child: Text("Click Mee 2"),
        //         ),
        //         Container(
        //           child: Text("Click Meee3"),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        appBar: new AppBar(
          title: new Text('UserList Flutter'),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
        ),
        body: listView(),
      ),
    );
  }

  Future<String> fetchData() async {
    final url =
        'https://raw.githubusercontent.com/highmobdevelopment/userlist/master/contacts.json';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('succesfull parse');

      this.setState(() {
        data = json.decode(response.body);
        data.forEach((element) => userlist.add(new User.fromJson(element)));
      });
    }

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  listView() {
    return new ListView.builder(
      itemCount: userlist == null ? 0 : userlist.length,
      itemBuilder: (context, rowNumber) {
        return new Column(
          children: <Widget>[_buildRow(rowNumber, userlist), const Divider()],
        );
      },
    );
  }

  Widget _buildRow(rowNumber, userlist) {
    final bool alreadySaved = usersavedlist.contains(userlist[rowNumber]);

    return new ListTile(
      title: new Text(
        userlist[rowNumber].name + " " + userlist[rowNumber].surname,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.star : Icons.star_border,
        color: alreadySaved ? Colors.yellow : Colors.blue,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            usersavedlist.remove(userlist[rowNumber]);
          } else {
            usersavedlist.add(userlist[rowNumber]);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = usersavedlist.map(
            (User pair) {
              return new ListTile(
                title: new Text(
                  pair.name,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
