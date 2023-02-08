import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final List<String> _notes = [];

  void _addNote(String note) {
    setState(() {
      _notes.add(note);
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _updateNote(int index, String newNote) {
    setState(() {
      _notes[index] = newNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notes[index]),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return NoteEditor(
                      index: index,
                      initialNote: _notes[index],
                      onUpdate: _updateNote,
                    );
                  },
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteNote(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final _controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add Note'),
                content: TextField(
                  controller: _controller,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addNote(_controller.value.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteEditor extends StatefulWidget {
  final int index;
  final String initialNote;
  final Function(int, String) onUpdate;

  NoteEditor({
    required this.index,
    required this.initialNote,
    required this.onUpdate,
  });

  @override
  _NoteEditorState createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialNote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          widget.onUpdate(widget.index, _controller.value.text);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}


