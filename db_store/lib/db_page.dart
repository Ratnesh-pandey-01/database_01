import 'package:db_store/db_helper.dart';
import 'package:flutter/material.dart';

class DBPage extends StatefulWidget {
  @override
  State<DBPage> createState() => _DBPageState();
}

class _DBPageState extends State<DBPage> {
  //DBHelper db = DBHelper.getInstance;

  DBHelper? mainDB;
  List<Map<String, dynamic>> allNotes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    mainDB = DBHelper.getInstance;
    getInitialNotes();
  }

  void getInitialNotes() async {
    allNotes = await mainDB!.getAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text('${allNotes[index][DBHelper.columnNoteSNo]}'),
                  title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                  subtitle: Text(allNotes[index][DBHelper.columnNoteDesc]),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            mainDB!.updateNote(
                                title: "Updated Note",
                                desc: "this is updated",
                                sno: allNotes[index][DBHelper.columnNoteSNo]);
                            getInitialNotes();
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            mainDB!.deleteNote(
                                sno: allNotes[index][DBHelper.columnNoteSNo]);
                            getInitialNotes();
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
                "No Notes Yet!",
                style: TextStyle(fontSize: 25),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //mainDB!.addNote(title: "Note title", desc: "write anything");
          //getInitialNotes();
          showModalBottomSheet(
              //isDismissible: false,
              //enableDrag: false,
              context: context,
              builder: (_) {
                return Container(
                  padding: EdgeInsets.all(11),
                  child: Column(
                    children: [
                      Text(
                        "Add Note",
                        style: TextStyle(fontSize: 21),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            label: Text("Title"),
                            hintText: "Enter title here...",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      TextField(
                        maxLines: 3,
                        controller: descController,
                        decoration: InputDecoration(
                            label: Text("desc"),
                            hintText: "Enter desc here...",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(21))),
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                addNoteInDB();
                                titleController.clear();
                                descController.clear();
                                Navigator.pop(context);
                              },
                              child: Text("Add")),
                          OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("cancel"))
                        ],
                      )
                    ],
                  ),
                );
              });
          getInitialNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  addNoteInDB() async {
    var mtitle = titleController.text.toString();
    var mdesc = descController.text.toString();
    bool check = await mainDB!.addNote(title: mtitle, desc: mdesc);
    String msg = "Note adding failed!";

    if (check) {
      msg = "Notes added successfully!!";
      getInitialNotes();
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
