import 'package:provider/provider.dart';
import 'package:sql_todo_app/pages/home.dart';
import 'package:sql_todo_app/providers/checkboxprovider.dart';
import 'package:flutter/material.dart';
import 'package:sql_todo_app/databses/helper.dart';

class Todo extends StatefulWidget {
  String? category;
  int? currentindex;
  Todo(this.category, this.currentindex);

  @override
  State<Todo> createState() => _TodoState(this.category, this.currentindex);
}

class _TodoState extends State<Todo> with SingleTickerProviderStateMixin {
  String? category;
  int? currentindex;
  _TodoState(this.category, this.currentindex);
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _state = Provider.of<Itemchecking>(context, listen: true);
    return (Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 600),
              opacity: _state.visible ? 1.0 : 0.0,
              child: IconButton(
                onPressed: (() {
                  _state.deleteitems(category!);
                  _state.visible = false;
                }),
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 255, 243, 134),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Homepage())))
                  .then((value) {
                setState(() {});
              });
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 243, 134),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(300),
                      bottomRight: Radius.circular(300))),
            ),
            ListTile(
              leading: SizedBox(
                  child: Image.network(
                'https://imgs.search.brave.com/yP_lAhpF8280R52U0Y9NwCN5xsxX3z5cd1Kcx1Q6TLI/rs:fit:461:225:1/g:ce/aHR0cHM6Ly90c2Ux/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5j/eGNxYTlSdmhHblJk/OHgzTjJvQmRnSGFI/biZwaWQ9QXBp',
                fit: BoxFit.fill,
              )),
              title: StreamBuilder(
                stream: Sqlhelper.getcategory().asStream(),
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        (snapshot.data[currentindex]['count(task)']-1).toString(),
                        style: TextStyle(fontSize: 22));
                  } else
                    return Text('');
                }),
              ),
              subtitle: Text(
                '${category}',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            ),
            Expanded(
                child: StreamBuilder(
              stream: Sqlhelper.taskitems(category!).asStream(),
              builder: ((context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: ((context, index) {
                        return _listoftasks(
                            snapshot.data[index]['task'],
                            (snapshot.data[index]['ischecked'] == '1')
                                ? true
                                : false,
                            snapshot.data[index]['id'],
                            _state);
                      }));
                } else {
                  return Text('');
                }
              }),
            ))
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _bottomsheet,
          child: Icon(
            Icons.add,
            size: 50,
          ),
          backgroundColor: Colors.teal[300],
        )));
  }

  //list items
  Widget _listoftasks(String task, bool ischecked, int id, var state) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 35),
      title: Text(
        '${task}',
        style: TextStyle(fontSize: 20),
      ),
      leading: (task.isEmpty)
          ? null
          : Checkbox(
              value: ischecked,
              onChanged: ((value) async {
                setState(() {
                  ischecked = value!;
                });
                await Sqlhelper.update(id, ischecked);
                state.checkcounter(category);
              }),
            ),
    );
  }

  //bottom sheeet
  Future<dynamic> _bottomsheet() {
    TextEditingController _todotextcontroller = TextEditingController();
    return showModalBottomSheet(
        isScrollControlled: true,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: ((context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _todotextcontroller,
                    style: TextStyle(fontSize: 22),
                    decoration: InputDecoration(
                        hintText: 'Add todo',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.teal[300],
                    onPressed: (() {
                      Sqlhelper.addtodo(category!, _todotextcontroller.text)
                          .then(((value) {
                        _todotextcontroller.clear();
                      }));
                    }),
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  )
                ]),
              ));
        }));
  }
}
