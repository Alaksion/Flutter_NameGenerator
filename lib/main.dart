import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StartUp Name Generator',
        home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _wordList = <WordPair>[];
  final _saved = Set<WordPair>();
  final _largeText = TextStyle(fontSize: 18);
  final titleName = "StartUp Name Generator";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _toggleSaved(word){
    setState(() {
      if(_saved.contains(word)){
        _saved.remove(word);
      } else{
        _saved.add(word);
      }
    });
  }
  
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (WordPair word) {
              return ListTile(
                title: Text(
                  word.asPascalCase,
                  style: _largeText,
                ),
                trailing: Icon(Icons.delete_outline),
                onTap: (){_toggleSaved(word);},
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }

  Widget _buildRow(WordPair word) {
    final alreadySaved = _saved.contains(word);
    return ListTile(
        title: Text(
      word.asPascalCase,
      style: _largeText,
    ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border_outlined,
        color: alreadySaved ? Colors.red : Colors.black,
      ),
      onTap: () {_toggleSaved(word);}
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _wordList.length) {
            _wordList.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_wordList[index]);
        });
  }
}
